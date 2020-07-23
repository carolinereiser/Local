//
//  HomeViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/22/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "HomeViewController.h"
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
    PFQuery *query = [PFQuery queryWithClassName:@"Spot"];
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
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feed.count;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
