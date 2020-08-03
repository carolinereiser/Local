//
//  SpotPicturePickerViewController.h
//  Local
//
//  Created by Caroline Reiser on 7/17/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotPicturePickerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray<UIImage *> *images;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextButton;

@end

NS_ASSUME_NONNULL_END
