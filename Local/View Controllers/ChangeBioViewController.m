//
//  ChangeBioViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/31/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "ChangeBioViewController.h"

@import Parse;

@interface ChangeBioViewController ()

@end

@implementation ChangeBioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bioText.text = [PFUser currentUser][@"bio"];
}

- (IBAction)confirmEdits:(id)sender {
    PFUser* user = [PFUser currentUser];
    user[@"bio"] = self.bioText.text;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded)
        {
            NSLog(@"Successfully changed bio!");
        }
        else
        {
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
