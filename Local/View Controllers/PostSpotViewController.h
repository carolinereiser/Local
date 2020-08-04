//
//  PostSpotViewController.h
//  Local
//
//  Created by Caroline Reiser on 7/17/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "Place.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostSpotViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) Place* place;
@property (strong, nonatomic) NSArray<UIImage *> *images;
@property (nonatomic) BOOL createPlace;

@end

NS_ASSUME_NONNULL_END
