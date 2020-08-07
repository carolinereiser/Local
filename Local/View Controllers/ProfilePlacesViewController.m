//
//  ProfilePlacesViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/30/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "Place.h"
#import "PlaceCell.h"
#import "PlaceViewController.h"
#import "ProfilePlacesViewController.h"

@import Parse;

@interface ProfilePlacesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) NSArray<Place *> *places;

@end

@implementation ProfilePlacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    self.navigationItem.title = @"Places";
    
    [self fetchPlaces];
    
    self.collectionView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width - 10, self.view.frame.size.height);
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;

    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    //three images per line
    CGFloat imagesPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - (layout.minimumInteritemSpacing * (imagesPerLine - 1))) / imagesPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)fetchPlaces {
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:self.user];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable places, NSError * _Nullable error) {
        if(places)
        {
            self.places = places;
            [self.collectionView reloadData];
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PlaceCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PlaceCell" forIndexPath:indexPath];
    
    Place* place = self.places[indexPath.item];
    [cell setPlace:place];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.places.count;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No Places";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"placeSegue"]) {
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        Place *place = self.places[indexPath.item];
        PlaceViewController *placeViewController = [segue destinationViewController];
        placeViewController.place = place;
        placeViewController.user = self.user;
    }
}


@end
