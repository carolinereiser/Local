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

@import CoreLocation;
@import Parse;

@interface MapViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currLoc;
@property (nonatomic, strong) NSArray<Spot *> *spots;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.locationManager == nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    NSLog(@"HEY!");
    
    self.currLoc = [[CLLocation alloc] init];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if(status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        self.currLoc = self.locationManager.location;
        NSLog(@"%f", self.currLoc.coordinate.latitude);
    }
    else
    {
        //make currLoc San Francisco region
        self.currLoc = [[CLLocation alloc] initWithLatitude:37.783333 longitude:-122.416667];
    }
    
    MKCoordinateRegion currRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.currLoc.coordinate.latitude, self.currLoc.coordinate.longitude), MKCoordinateSpanMake(0.1, 0.1));
    [self.map setRegion:currRegion animated:false];
    [self dropPins];
}

- (void)viewDidAppear:(BOOL)animated{
    [self dropPins];
}

//drop a pin for each spot posted within the region
- (void)dropPins{
    //find all of the spots
    PFQuery *query = [PFQuery queryWithClassName:@"Spot"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable spots, NSError * _Nullable error) {
        if(spots){
            self.spots = spots;
            NSLog(@"SPOTS: %@", self.spots);
            for(int i =0; i<[self.spots count]; i++){
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = CLLocationCoordinate2DMake(self.spots[i].location.latitude, self.spots[i].location.longitude);;
                [self.map addAnnotation:annotation];
            }
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
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
