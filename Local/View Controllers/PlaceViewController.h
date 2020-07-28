//
//  PlaceViewController.h
//  Local
//
//  Created by Caroline Reiser on 7/28/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "Place.h"
#import <UIKit/UIKit.h>

@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface PlaceViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) Place* place;
@property (weak, nonatomic) PFUser* user;

@end

NS_ASSUME_NONNULL_END
