//
//  PersonalMapViewController.h
//  Local
//
//  Created by Caroline Reiser on 7/23/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface PersonalMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) PFUser *user;

@end

NS_ASSUME_NONNULL_END
