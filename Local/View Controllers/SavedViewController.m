//
//  SavedViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/23/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "SavedViewController.h"
#import "Spot.h"

@import Parse;

@interface SavedViewController ()

@property (nonatomic, strong) NSArray<Spot *> *saved;

@end

@implementation SavedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchSaved];
}

- (void) viewDidAppear:(BOOL)animated {
    [self fetchSaved];
}

- (void)fetchSaved {
    PFQuery* query = [PFQuery queryWithClassName:@"Saves"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *spots, NSError *error) {
        if (spots != nil) {
            // do something with the array of object returned by the call
            self.saved = spots;
            NSLog(@"%@", self.saved);
        } else {
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
