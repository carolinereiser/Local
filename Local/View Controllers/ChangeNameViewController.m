//
//  ChangeNameViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/31/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "ChangeNameViewController.h"

@import MBProgressHUD;
@import Parse;

@interface ChangeNameViewController ()

@end

@implementation ChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.name.text = [PFUser currentUser][@"name"];

}

- (IBAction)changeName:(id)sender {
    PFUser *user = [PFUser currentUser];
    user[@"name"] = self.name.text;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"Successfully changed name!");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)next:(id)sender {
    [self performSegueWithIdentifier:@"nextSegue" sender:nil];
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
