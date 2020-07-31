//
//  SettingsViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/15/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "LogInViewController.h"
#import "Parse/Parse.h"
#import "SettingsViewController.h"
#import "SceneDelegate.h"

@import GooglePlaces;
@import MBProgressHUD;

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)logOut:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error)
    {
        if(error)
        {
            NSLog(@"%@", error.localizedDescription);
        }
        else
        {
            NSLog(@"Successfully logged out!");
        }
    }];
    
    //navigate back to login page
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.parentViewController.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LogInViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
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
