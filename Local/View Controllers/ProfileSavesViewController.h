//
//  ProfileSavesViewController.h
//  Local
//
//  Created by Caroline Reiser on 7/30/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ProfileSavesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *username;


@end

NS_ASSUME_NONNULL_END
