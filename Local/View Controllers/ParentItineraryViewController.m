//
//  ParentItineraryViewController.m
//  Local
//
//  Created by Caroline Reiser on 8/11/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "ItineraryViewController.h"
#import "ParentItineraryViewController.h"
#import "SpotsItineraryViewController.h"

@interface ParentItineraryViewController ()

@property (weak, nonatomic) IBOutlet UIView *itineraryView;
@property (weak, nonatomic) IBOutlet UIView *spotsView;

@end

@implementation ParentItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.spotsView.alpha = 0;
    self.itineraryView.alpha = 1;
}

- (IBAction)switchView:(id)sender {
    if([sender selectedSegmentIndex] == 0) {
        self.itineraryView.alpha = 1;
        self.spotsView.alpha = 0;
    }
    else {
        self.itineraryView.alpha = 0;
        self.spotsView.alpha = 1;
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"spotsSegue"]) {
        SpotsItineraryViewController *viewController = [segue destinationViewController];
        viewController.coordinate = self.coordinate;
        viewController.name = self.name;
        viewController.country = self.country;
        viewController.adminArea = self.adminArea;
        viewController.adminArea2 = self.adminArea2;
    }
}


@end
