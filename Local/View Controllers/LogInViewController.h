//
//  LogInViewController.h
//  Local
//
//  Created by Caroline Reiser on 7/15/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface LogInViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
//@property (weak, nonatomic) IBOutlet FBSDKLoginButton *facebookButton;

@end

NS_ASSUME_NONNULL_END
