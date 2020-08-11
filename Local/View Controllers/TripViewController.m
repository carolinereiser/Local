//
//  TripViewController.m
//  Local
//
//  Created by Caroline Reiser on 8/11/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "TripViewController.h"

@import GooglePlaces;

@interface TripViewController () <GMSAutocompleteViewControllerDelegate>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, weak) NSArray *spots;

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

- (IBAction)didSlide:(id)sender {
    int val = self.slider.value + 0.5;
    if(val == 1) {
        self.daysLabel.text = @"1 day";
    }
    else {
        self.daysLabel.text = [NSString stringWithFormat:@"%d days", val];
    }
}

- (IBAction)generate:(id)sender {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
