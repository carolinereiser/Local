//
//  TakeMeAnywhereSettingsViewController.h
//  Local
//
//  Created by Caroline Reiser on 7/23/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TakeMeAnywhereSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *milesLabel;
@property (weak, nonatomic) IBOutlet UISlider *milesSlider;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

NS_ASSUME_NONNULL_END
