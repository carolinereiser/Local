//
//  SpotsItineraryViewController.h
//  Local
//
//  Created by Caroline Reiser on 8/11/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN

@interface SpotsItineraryViewController : UIViewController

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* country;
@property (nonatomic, strong) NSString* adminArea;
@property (nonatomic, strong) NSString* adminArea2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
