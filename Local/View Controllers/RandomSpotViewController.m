//
//  RandomSpotViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/23/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "RandomSpotViewController.h"

@import Parse;

@interface RandomSpotViewController () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) NSArray<PFFileObject *> *images;

@end

@implementation RandomSpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.carousel.dataSource = self;
    self.carousel.delegate = self;
    
    self.carousel.scrollEnabled = YES;
    self.carousel.pagingEnabled = YES;
    
    self.carousel.type = iCarouselTypeRotary;
    // Do any additional setup after loading the view.
    NSLog(@"%@", self.spot);
    self.name.text = self.spot.title;
    
    self.spotDescription.text = self.spot.spotDescription;
    self.images = self.spot.images;
    self.formattedAddress.text = self.spot.address;
    self.likeCount.text = [NSString stringWithFormat:@"%@", self.spot.likeCount];
    self.commentCount.text = [NSString stringWithFormat:@"%@", self.spot.commentCount];
    self.saveCount.text = [NSString stringWithFormat:@"%@", self.spot.saveCount];
    
    [self.carousel reloadData];
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.images.count;
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    PFImageView* imageView = [[PFImageView alloc] init];
    if(!view) {
        imageView.layer.cornerRadius = 20;
        imageView.frame = CGRectMake(0, 0, self.carousel.frame.size.width - 50, self.carousel.frame.size.width - 50);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else {
        imageView = (PFImageView*)view;
    }
    imageView.file = self.images[index];
    [imageView loadInBackground];
    return imageView;
}


- (IBAction)didLike:(id)sender {
}

- (IBAction)didSave:(id)sender {
}

- (IBAction)didPressMap:(id)sender {
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
