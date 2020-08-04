//
//  PostSpotViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/17/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "PostSpotViewController.h"
#import "Spot.h"

@import GooglePlaces;
@import MBProgressHUD;

@interface PostSpotViewController () <GMSAutocompleteViewControllerDelegate>

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSString* formattedAddress;
@property (nonatomic, strong) NSString* placeID;
@property (nonatomic, weak) NSString* city;
@property (nonatomic, strong) NSString* country;
@property (weak, nonatomic) IBOutlet UITextView *caption;
@property (strong, nonatomic) NSString* name;
@property (weak, nonatomic) IBOutlet UIView *placeView;

@end

@implementation PostSpotViewController{
 GMSAutocompleteFilter *filter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(!self.createPlace) {
        self.placeView.alpha = 0;
    }
}

- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
    self.latitude = place.coordinate.latitude;
    self.longitude = place.coordinate.longitude;
    self.placeID = place.placeID;
    self.formattedAddress = place.formattedAddress;
    self.address.text = self.formattedAddress;
    self.name = place.name;
    
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

- (IBAction)addAddress:(id)sender {
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

- (IBAction)post:(id)sender {
    //make sure user added a spot
    if([self.placeID isKindOfClass:[NSString class]])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //if the user wants to make the place a spot
        if(self.createPlace) {
            self.place = [Place postPlaceFromSpot:self.formattedAddress withId:self.placeID Image:self.images[0] Latitude:self.latitude Longitude:self.longitude City:self.city Country:self.country withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded) {
                    NSLog(@"Successfully added Place!");
                }
            }];
        }
        [Spot postSpot:self.formattedAddress withId:self.placeID Name:self.name Image:self.images Latitude:self.latitude Longitude:self.longitude City:self.city Country:self.country Caption:self.caption.text Place:self.place withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded)
            {
                NSLog(@"Successfully added Spot!");
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.tabBarController setSelectedIndex:0];
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

- (IBAction)didTapOutside:(id)sender {
    [self.caption resignFirstResponder];
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
