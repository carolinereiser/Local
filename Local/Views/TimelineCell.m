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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSpot:(Spot *)spot{
    _spot = spot;
    
    self.spotName.text = spot.name;
    self.username.text = [NSString stringWithFormat:@"@%@", spot.user.username];
    self.spotDescription.text = spot.spotDescription;
    self.images = spot.images;
    self.formattedAddress.text = spot.address;

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

@end
