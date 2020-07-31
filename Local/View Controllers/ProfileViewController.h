//
//  ProfileViewController.h
//  Local
//
//  Created by Caroline Reiser on 7/20/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//


#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *map;
@property (weak, nonatomic) IBOutlet UIView *posts;
@property (weak, nonatomic) IBOutlet UIView *saves;

@property (strong, nonatomic) PFUser* user;

@end

NS_ASSUME_NONNULL_END
