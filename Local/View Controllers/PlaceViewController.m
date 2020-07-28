//
//  PlaceViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/28/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "PlaceViewController.h"
#import "Spot.h"

@interface PlaceViewController ()

@property (nonatomic, strong) NSArray<Spot *> *spots;

@end

@implementation PlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.placeName.text = self.place.name;
    [self fetchSpots];
}

- (void)fetchSpots {
    PFQuery* query = [PFQuery queryWithClassName:@"Spot"];
    [query whereKey:@"place" equalTo:self.place];
    [query whereKey:@"user" equalTo:self.user];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable spots, NSError * _Nullable error) {
        if(spots) {
            self.spots = spots;
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
