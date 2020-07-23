//
//  ProfileViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/20/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "Place.h"
#import "PlaceCell.h"
#import "ProfileViewController.h"

@import MBProgressHUD;
@import Parse;

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.map.alpha = 0;
    self.posts.alpha = 1;
}

- (IBAction)switchView:(id)sender {
    if([sender selectedSegmentIndex] == 0){
        self.posts.alpha = 1;
        self.map.alpha = 0;
    }
    else{
        self.posts.alpha = 0;
        self.map.alpha = 1;
        self.map.tag = 1;
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
