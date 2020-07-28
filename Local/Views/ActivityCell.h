//
//  ActivityCell.h
//  Local
//
//  Created by Caroline Reiser on 7/28/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) NSString* username;

@end

NS_ASSUME_NONNULL_END
