//
//  ChangeUsernameViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/31/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "ChangeUsernameViewController.h"

@import MBProgressHUD;
@import Parse;

@interface ChangeUsernameViewController ()

@end

@implementation ChangeUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.username.text = [PFUser currentUser][@"username"];
}

- (IBAction)changeUsername:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFUser *user = [PFUser currentUser];
    NSString *lowerUsername = [self.username.text lowercaseString];
    user.username = lowerUsername;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"Successfully changed username!");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        else{
            NSLog(@"%@", error.localizedDescription);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"Error: %@", error.localizedDescription);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error changing username" message:@"The username already exists." preferredStyle:(UIAlertControllerStyleAlert)];
            
            // create a cancel action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
            {
            // handle cancel response here. Doing nothing will dismiss the view.
                self.username.text = [PFUser currentUser].username;
            }];
            // add the cancel action to the alertController
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{
                // nothing happens when view controller is done presenting
            }];
        }
    }];
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
