//
//  RandomSpotViewController.h
//  Local
//
//  Created by Caroline Reiser on 7/23/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <iCarousel/iCarousel.h>
#import "Spot.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RandomSpotViewController : UIViewController

@property (nonatomic, strong) Spot* spot;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *saveCount;
@property (weak, nonatomic) IBOutlet UILabel *formattedAddress;
@property (weak, nonatomic) IBOutlet UILabel *spotDescription;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;


@end

NS_ASSUME_NONNULL_END
