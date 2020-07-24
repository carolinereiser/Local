//
//  HomeViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/22/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "HomeViewController.h"
#import "ProfilePostsViewController.h"
#import "ProfileViewController.h"
#import "Spot.h"
#import "TimelineCell.h"
#import "TimelinePhotoCell.h"

@import MBProgressHUD;
@import Parse;

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<Spot *> *feed;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchFeed];
    
    //pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchFeed) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchFeed {
    //get posts from users that this user follows
    PFQuery *followingQuery = [PFQuery queryWithClassName:@"Following"];
    [followingQuery whereKey:@"follower" equalTo:[PFUser currentUser]];
    
    PFQuery *postsFromFollowedUsers = [PFQuery queryWithClassName:@"Spot"];
    [postsFromFollowedUsers whereKey:@"user" matchesKey:@"following" inQuery:followingQuery];
    
    //get posts this user
    PFQuery *postsFromThisUser = [PFQuery queryWithClassName:@"Spot"];
    [postsFromThisUser whereKey:@"user" equalTo:[PFUser currentUser]];
    
    //NSArray<PFQuery *> *queries = [NSArray arrayWithObjects:@[postsFromThisUser, postsFromFollowedUsers], nil];
    NSLog(@"QUERIES: %@", [NSArray arrayWithObjects:@[postsFromThisUser, postsFromFollowedUsers], nil]);
    //put it together
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[postsFromFollowedUsers, postsFromThisUser]];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *spots, NSError *error) {
        if (spots != nil) {
            // do something with the array of object returned by the call
            self.feed = spots;
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TimelineCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TimelineCell" forIndexPath:indexPath];
    
    Spot* spot = self.feed[indexPath.row];
    [cell setSpot:spot];
    cell.profileButton.tag = indexPath.row;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feed.count;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"profileSegue"]) {
        UIButton *tappedButton = sender;
        ProfileViewController *profileViewController = [segue destinationViewController];
        PFUser *user = self.feed[tappedButton.tag][@"user"];
        profileViewController.user = user;
    }
}


@end
