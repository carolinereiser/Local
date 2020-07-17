//
//  SettingsViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/15/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "LogInViewController.h"
#import "Parse/Parse.h"
#import "SettingsViewController.h"
#import "SceneDelegate.h"

@import GooglePlaces;
@import MBProgressHUD;

@interface SettingsViewController () <GMSAutocompleteViewControllerDelegate>

@end

@implementation SettingsViewController {
 GMSAutocompleteFilter *filter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getAddress];
}

- (void)reloadData {
    [self getAddress];
}

- (void)getAddress {
    //TODO: Use CoreData to load address when no network connection
    PFUser* user = [PFUser currentUser];
    if(user[@"placeName"])
    {
        self.userAddress.text = user[@"placeName"];
    }
}

- (IBAction)logOut:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error)
    {
        if(error)
        {
            NSLog(@"%@", error.localizedDescription);
        }
        else
        {
            NSLog(@"Successfully logged out!");
        }
    }];
    
    //navigate back to login page
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.parentViewController.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LogInViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
}

- (IBAction)enterAddress:(id)sender {
    //Google Places autocomplete search controller
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;

    // Specify the place data types to return.
    GMSPlaceField fields = (GMSPlaceFieldName | GMSPlaceFieldPlaceID |GMSPlaceFieldCoordinate | GMSPlaceFieldFormattedAddress);
    acController.placeFields = fields;

    // Specify a filter.
    filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
    acController.autocompleteFilter = filter;

    // Display the autocomplete view controller.
    [self presentViewController:acController animated:YES completion:nil];
}

  // Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    //Add place to user
    PFUser* user = [PFUser currentUser];
    user[@"lat"] = [NSDecimalNumber numberWithFloat:place.coordinate.latitude];
    user[@"lng"] = [NSDecimalNumber numberWithFloat:place.coordinate.longitude];
    user[@"placeID"] = place.placeID;
    user[@"placeName"] = place.formattedAddress;
        
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded)
        {
            NSLog(@"Successfully saved address!");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self reloadData];
        }
        else
        {
            NSLog(@"Failed to save");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(NSError *)error {
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
