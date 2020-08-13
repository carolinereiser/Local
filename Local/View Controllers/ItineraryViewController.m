//
//  ItineraryViewController.m
//  Local
//
//  Created by Caroline Reiser on 8/11/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "ItineraryViewController.h"

@import TravelKit;

@interface ItineraryViewController ()

@end

@implementation ItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MKCoordinateRegion currRegion = MKCoordinateRegionMake(self.coordinate, MKCoordinateSpanMake(0.4, 0.4));
    [self.mapView setRegion:currRegion animated:false];

    TravelKit *kit = [TravelKit sharedKit];
    kit.APIKey = <YOUR_API_KEY>;
    
    TKPlacesQuery *query = [TKPlacesQuery new];
    TKMapRegion *region = [[TKMapRegion new] initWithCoordinateRegion:currRegion];
    query.bounds = region;
    query.levels = TKPlaceLevelPOI;
    query.categories = self.placeCategory;
    query.limit = @20;

    [kit.places placesForQuery:query completion:^(NSArray<TKPlace *> * _Nullable places, NSError * _Nullable error) {
        if(places) {
            NSLog(@"%@", places);
            for(int i =0; i<places.count; i++) {
                MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = CLLocationCoordinate2DMake(places[i].location.coordinate.latitude, places[i].location.coordinate.longitude);
                annotation.title = places[i].name;
                
                [self.mapView addAnnotation:annotation];
            }
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
