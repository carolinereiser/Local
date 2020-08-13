//
//  TripViewController.m
//  Local
//
//  Created by Caroline Reiser on 8/11/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "ParentItineraryViewController.h"
#import "TripViewController.h"

@import GooglePlaces;
@import TravelKit;

@interface TripViewController () <GMSAutocompleteViewControllerDelegate>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* country;
@property (nonatomic, strong) NSString* adminArea;
@property (nonatomic, strong) NSString* adminArea2;


@end

@implementation TripViewController{
 GMSAutocompleteFilter *filter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [self.segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

- (IBAction)selectPlace:(id)sender {
    [self showPlacePicker];
}

- (IBAction)generate:(id)sender {
    //if there is a recorded coordinate
    if(self.coordinate.latitude) {
        [self performSegueWithIdentifier:@"itinerarySegue" sender:nil];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Whoops!" message:@"Please pick a location." preferredStyle:(UIAlertControllerStyleAlert)];
        
        // create a cancel action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
        {
        // handle cancel response here. Doing nothing will dismiss the view.
            [self showPlacePicker];
        }];
        // add the cancel action to the alertController
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
            // nothing happens when view controller is done presenting
        }];
    }
}

- (void)showPlacePicker {
    //use Google API to select a location
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;

    // Specify the place data types to return.
    GMSPlaceField fields = (GMSPlaceFieldName | GMSPlaceFieldCoordinate | GMSPlaceFieldFormattedAddress | GMSPlaceFieldAddressComponents);
    acController.placeFields = fields;

    // Specify a filter.
    self->filter = [[GMSAutocompleteFilter alloc] init];
    self->filter.type = kGMSPlacesAutocompleteTypeFilterRegion;
    acController.autocompleteFilter = self->filter;

    // Display the autocomplete view controller.
    [self presentViewController:acController animated:YES completion:nil];
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
    
    self.city = nil;
    self.adminArea = nil;
    self.adminArea2 = nil;
    self.country = nil;
    for (int i = 0; i < [place.addressComponents count]; i++)
    {
        NSLog(@"name %@ = type %@", place.addressComponents[i].name, place.addressComponents[i].types[0]);
        if([place.addressComponents[i].types[0] isEqualToString:@"locality"])
        {
            self.city = place.addressComponents[i].name;
        }
        else if([place.addressComponents[i].types[0] isEqualToString:@"administrative_area_level_1"]) {
            self.adminArea = place.addressComponents[i].name;
        }
        else if([place.addressComponents[i].types[0] isEqualToString:@"administrative_area_level_2"]) {
            self.adminArea2 = place.addressComponents[i].name;
        }
        else if([place.addressComponents[i].types[0] isEqualToString:@"country"])
        {
            self.country = place.addressComponents[i].name;
        }
    }
    
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
    ParentItineraryViewController *viewController = [segue destinationViewController];
    viewController.coordinate = self.coordinate;
    viewController.name = self.name;
    viewController.city = self.city;
    viewController.country = self.country;
    viewController.adminArea = self.adminArea;
    viewController.adminArea2 = self.adminArea2;
    if([self.segmentedControl selectedSegmentIndex] == 0) {
        viewController.placeCategory = TKPlaceCategorySightseeing;
    }
    else if([self.segmentedControl selectedSegmentIndex] == 1) {
        viewController.placeCategory = TKPlaceCategoryDiscovering;
    }
    else if([self.segmentedControl selectedSegmentIndex] == 2) {
        viewController.placeCategory = TKPlaceCategoryRelaxing;
    }
    else {
        viewController.placeCategory = TKPlaceCategoryNone;
    } 
}

@end
