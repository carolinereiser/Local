//
//  SettingsViewController.h
//  Local
//
//  Created by Caroline Reiser on 7/15/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *userAddress;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UITextView *bio;
@property (weak, nonatomic) IBOutlet UITextField *username;

@end

NS_ASSUME_NONNULL_END
