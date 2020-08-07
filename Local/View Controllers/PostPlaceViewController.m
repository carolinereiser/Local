//
//  PostPlaceViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/16/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "Place.h"
#import "PostPlaceViewController.h"

@import GooglePlaces;
@import MBProgressHUD;

@interface PostPlaceViewController () <GMSAutocompleteViewControllerDelegate>

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSString* formattedAddress;
@property (nonatomic, strong) NSString* placeID;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* country;
@property (nonatomic, strong) NSString* adminArea;

@end

@implementation PostPlaceViewController {
 GMSAutocompleteFilter *filter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.picture.image = self.image;
    self.city = nil;
    self.country = nil;
    // Do any additional setup after loading the view.
}
- (IBAction)postPlace:(id)sender {
    //make sure user can't add without adding a location
    if([self.placeID isKindOfClass:[NSString class]])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //check to see if the user has already posted that place
        PFQuery *query = [PFQuery queryWithClassName:@"Place"];
        [query whereKey:@"placeID" equalTo:self.placeID];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
            if(posts != nil)
            {
                //the user already has that place
                if([posts count] >= 1)
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    //present an alert
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You have already added this place" message:@"Please select a place you haven't added." preferredStyle:(UIAlertControllerStyleAlert)];
                    // create a cancel action
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                    {}];
                    // add the cancel action to the alertController
                    [alert addAction:okAction];

                    [self presentViewController:alert animated:YES completion:^{
                    }];
                }
                //the user hasn't posted the place...post it
                else
                {
                    [Place postPlace:self.formattedAddress withId:self.placeID Image:self.picture.image Latitude:self.latitude Longitude:self.longitude City:self.city Country:self.country Admin:self.adminArea withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                        if(succeeded)
                        {
                            NSLog(@"Successfully added Place!");
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            [self.navigationController popToRootViewControllerAnimated: YES];
                        }
                        else
                        {
                            NSLog(@"ERROR: %@", error.localizedDescription);
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                        }
                    }];
                }
            }
            else
            {
                NSLog(@"Error: %@", error.localizedDescription);
            }
        }];
    }
    else
    {
        //present an alert
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select a location" message:@"You can't add a place without a location" preferredStyle:(UIAlertControllerStyleAlert)];
        // create a cancel action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
        {}];
        // add the cancel action to the alertController
        [alert addAction:okAction];

        [self presentViewController:alert animated:YES completion:^{
            // nothing happens when done presenting
        }];
    }
}

- (IBAction)addPlace:(id)sender {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;

    // Specify the place data types to return.
    GMSPlaceField fields = (GMSPlaceFieldName | GMSPlaceFieldPlaceID |GMSPlaceFieldCoordinate | GMSPlaceFieldFormattedAddress | GMSPlaceFieldAddressComponents);
    acController.placeFields = fields;

    // Specify a filter.
    filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterRegion;
    acController.autocompleteFilter = filter;

    // Display the autocomplete view controller.
    [self presentViewController:acController animated:YES completion:nil];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
    self.latitude = place.coordinate.latitude;
    self.longitude = place.coordinate.longitude;
    self.placeID = place.placeID;
    self.formattedAddress = place.formattedAddress;
    self.place.text = self.formattedAddress;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
