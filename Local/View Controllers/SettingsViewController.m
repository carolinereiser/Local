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

@interface SettingsViewController () <GMSAutocompleteViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation SettingsViewController {
 GMSAutocompleteFilter *filter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getAddress];
    [self getProfilePic];
}

- (void)reloadData {
    [self getAddress];
    [self getProfilePic];
}

- (void)getAddress {
    //TODO: Use CoreData to load address when no network connection
    PFUser* user = [PFUser currentUser];
    if(user[@"placeName"])
    {
        self.userAddress.text = user[@"placeName"];
    }
}

- (void)getProfilePic{
    //TODO: Use CoreData to load profile pic when no network connection
    PFUser* user = [PFUser currentUser];
    if(user[@"profilePic"])
    {
        self.profilePic.file = user[@"profilePic"];
        [self.profilePic loadInBackground];
    }
}

- (IBAction)editBio:(id)sender {
    PFUser* user = [PFUser currentUser];
    user[@"bio"] = self.bio.text;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded)
        {
            NSLog(@"Successfully changed bio!");
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)editProfilePic:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    //self.picture.image = [self resizeImage:editedImage withSize:(CGSizeMake)(500,500)];
    PFUser* currUser = [PFUser currentUser];
    currUser[@"profilePic"] = [self getPFFileFromImage:editedImage];
    
    [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded)
        {
            NSLog(@"Uploaded profile pic!");
            [self reloadData];
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
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
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude];
    user[@"location"] = geoPoint;
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

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
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
