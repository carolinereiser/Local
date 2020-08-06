//
//  SignUpPlaceViewController.m
//  Local
//
//  Created by Caroline Reiser on 8/3/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "Place.h"
#import "SignUpPlaceViewController.h"

@import GooglePlaces;
@import MBProgressHUD;
@import Parse;
@import YangMingShan;

@interface SignUpPlaceViewController () <GMSAutocompleteViewControllerDelegate>

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSString* formattedAddress;
@property (nonatomic, strong) NSString* placeID;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* country;

@end

@implementation SignUpPlaceViewController {
    GMSAutocompleteFilter *filter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)selectImage:(id)sender {
    YMSPhotoPickerViewController *pickerViewController = [[YMSPhotoPickerViewController alloc] init];
    pickerViewController.numberOfPhotoToSelect = 1;
    
    UIColor *customColor = [UIColor colorWithRed:64.0/255.0 green:0.0 blue:144.0/255.0 alpha:1.0];
    UIColor *customCameraColor = [UIColor colorWithRed:86.0/255.0 green:1.0/255.0 blue:236.0/255.0 alpha:1.0];

    pickerViewController.theme.titleLabelTextColor = [UIColor whiteColor];
    pickerViewController.theme.navigationBarBackgroundColor = customColor;
    pickerViewController.theme.tintColor = [UIColor whiteColor];
    pickerViewController.theme.orderTintColor = customCameraColor;
    pickerViewController.theme.cameraVeilColor = customCameraColor;
    pickerViewController.theme.cameraIconColor = [UIColor whiteColor];
    pickerViewController.theme.statusBarStyle = UIStatusBarStyleLightContent;
    
    [self yms_presentCustomAlbumPhotoView:pickerViewController delegate:self];
    
}

- (void)photoPickerViewControllerDidReceivePhotoAlbumAccessDenied:(YMSPhotoPickerViewController *)picker
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Allow photo album access?", nil) message:NSLocalizedString(@"Need your permission to access photo albums", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertController addAction:dismissAction];
    [alertController addAction:settingsAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)photoPickerViewControllerDidReceiveCameraAccessDenied:(YMSPhotoPickerViewController *)picker
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Allow camera access?", nil) message:NSLocalizedString(@"Need your permission to take a photo", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertController addAction:dismissAction];
    [alertController addAction:settingsAction];

    // The access denied of camera is always happened on picker, present alert on it to follow the view hierarchy
    [picker presentViewController:alertController animated:YES completion:nil];
}

- (void)photoPickerViewController:(YMSPhotoPickerViewController *)picker didFinishPickingImage:(UIImage *)image{
    [picker dismissViewControllerAnimated:YES completion:^() {
        //resize image;
        UIImage* resizedImage = [self resizeImage:image withSize:CGSizeMake(400, 400)];
        self.placePic.image = resizedImage;
    }];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)selectLocation:(id)sender {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;

    // Specify the place data types to return.
    GMSPlaceField fields = (GMSPlaceFieldName | GMSPlaceFieldPlaceID |GMSPlaceFieldCoordinate | GMSPlaceFieldFormattedAddress |GMSPlaceFieldAddressComponents);
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
    self.addressLabel.text = self.formattedAddress;
    
    //is there more time efficient way to do this?
    for (int i = 0; i < [place.addressComponents count]; i++)
    {
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


- (IBAction)post:(id)sender {
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
                    [Place postPlace:self.formattedAddress withId:self.placeID Image:self.placePic.image Latitude:self.latitude Longitude:self.longitude City:self.city Country:self.country withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                        if(succeeded)
                        {
                            NSLog(@"Successfully added Place!");
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            //[self.tabBarController setSelectedIndex:4];
                            [self performSegueWithIdentifier:@"timelineSegue" sender:nil];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
