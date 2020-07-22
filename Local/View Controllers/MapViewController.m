//
//  MapViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/22/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapViewController.h"

@import CoreLocation;

@interface MapViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

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
    
    CLLocation *currLoc = [[CLLocation alloc] init];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if(status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        currLoc = self.locationManager.location;
        NSLog(@"%f", currLoc.coordinate.latitude);
    }
    else
    {
        //make currLoc San Francisco region
        currLoc = [[CLLocation alloc] initWithLatitude:37.783333 longitude:-122.416667];
    }
    
    MKCoordinateRegion currRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(currLoc.coordinate.latitude, currLoc.coordinate.longitude), MKCoordinateSpanMake(0.1, 0.1));
    [self.map setRegion:currRegion animated:false];
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
