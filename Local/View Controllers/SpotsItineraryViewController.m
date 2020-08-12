//
//  SpotsItineraryViewController.m
//  Local
//
//  Created by Caroline Reiser on 8/11/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "Spot.h"
#import "SpotsItineraryViewController.h"
#import "TimelineCell.h"

@import Parse;

@interface SpotsItineraryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<Spot *> *spots;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SpotsItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if(self.adminArea2) {
        self.titleLabel.text = [NSString stringWithFormat:@"Spots in %@", self.adminArea2];
    }
    else if(self.adminArea) {
        self.titleLabel.text = [NSString stringWithFormat:@"Spots in %@", self.adminArea];
    }
    else if(self.country) {
        self.titleLabel.text = [NSString stringWithFormat:@"Spots in %@", self.country];
    }
    
    [self fetchSpots];
}

- (void)fetchSpots {
    PFQuery *query = [PFQuery queryWithClassName:@"Spot"];
    if(self.adminArea2) {
        [query whereKey:@"adminArea2" equalTo:self.adminArea2];
    }
    else if(self.adminArea) {
        [query whereKey:@"adminArea" equalTo:self.adminArea];
    }
    else {
        [query whereKey:@"country" equalTo:self.country];
    }
    [query includeKey:@"user"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable spots, NSError * _Nullable error) {
        if(spots) {
            self.spots = spots;
            NSLog (@"%@", self.spots);
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
