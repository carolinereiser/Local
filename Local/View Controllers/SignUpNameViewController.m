//
//  SignUpNameViewController.m
//  Local
//
//  Created by Caroline Reiser on 8/3/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "SignUpNameViewController.h"

@import Parse;

@interface SignUpNameViewController ()

@end

@implementation SignUpNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)addName:(id)sender {
    PFUser *user = [PFUser currentUser];
    user[@"name"] = self.nameField.text;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"Successfully changed name!");
            [self performSegueWithIdentifier:@"nextSegue" sender:nil];
        }
        else{
            NSLog(@"%@", error.localizedDescription);
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
