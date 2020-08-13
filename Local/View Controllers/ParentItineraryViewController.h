//
//  ParentItineraryViewController.h
//  Local
//
//  Created by Caroline Reiser on 8/11/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CoreLocation;
@import TravelKit;

NS_ASSUME_NONNULL_BEGIN

@interface ParentItineraryViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* country;
@property (nonatomic, strong) NSString* adminArea;
@property (nonatomic, strong) NSString* adminArea2;
@property (nonatomic) enum TKPlaceCategory* placeCategory;
 
@end

NS_ASSUME_NONNULL_END
