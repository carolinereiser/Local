//
//  MapViewController.h
//  Local
//
//  Created by Caroline Reiser on 7/22/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *map;

@end

NS_ASSUME_NONNULL_END
