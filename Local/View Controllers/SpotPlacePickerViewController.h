//
//  SpotPlacePickerViewController.h
//  Local
//
//  Created by Caroline Reiser on 7/17/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "Place.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotPlacePickerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<Place *> *places;
@property (nonatomic, strong) NSArray<UIImage *> *images;

@end

NS_ASSUME_NONNULL_END
