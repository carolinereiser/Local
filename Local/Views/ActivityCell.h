//
//  ActivityCell.h
//  Local
//
//  Created by Caroline Reiser on 7/28/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) NSString* username;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;

@end

NS_ASSUME_NONNULL_END
