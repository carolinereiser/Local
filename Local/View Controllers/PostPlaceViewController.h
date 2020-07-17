//
//  PostPlaceViewController.h
//  Local
//
//  Created by Caroline Reiser on 7/16/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostPlaceViewController : UIViewController

@property (weak, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *place;

@end

NS_ASSUME_NONNULL_END
