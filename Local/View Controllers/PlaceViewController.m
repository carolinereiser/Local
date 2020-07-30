//
//  PlaceViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/28/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "PlaceViewController.h"
#import "ProfileViewController.h"
#import "Spot.h"
#import "TimelineCell.h"

@interface PlaceViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<Spot *> *spots;

@end

@implementation PlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.placeName.text = self.place.name;
    self.userName.text = [NSString stringWithFormat:@"@%@", self.user.username];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchSpots];
}

- (void)fetchSpots {
    PFQuery* query = [PFQuery queryWithClassName:@"Spot"];
    [query whereKey:@"place" equalTo:self.place];
    [query whereKey:@"user" equalTo:self.user];
    [query includeKey:@"user"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable spots, NSError * _Nullable error) {
        if(spots) {
            self.spots = spots;
            NSLog(@"%@", self.spots);
            [self.tableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TimelineCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"TimelineCell" forIndexPath:indexPath];
    
    Spot* spot = self.spots[indexPath.row];
    [cell setSpot:spot];
    cell.profileButton.tag = indexPath.row;
    cell.commentButton.tag = indexPath.row;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.spots.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ProfileViewController *profileViewController = [segue destinationViewController];
    PFUser *user = self.user;
    profileViewController.user = user;
}


@end
