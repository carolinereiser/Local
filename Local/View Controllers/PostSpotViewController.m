//
//  PostSpotViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/17/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "PostSpotViewController.h"

@import GooglePlaces;
@import MBProgressHUD;

@interface PostSpotViewController () <GMSAutocompleteViewControllerDelegate>

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSString* formattedAddress;
@property (nonatomic, strong) NSString* placeID;
@property (nonatomic, weak) NSString* city;
@property (nonatomic, strong) NSString* country;

@end

@implementation PostSpotViewController{
 GMSAutocompleteFilter *filter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@", self.place);
}

- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
    self.latitude = place.coordinate.latitude;
    self.longitude = place.coordinate.longitude;
    self.placeID = place.placeID;
    self.formattedAddress = place.formattedAddress;
    self.address.text = self.formattedAddress;
    
    //is there more time efficient way to do this?
    for (int i = 0; i < [place.addressComponents count]; i++)
    {
        NSLog(@"name %@ = type %@", place.addressComponents[i].name, place.addressComponents[i].types[0]);
        if([place.addressComponents[i].types[0] isEqualToString:@"locality"])
        {
            self.city = place.addressComponents[i].name;
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

- (IBAction)addAddress:(id)sender {
    NSLog(@"HEY!");
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;

    // Specify the place data types to return.
    GMSPlaceField fields = (GMSPlaceFieldName | GMSPlaceFieldPlaceID |GMSPlaceFieldCoordinate | GMSPlaceFieldFormattedAddress |GMSPlaceFieldAddressComponents);
    acController.placeFields = fields;

    // Specify a filter.
    filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
    acController.autocompleteFilter = filter;

    // Display the autocomplete view controller.
    [self presentViewController:acController animated:YES completion:nil];
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
