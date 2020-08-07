//
//  RandomSpotViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/23/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "CommentViewController.h"
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
    self.name.text = self.spot.title;
    
    self.spotDescription.text = self.spot.spotDescription;
    self.images = self.spot.images;
    self.formattedAddress.text = self.spot.address;
    self.likeCount.text = [NSString stringWithFormat:@"%@", self.spot.likeCount];
    self.commentCount.text = [NSString stringWithFormat:@"%@", self.spot.commentCount];
    self.saveCount.text = [NSString stringWithFormat:@"%@", self.spot.saveCount];
    [self isLiked];
    [self isSaved];
    
    if(self.spot.isCertified) {
        self.certifiedView.alpha = 1;
    }
    else {
        self.certifiedView.alpha = 0;
    }
    
    //double tap to like
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapToLike:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.carousel addGestureRecognizer:tapGesture];
    
    [self.carousel reloadData];
}

- (void)doubleTapToLike:(UITapGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateRecognized) {
        [self like];
    }
}

- (void)refreshData {
    self.likeCount.text = [NSString stringWithFormat:@"%@", self.spot.likeCount];
    self.saveCount.text = [NSString stringWithFormat:@"%@", self.spot.saveCount];
    self.commentCount.text = [NSString stringWithFormat:@"%@", self.spot.commentCount];
}

- (void)isLiked {
    PFQuery *query = [PFQuery queryWithClassName:@"Likes"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"spot" equalTo:self.spot];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        if(users != nil) {
            if(users.count == 1) {
                self.likeButton.tintColor = [UIColor redColor];
            }
            else {
                self.likeButton.tintColor = [UIColor whiteColor];
            }
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)isSaved {
    PFQuery *query = [PFQuery queryWithClassName:@"Saves"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"spot" equalTo:self.spot];
    query.limit = 1;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        if(users != nil) {
            if(users.count == 1) {
                self.saveButton.tintColor = [UIColor orangeColor];
            }
            else {
                self.saveButton.tintColor = [UIColor whiteColor];
            }
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.images.count;
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    PFImageView* imageView = [[PFImageView alloc] init];
    if(!view) {
        imageView.layer.cornerRadius = 20;
        imageView.frame = CGRectMake(0, 0, self.carousel.frame.size.width - 70, self.carousel.frame.size.width - 70);
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
    [self like];
}

- (void) animateLike {
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.heartPopup.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.heartPopup.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.heartPopup.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                self.heartPopup.transform = CGAffineTransformMakeScale(1.3, 1.3);
                self.heartPopup.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.heartPopup.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }];
    }];
}

- (void)like {
    PFQuery *query = [PFQuery queryWithClassName:@"Likes"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"spot" equalTo:self.spot];
    query.limit = 1;
     
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        if(users != nil) {
            if(users.count == 1) {
                PFQuery *query = [PFQuery queryWithClassName:@"Likes"];
                [query whereKey:@"user" equalTo:[PFUser currentUser]];
                [query whereKey:@"spot" equalTo:self.spot];
                query.limit = 1;
                [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable user, NSError * _Nullable error) {
                    if(user) {
                        NSLog (@"Like removed");
                        [user[0] deleteInBackground];
                        self.likeButton.tintColor = [UIColor whiteColor];
                    }
                    else {
                        NSLog (@"unable to retrieve like");
                    }
                }];
                 
                NSNumber *currLikeCount = self.spot.likeCount;
                int val = [currLikeCount intValue];
                val -= 1;
                self.spot.likeCount = [NSNumber numberWithInt:val];
                [self.spot saveInBackground];
                [self refreshData];
            }
            else {
                [self animateLike];
                PFObject *like = [PFObject objectWithClassName:@"Likes"];
                like[@"user"] = [PFUser currentUser];
                like[@"spot"] = self.spot;
                like[@"owner"] = self.spot.user;
                 
                [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"Like saved!");
                        self.likeButton.tintColor = [UIColor redColor];
                    } else {
                        NSLog(@"Error: %@", error.description);
                    }
                }];
                 
                NSNumber *currLikeCount = self.spot.likeCount;
                int val = [currLikeCount intValue];
                val += 1;
                self.spot.likeCount = [NSNumber numberWithInt:val];
                [self.spot saveInBackground];
                [self refreshData];
            }
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didSave:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Saves"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"spot" equalTo:self.spot];
    query.limit = 1;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        if(users != nil) {
            if(users.count == 1) {
                PFQuery *query = [PFQuery queryWithClassName:@"Saves"];
                [query whereKey:@"user" equalTo:[PFUser currentUser]];
                [query whereKey:@"spot" equalTo:self.spot];
                query.limit = 1;
                [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable user, NSError * _Nullable error) {
                    if(user) {
                        NSLog (@"Save removed");
                        [user[0] deleteInBackground];
                        self.saveButton.tintColor = [UIColor whiteColor];
                    }
                    else {
                        NSLog (@"unable to retrieve save");
                    }
                }];
                
                NSNumber *currSaveCount = self.spot.saveCount;
                int val = [currSaveCount intValue];
                val -= 1;
                self.spot.saveCount = [NSNumber numberWithInt:val];
                [self.spot saveInBackground];
                [self refreshData];
            }
            else {
                PFObject *like = [PFObject objectWithClassName:@"Saves"];
                like[@"user"] = [PFUser currentUser];
                like[@"spot"] = self.spot;
                like[@"owner"] = self.spot.user;
                
                [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"Spot saved!");
                        self.saveButton.tintColor = [UIColor orangeColor];
                    } else {
                        NSLog(@"Error: %@", error.description);
                    }
                }];
                
                NSNumber *currSaveCount = self.spot.saveCount;
                int val = [currSaveCount intValue];
                val += 1;
                self.spot.saveCount = [NSNumber numberWithInt:val];
                [self.spot saveInBackground];
                [self refreshData];
            }
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didPressMap:(id)sender {
    NSString* directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%f,%f", self.spot.location.latitude, self.spot.location.longitude];
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: directionsURL] options:@{} completionHandler:^(BOOL success) {}];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: directionsURL]];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"commentSegue"]) {
        CommentViewController *commentViewController = [segue destinationViewController];
        commentViewController.spot = self.spot;
    }
}


@end
