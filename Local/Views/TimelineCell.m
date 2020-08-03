//
//  TimelineCell.m
//  Local
//
//  Created by Caroline Reiser on 7/20/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <iCarousel/iCarousel.h>
#import "TimelineCell.h"
#import "TimelinePhotoCell.h"

@implementation TimelineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.carousel.dataSource = self;
    self.carousel.delegate = self;
    
    self.carousel.scrollEnabled = YES;
    self.carousel.pagingEnabled = YES;
    
    //double tap to like
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapToLike:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.carousel addGestureRecognizer:tapGesture];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.gradientView.bounds;
    gradient.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
    
    [self.gradientView.layer insertSublayer:gradient atIndex:0];
    
    self.carousel.type = iCarouselTypeRotary;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSpot:(Spot *)spot{
    _spot = spot;
    
    self.spotName.text = spot.title;
    self.spotDescription.text = spot.spotDescription;
    self.images = spot.images;
    self.formattedAddress.text = spot.address;
    self.profilePic.file = spot.user[@"profilePic"];
    self.likeCount.text = [NSString stringWithFormat:@"%@", spot.likeCount];
    self.commentCount.text = [NSString stringWithFormat:@"%@", spot.commentCount];
    self.saveCount.text = [NSString stringWithFormat:@"%@", spot.saveCount];
    [self.profilePic loadInBackground];
    
    //make like button red if liked
    [self isLiked];
    
    //make save button grey if saved
    [self isSaved];

    //[self.imagesCollectionView reloadData];
    [self.carousel reloadData];
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.images.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    PFImageView* imageView = [[PFImageView alloc] init];
    if(!view) {
        imageView.layer.cornerRadius = 20;
        imageView.layer.masksToBounds = YES;
        imageView.frame = CGRectMake(0, 0, self.carousel.frame.size.height - 50, self.carousel.frame.size.width - 50);
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
                self.saveButton.tintColor = [UIColor grayColor];
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
                        self.saveButton.tintColor = [UIColor grayColor];
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

@end
