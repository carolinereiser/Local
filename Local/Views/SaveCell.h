//
//  SaveCell.h
//  Local
//
//  Created by Caroline Reiser on 7/29/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "Spot.h"
#import <UIKit/UIKit.h>

@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface SaveCell : UICollectionViewCell

@property (weak, nonatomic) Spot* spot;
@property (weak, nonatomic) IBOutlet PFImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

NS_ASSUME_NONNULL_END
