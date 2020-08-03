//
//  TimelineCell.h
//  Local
//
//  Created by Caroline Reiser on 7/20/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <iCarousel/iCarousel.h>
#import "Spot.h"
#import <UIKit/UIKit.h>

@import CoreLocation;
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface TimelineCell : UITableViewCell <iCarouselDelegate, iCarouselDataSource> 

@property (weak, nonatomic) IBOutlet UILabel *spotName;
@property (weak, nonatomic) IBOutlet UILabel *formattedAddress;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *spotDescription;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *saveCount;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet iCarousel *carousel; 
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) Spot* spot;
@property (weak, nonatomic) NSArray<PFFileObject *> *images;

@end

NS_ASSUME_NONNULL_END
