//
//  SignUpViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/15/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "CommentViewController.h"
#import <Parse/Parse.h>
#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.passwordField.secureTextEntry = YES;
    self.confirmPasswordField.secureTextEntry = YES;
}

- (IBAction)signUp:(id)sender {
    if(![self isEmptyFields] && [self validFields])
    {
        // initialize a user object
        PFUser *newUser = [PFUser user];
        
        // set user properties
        NSString *lowerUsername = [self.usernameField.text lowercaseString];
        newUser.username = lowerUsername;
        newUser.password = self.passwordField.text;
        newUser.email = self.emailField.text;
        newUser[@"countryCount"] = @(0);
        newUser[@"cityCount"] = @(0);
        newUser[@"isPublic"] = @YES;
        
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error signing up" message:@"The username and/or email already exists." preferredStyle:(UIAlertControllerStyleAlert)];
                
                // create a cancel action
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                {
                // handle cancel response here. Doing nothing will dismiss the view.
                    self.emailField.text = @"";
                    self.usernameField.text = @"";
                }];
                // add the cancel action to the alertController
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:^{
                    // nothing happens when view controller is done presenting
                }];
                
            } else {
                NSLog(@"User registered successfully");
                // manually segue to logged in view
                [self performSegueWithIdentifier:@"detailsSegue" sender:nil];
            }
        }];
    }
}

- (BOOL)isEmptyFields {
    //if the user hasn't filled in all of the fields, present an error
    if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""] || [self.emailField.text isEqual:@""] || [self.confirmPasswordField isEqual:@""])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Empty Fields" message:@"You must fill in all fields" preferredStyle:(UIAlertControllerStyleAlert)];
        
        // create a cancel action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
        {}];
        // add the cancel action to the alertController
        [alert addAction:okAction];

        [self presentViewController:alert animated:YES completion:^{
            //nothing happens when done presenting
        }];
        return YES;
    }
    return NO;
}

- (BOOL)validFields {
    if([self isValidEmail:self.emailField.text] && [self matchingPasswords])
    {
        return YES;
    }
    return NO;
}

- (BOOL)isValidEmail:(NSString*)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    if([emailTest evaluateWithObject:email])
    {
        return YES;
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid email" message:@"Please enter a valid email." preferredStyle:(UIAlertControllerStyleAlert)];
        
        // create a cancel action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
        {
            self.emailField.text = @"";
        }];
        // add the cancel action to the alertController
        [alert addAction:okAction];

        [self presentViewController:alert animated:YES completion:^{
            // nothing happens when done presenting
        }];
        return NO;
    }
}

- (BOOL)matchingPasswords {
    if([self.passwordField.text isEqual:self.confirmPasswordField.text])
    {
        return YES;
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Passwords don't match" message:@"Please make sure your passwords match." preferredStyle:(UIAlertControllerStyleAlert)];
        
        // create a cancel action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
        {
        // handle cancel response here. Doing nothing will dismiss the view.
            self.confirmPasswordField.text = @"";
        }];
        // add the cancel action to the alertController
        [alert addAction:okAction];

        [self presentViewController:alert animated:YES completion:^{
            // nothing happens when done presenting
        }];
        return NO;
    }
}

- (IBAction)didTapOutside:(id)sender {
    [self.emailField resignFirstResponder];
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.confirmPasswordField resignFirstResponder];
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
