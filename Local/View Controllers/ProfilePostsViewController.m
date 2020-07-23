//
//  ProfilePostsViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/22/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "Place.h"
#import "PlaceCell.h"
#import "ProfilePostsViewController.h"

@import MBProgressHUD;
@import Parse;

@interface ProfilePostsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray<Place *> *places;

@end

@implementation ProfilePostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
        
    if(!self.user) {
        self.user = [PFUser currentUser];
    }
    
    //put username in the title of screen
    self.navigationItem.title = self.user.username;

    if(self.user[@"name"]) {
        self.name.text = [NSString stringWithFormat:@"%@", self.user[@"name"]];
    }
    self.numFollowers.text = [NSString stringWithFormat:@"%@", self.user[@"followerCount"]];
    self.numFollowing.text = [NSString stringWithFormat:@"%@", self.user[@"followingCount"]];
    self.numCities.text = [NSString stringWithFormat:@"%@", self.user[@"cityCount"]];
    self.numCountries.text = [NSString stringWithFormat:@"%@", self.user[@"countryCount"]];
    self.profilePic.file = self.user[@"profilePic"];
    [self.profilePic loadInBackground];
    self.bio.text = self.user[@"bio"];
    
    [self.name sizeToFit];
    [self.bio sizeToFit];
    [self.numFollowers sizeToFit];
    [self.numFollowing sizeToFit];
    [self.numCities sizeToFit];
    [self.numCountries sizeToFit];
    
    [self fetchPlaces];
    
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

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = self.user.username;
    self.name.text = [NSString stringWithFormat:@"%@", self.user[@"name"]];
    self.profilePic.file = self.user[@"profilePic"];
    [self.profilePic loadInBackground];
    self.bio.text = self.user[@"bio"];
}

- (void)fetchPlaces {
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:self.user];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable places, NSError * _Nullable error) {
        if(places)
        {
            self.places = places;
            [self.collectionView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end