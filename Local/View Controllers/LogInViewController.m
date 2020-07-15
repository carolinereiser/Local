//
//  LogInViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/15/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "LogInViewController.h"
#import <Parse/Parse.h>

@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.passwordField.secureTextEntry = YES;
}
- (IBAction)logIn:(id)sender {
    PFQuery *query = [PFUser query];
    [query whereKey:@"email" equalTo:self.userField.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (objects.count > 0) {

            PFObject *object = [objects objectAtIndex:0];
            NSString *username = [object objectForKey:@"username"];
            [PFUser logInWithUsernameInBackground:username password:self.passwordField.text block:^(PFUser* user, NSError* error){
                if (error != nil) {
                    [self loginError:@"E-mail and/or password doesn't exist or match" withError:error];
                } else {
                    NSLog(@"User logged in successfully");
                    
                    // display view controller that needs to shown after successful login
                    
                    // manually segue to logged in view
                    [self performSegueWithIdentifier:@"timelineSegue" sender:nil];
                }
            }];
        }
        else
        {
            [PFUser logInWithUsernameInBackground:self.userField.text password:self.passwordField.text block:^(PFUser* user, NSError* error){
                if (error != nil) {
                    [self loginError:@"Username and/or password doesn't exist or match" withError:error];
                } else {
                    NSLog(@"User logged in successfully");
                    
                    // display view controller that needs to shown after successful login
                    
                    // manually segue to logged in view
                    [self performSegueWithIdentifier:@"timelineSegue" sender:nil];
                }
            }];
        }
    }];
}


-(void) loginError:(NSString *)message withError:(NSError *) error
{
    NSLog(@"User log in failed: %@", error.localizedDescription);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Logging In" message:message preferredStyle:(UIAlertControllerStyleAlert)];
     
     // create a cancel action
     UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
    {
         self.userField.text = @"";
         self.passwordField.text = @"";
    }];
     // add the cancel action to the alertController
     [alert addAction:okAction];

     
     [self presentViewController:alert animated:YES completion:^{
         // optional code for what happens after the alert controller has finished presenting
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
