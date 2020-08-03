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
            if([places count] >= 1)
            {
                self.places = places;
                //NSLog(@"%@", self.places);
                [self.tableView reloadData];
            }
            else
            {
                //present an alert
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You don't have any places" message:@"You must post a place before you post any spots" preferredStyle:(UIAlertControllerStyleAlert)];
                // create a cancel action
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                {
                }];
                // add the cancel action to the alertController
                [alert addAction:okAction];

                [self presentViewController:alert animated:YES completion:^{
                }];
            }
        }
        else
        {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PlaceInfoCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PlaceInfoCell" forIndexPath:indexPath];
    cell.name.text = self.places[indexPath.row][@"name"];
    //NSLog(@"%@", place);
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
     UITableViewCell *tappedCell = sender;
     NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
     Place *tappedPlace = self.places[indexPath.row];
     PostSpotViewController *postSpotViewController = [segue destinationViewController];
     postSpotViewController.place = tappedPlace;
     postSpotViewController.images = self.images;
}



- (IBAction)nextButton:(id)sender {
}
@end
