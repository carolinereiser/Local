//
//  ProfileViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/20/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "PersonalMapViewController.h"
#import "Place.h"
#import "PlaceCell.h"
#import "ProfilePostsViewController.h"
#import "ProfileSavesViewController.h"
#import "ProfileViewController.h"

@import MBProgressHUD;
@import Parse;

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"hey");
    
    self.map.alpha = 0;
    self.posts.alpha = 1;
    self.saves.alpha = 0;
    
    
    if(!self.user) {
        self.user = [PFUser currentUser];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed: 0.00 green: 0.09 blue: 0.15 alpha: 1.00];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed: 0.00 green: 0.09 blue: 0.15 alpha: 1.00];
    self.tabBarController.tabBar.unselectedItemTintColor = [UIColor colorWithRed: 0.00 green: 0.09 blue: 0.15 alpha: 1.00];
}

- (IBAction)switchView:(id)sender {
    if([sender selectedSegmentIndex] == 0) {
        self.posts.alpha = 1;
        self.map.alpha = 0;
        self.saves.alpha = 0;
    }
    else if([sender selectedSegmentIndex] == 1) {
        self.posts.alpha = 0;
        self.map.alpha = 1;
        self.saves.alpha = 0;
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed: 0.00 green: 0.09 blue: 0.15 alpha: 1.00];
    }
    else if([sender selectedSegmentIndex] == 2) {
        self.posts.alpha = 0;
        self.map.alpha = 0;
        self.saves.alpha = 1;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if(!self.user)
    {
        self.user = [PFUser currentUser];
    }
    if([[segue identifier] isEqualToString:@"profilePostsSegue"])
    {
        ProfilePostsViewController* viewController = [segue destinationViewController];
        viewController.user = self.user;
    }
    else if([[segue identifier] isEqualToString:@"profileMapSegue"]) {
        PersonalMapViewController* viewController = [segue destinationViewController];
        viewController.user = self.user;
    }
    else if([[segue identifier] isEqualToString:@"savesSegue"]) {
        ProfileSavesViewController* viewController = [segue destinationViewController];
        viewController.user = self.user;
    }
}





@end
