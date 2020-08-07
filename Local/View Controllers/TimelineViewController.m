//
//  TimelineViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/20/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "Spot.h"
#import "TimelineCell.h"
#import "TimelinePhotoCell.h"
#import "TimelineViewController.h"

@import MBProgressHUD;
@import Parse;

@interface TimelineViewController ()

@property (weak, nonatomic) IBOutlet UIView *timelineView;
@property (weak, nonatomic) IBOutlet UIView *mapView;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.timelineView.alpha = 1;
    self.mapView.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed: 0.00 green: 0.09 blue: 0.15 alpha: 1.00];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed: 0.00 green: 0.09 blue: 0.15 alpha: 1.00];
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.unselectedItemTintColor = [UIColor whiteColor];
}

- (IBAction)switchView:(id)sender {
    if([sender selectedSegmentIndex] == 0){
        self.timelineView.alpha = 1;
        self.mapView.alpha = 0;
    }
    else{
        self.timelineView.alpha = 0;
        self.mapView.alpha = 1;
        self.mapView.tag = 0;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
