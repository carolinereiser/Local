//
//  ProfileSavesViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/30/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "ProfileSavesViewController.h"
#import "RandomSpotViewController.h"
#import "SaveCell.h"

@import Parse;

@interface ProfileSavesViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray<PFObject *> *saved;

@end

@implementation ProfileSavesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.navigationItem.title = @"Saves";
    
    [self fetchSaves];
    
    self.collectionView.frame = self.view.frame;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;

    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    //three images per line
    CGFloat imagesPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - (layout.minimumInteritemSpacing * (imagesPerLine - 1))) / imagesPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)fetchSaves {
    PFQuery* query = [PFQuery queryWithClassName:@"Saves"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"spot"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *spots, NSError *error) {
        if (spots != nil) {
            // do something with the array of object returned by the call
            self.saved = spots;
            [self.collectionView reloadData];
            NSLog(@"%@", self.saved);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SaveCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"SaveCell" forIndexPath:indexPath];
    Spot* spot = self.saved[indexPath.item][@"spot"];
    [cell setSpot:spot];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.saved.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"spotSegue"]) {
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        Spot *spot = self.saved[indexPath.item][@"spot"];
        RandomSpotViewController *spotViewController = [segue destinationViewController];
        spotViewController.spot = spot;
    }
}


@end