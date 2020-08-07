//
//  MapViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/22/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "Spot.h"
#import "TakeMeAnywhereSettingsViewController.h"

@import CoreLocation;
@import Parse;

@interface MapViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currLoc;
@property (nonatomic, strong) NSArray<Spot *> *spots;
@property (nonatomic) BOOL locationServiceEnabled;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //in order to get current location
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    //ask for location permissions
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    //get current location
    self.currLoc = [[CLLocation alloc] init];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if(status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.currLoc = self.locationManager.location;
        self.locationServiceEnabled = YES;
    }
    else {
        //make currLoc San Francisco region if can't get current location...not getting here...Why???
        self.currLoc = [[CLLocation alloc] initWithLatitude:37.783333 longitude:-122.416667];
        self.locationServiceEnabled = NO;
    }
    
    //set region for map to show centered around current location
    MKCoordinateRegion currRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.currLoc.coordinate.latitude, self.currLoc.coordinate.longitude), MKCoordinateSpanMake(0.1, 0.1));
    [self.map setRegion:currRegion animated:false];
    [self dropPins];
}

- (void)viewDidAppear:(BOOL)animated {
    [self dropPins];
}

//drop a pin for each spot posted within the region
- (void)dropPins {
    //find all of the spots
    //TODO: only add the pins in the view of the map
    PFQuery *followingQuery = [PFQuery queryWithClassName:@"Following"];
    [followingQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    
    PFQuery *postsFromFollowedUsers = [PFQuery queryWithClassName:@"Spot"];
    [postsFromFollowedUsers whereKey:@"user" matchesKey:@"following" inQuery:followingQuery];
    
    //get posts this user
    PFQuery *postsFromThisUser = [PFQuery queryWithClassName:@"Spot"];
    [postsFromThisUser whereKey:@"user" equalTo:[PFUser currentUser]];
    
    //put it together
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[postsFromFollowedUsers,postsFromThisUser]];
    [query includeKey:@"user"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable spots, NSError * _Nullable error) {
        if(spots) {
            self.spots = spots;
            for(int i =0; i<[self.spots count]; i++) {
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:Nil];
                annotation.coordinate = CLLocationCoordinate2DMake(self.spots[i].location.latitude, self.spots[i].location.longitude);;
                annotation.title = self.spots[i].title;                
                [self.map addAnnotation:pin.annotation];
            }
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    TakeMeAnywhereSettingsViewController* viewController = [segue destinationViewController];
    viewController.currentCoordinate = self.currLoc.coordinate;
    viewController.locationServiceEnabled = self.locationServiceEnabled;
}


@end
