//
//  SpotPlacePickerViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/17/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <Parse/Parse.h>
#import "Place.h"
#import "PlaceInfoCell.h"
#import "PostSpotViewController.h"
#import "SpotPlacePickerViewController.h"

@interface SpotPlacePickerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) Place* place;

@end

@implementation SpotPlacePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchPlaces];
}

- (void)fetchPlaces
{
    //get the places that the logged in user has uploaded
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query includeKey:@"placeID"];
    [query includeKey:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable places, NSError * _Nullable error) {
        if(places)
        {
            self.places = places;
            [self.tableView reloadData];
        }
        else
        {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    [self.tableView reloadData];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PlaceInfoCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PlaceInfoCell" forIndexPath:indexPath];
    if(indexPath.row == 0) {
        cell.name.text = @"Make Spot it's own Place";
    }
    else {
        cell.name.text = self.places[indexPath.row - 1][@"name"];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count + 1;
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    if(indexPath.row == 0) {
        //make the spot it's own place
        PostSpotViewController *postSpotViewController = [segue destinationViewController];
        postSpotViewController.createPlace = YES;
        postSpotViewController.images = self.images;
    }
    else {
        Place *tappedPlace = self.places[indexPath.row - 1];
        PostSpotViewController *postSpotViewController = [segue destinationViewController];
        postSpotViewController.place = tappedPlace;
        postSpotViewController.images = self.images;
        postSpotViewController.createPlace = NO;
    }
}

@end
