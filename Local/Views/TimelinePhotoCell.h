//
//  TimelinePhotoCell.h
//  Local
//
//  Created by Caroline Reiser on 7/20/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface TimelinePhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PFImageView *image;

@end

NS_ASSUME_NONNULL_END
