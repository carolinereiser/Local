//
//  SignUpProfilePicViewController.h
//  Local
//
//  Created by Caroline Reiser on 8/3/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface SignUpProfilePicViewController : UIViewController

@property (weak, nonatomic) IBOutlet PFImageView *profilePic;

@end

NS_ASSUME_NONNULL_END
