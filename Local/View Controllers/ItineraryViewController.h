//
//  ItineraryViewController.h
//  Local
//
//  Created by Caroline Reiser on 8/11/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@import CoreLocation;
@import TravelKit;

NS_ASSUME_NONNULL_BEGIN

@interface ItineraryViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) TKPlaceCategory placeCategory;

@end

NS_ASSUME_NONNULL_END
