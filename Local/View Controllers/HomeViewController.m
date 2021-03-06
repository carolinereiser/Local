//
//  HomeViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/22/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "CommentViewController.h"
#import "HomeViewController.h"
#import "ProfilePostsViewController.h"
#import "ProfileViewController.h"
#import "Spot.h"
#import "TimelineCell.h"
#import "TimelinePhotoCell.h"

@import MBProgressHUD;
@import Parse;

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

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
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView reloadEmptyDataSet];
}

- (void)viewDidAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    [self fetchFeed];
}

- (void)fetchFeed {
    //get posts from users that this user follows
    PFQuery *followingQuery = [PFQuery queryWithClassName:@"Following"];
    [followingQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    
    PFQuery *postsFromFollowedUsers = [PFQuery queryWithClassName:@"Spot"];
    [postsFromFollowedUsers whereKey:@"user" matchesKey:@"following" inQuery:followingQuery];
    
    //get posts this user
    PFQuery *postsFromThisUser = [PFQuery queryWithClassName:@"Spot"];
    [postsFromThisUser whereKey:@"user" equalTo:[PFUser currentUser]];
    
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
    if(self.feed.count >= 1) {
        TimelineCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TimelineCell" forIndexPath:indexPath];
        
        Spot* spot = self.feed[indexPath.row];
        [cell setSpot:spot];
        cell.profileButton.tag = indexPath.row;
        cell.commentButton.tag = indexPath.row;
        cell.image.alpha = 0;
        cell.gradientView.alpha = 1;
        
        return cell;
    }
    else {
        TimelineCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TimelineCell" forIndexPath:indexPath];
        cell.profileButton.alpha = 0;
        cell.profilePic.image = [UIImage systemImageNamed:@"smiley.fill"];
        cell.image.alpha = 1;
        cell.gradientView.alpha = 0;
        
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.feed.count > 1) ? self.feed.count : 1;
}

- (IBAction)pressedProfile:(id)sender {
    UIButton *tappedButton = sender;
    PFUser* user = self.feed[tappedButton.tag][@"user"];
    if(![user.username isEqual:[PFUser currentUser].username])
    {
        [self performSegueWithIdentifier:@"profileSegue" sender:sender];
    }
    else
    {
        //if it's the current user, send them to the profile tab
        [self.tabBarController setSelectedIndex:4];
    }
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [self resizeImage:[UIImage imageNamed:@"feed-icon"] withSize:(CGSizeMake(100,100))];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
        NSString *text = @"No Posts";
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                     NSForegroundColorAttributeName: [UIColor systemGray5Color]};
        
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString* text = @"Follow other users to see their favorite spots!";

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor systemGray6Color]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
    else if([[segue identifier] isEqualToString:@"commentSegue"]) {
        UIButton *tappedButton = sender;
        CommentViewController *commentViewController = [segue destinationViewController];
        Spot *spot = self.feed[tappedButton.tag];
        commentViewController.spot = spot;
    }
}


@end
