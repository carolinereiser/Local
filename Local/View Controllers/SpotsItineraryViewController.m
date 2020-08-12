//
//  SpotsItineraryViewController.m
//  Local
//
//  Created by Caroline Reiser on 8/11/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "Spot.h"
#import "SpotsItineraryViewController.h"

@import Parse;

@interface SpotsItineraryViewController ()

@property (nonatomic, strong) NSArray<Spot *> *spots;

@end

@implementation SpotsItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchSpots];
}

- (void)fetchSpots {
    PFQuery *query = [PFQuery queryWithClassName:@"Spot"];
    if(self.adminArea2) {
        [query whereKey:@"adminArea2" equalTo:self.adminArea2];
    }
    else if(self.adminArea) {
        [query whereKey:@"adminArea" equalTo:self.adminArea];
    }
    else {
        [query whereKey:@"country" equalTo:self.country];
    }
    [query includeKey:@"user"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable spots, NSError * _Nullable error) {
        if(spots) {
            self.spots = spots;
            NSLog (@"%@", self.spots);
        }
        else {
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
