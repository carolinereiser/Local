//
//  TimelineCell.m
//  Local
//
//  Created by Caroline Reiser on 7/20/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "TimelineCell.h"
#import "TimelinePhotoCell.h"

@implementation TimelineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imagesCollectionView.delegate = self;
    self.imagesCollectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.imagesCollectionView.collectionViewLayout;
        
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    
    CGFloat imagesPerLine = 1;
    CGFloat itemWidth = (self.imagesCollectionView.frame.size.width - (layout.minimumInteritemSpacing * (imagesPerLine - 1))) / imagesPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)refreshData {
    self.likeCount.text = [NSString stringWithFormat:@"%@", self.spot.likeCount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSpot:(Spot *)spot{
    _spot = spot;
    
    self.spotName.text = spot.title;
    self.username.text = [NSString stringWithFormat:@"@%@", spot.user.username];
    self.spotDescription.text = spot.spotDescription;
    self.images = spot.images;
    self.formattedAddress.text = spot.address;
    self.profilePic.file = spot.user[@"profilePic"];
    self.likeCount.text = [NSString stringWithFormat:@"%@", spot.likeCount];
    self.commentCount.text = [NSString stringWithFormat:@"%@", spot.commentCount];
    self.saveCount.text = [NSString stringWithFormat:@"%@", spot.saveCount];
    self.shareCount.text = [NSString stringWithFormat:@"%@", spot.shareCount];
    [self.profilePic loadInBackground];

    [self.imagesCollectionView reloadData];
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TimelinePhotoCell* cell = [self.imagesCollectionView dequeueReusableCellWithReuseIdentifier:@"TimelinePhotoCell" forIndexPath:indexPath];
    
    cell.image.file = self.images[indexPath.item];
    [cell.image loadInBackground];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}
- (IBAction)didLike:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Likes"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"spot" equalTo:self.spot];
    query.limit = 1;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        if(users != nil)
        {
            if(users.count == 1)
            {
                PFQuery *query = [PFQuery queryWithClassName:@"Likes"];
                [query whereKey:@"user" equalTo:[PFUser currentUser]];
                [query whereKey:@"spot" equalTo:self.spot];
                query.limit = 1;
                [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable user, NSError * _Nullable error) {
                    if(user)
                    {
                        NSLog (@"Like removed");
                        [user[0] deleteInBackground];
                    }
                    else
                    {
                        NSLog (@"unable to retrieve like");
                    }
                }];
                
                NSNumber *currLikeCount = self.spot.likeCount;
                int val = [currLikeCount intValue];
                val -= 1;
                self.spot.likeCount = [NSNumber numberWithInt:val];
                [self refreshData];
            }
            else
            {
                PFObject *like = [PFObject objectWithClassName:@"Likes"];
                like[@"user"] = [PFUser currentUser];
                like[@"spot"] = self.spot;
                
                [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                  if (succeeded) {
                      NSLog(@"Like saved!");
                      [self refreshData];
                  } else {
                     NSLog(@"Error: %@", error.description);
                  }
                }];
                
                NSNumber *currLikeCount = self.spot.likeCount;
                int val = [currLikeCount intValue];
                val += 1;
                self.spot.likeCount = [NSNumber numberWithInt:val];
            }
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

@end
