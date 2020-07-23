//
//  TakeMeAnywhereSettingsViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/23/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "RandomSpotViewController.h"
#import "Spot.h"
#include <stdlib.h>
#import "TakeMeAnywhereSettingsViewController.h"
#include <time.h>

@import GooglePlaces;
@import Parse;

@interface TakeMeAnywhereSettingsViewController () <GMSAutocompleteViewControllerDelegate>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSArray *spots;
@property (nonatomic, strong) Spot* randomSpot;

@end

@implementation TakeMeAnywhereSettingsViewController{
 GMSAutocompleteFilter *filter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%f", self.currentCoordinate.latitude);
}

//update the milesLabel
- (IBAction)didSlide:(id)sender {
    //update label to reflect how many miles the user has picked
    self.milesLabel.text = [NSString stringWithFormat:@"%d", (int)(self.milesSlider.value+0.5)];
}

- (IBAction)customLocation:(id)sender {
    [self showPlacePicker];
}

- (IBAction)currentLocation:(id)sender {
    if(self.locationServiceEnabled)
    {
        NSLog(@"%f, %f", self.currentCoordinate.latitude, self.currentCoordinate.longitude);
        self.coordinate = self.currentCoordinate;
        self.locationLabel.text = @"Current Location";
    }
    else{
        [self presentErrorAlert];
    }
}

- (void)showPlacePicker {
    //use Google API to select a location
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;

    // Specify the place data types to return.
    GMSPlaceField fields = (GMSPlaceFieldName | GMSPlaceFieldCoordinate);
    acController.placeFields = fields;

    // Specify a filter.
    self->filter = [[GMSAutocompleteFilter alloc] init];
    self->filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
    acController.autocompleteFilter = self->filter;

    // Display the autocomplete view controller.
    [self presentViewController:acController animated:YES completion:nil];
}


- (IBAction)takeMe:(id)sender {
    if([self.locationLabel.text isEqualToString:@""])
    {
        //if they haven't specified where to take them, first try current location
        if(self.locationServiceEnabled) {
            self.coordinate = self.currentCoordinate;
        }
        else {
            //if current location not available, present error
            [self presentErrorAlert];
        }
    }
    PFQuery *query = [PFQuery queryWithClassName:@"Spot"];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    [query whereKey:@"location" nearGeoPoint:geoPoint withinMiles:self.milesSlider.value];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable spots, NSError * _Nullable error) {
        if(spots){
            //TODO:ERROR IF THERE ARE NO SPOTS
            //find random spot
            self.spots = spots;
            srand(time(nil));
            int r = rand() % [self.spots count];
            self.randomSpot = spots[r];
            NSLog(@"%@", self.randomSpot);
            [self performSegueWithIdentifier:@"randomSpotSegue" sender:nil];
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)presentErrorAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error finding Current Location" message:@"Please select a location." preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create a cancel action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
    {
        //present place picker for user to select a place
        [self showPlacePicker];
    }];
    // add the cancel action to the alertController
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        // nothing happens when view controller is done presenting
    }];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
    self.coordinate = place.coordinate;
    self.name = place.name;
    self.locationLabel.text = self.name;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Error: %@", [error description]);
}

  // User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
  [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    RandomSpotViewController *viewController = [segue destinationViewController];
    viewController.spot = self.randomSpot;
}


@end
