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
#import "ProfileViewController.h"

@import MBProgressHUD;
@import Parse;

@interface ProfilePostsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray<Place *> *places;

@end

@implementation ProfilePostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"sup");
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //put username in the title of screen
    self.navigationItem.title = self.user.username;

    if(self.user[@"name"]) {
        self.name.text = [NSString stringWithFormat:@"%@", self.user[@"name"]];
    }
    //get numfollowers
    PFQuery *query = [PFQuery queryWithClassName:@"Following"];
    [query whereKey:@"following" equalTo:self.user];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable followers, NSError * _Nullable error) {
        self.numFollowers.text = [NSString stringWithFormat:@"%lu", [followers count]];
    }];
    //self.numFollowers.text = [NSString stringWithFormat:@"%@", self.user[@"followerCount"]];
    //get numfollowing
    PFQuery *query2 = [PFQuery queryWithClassName:@"Following"];
    [query2 whereKey:@"follower" equalTo:self.user];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable following, NSError * _Nullable error) {
        self.numFollowing.text = [NSString stringWithFormat:@"%lu", [following count]];
    }];
    //self.numFollowing.text = [NSString stringWithFormat:@"%@", self.user[@"followingCount"]];
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
    //get numfollowers
    PFQuery *query = [PFQuery queryWithClassName:@"Following"];
    [query whereKey:@"following" equalTo:self.user];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable followers, NSError * _Nullable error) {
        self.numFollowers.text = [NSString stringWithFormat:@"%lu", [followers count]];
    }];

    //get numfollowing
    PFQuery *query2 = [PFQuery queryWithClassName:@"Following"];
    [query2 whereKey:@"follower" equalTo:self.user];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable following, NSError * _Nullable error) {
        self.numFollowing.text = [NSString stringWithFormat:@"%lu", [following count]];
    }];
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

- (void) refreshData {
    //get numfollowers
    PFQuery *query = [PFQuery queryWithClassName:@"Following"];
    [query whereKey:@"following" equalTo:self.user];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable followers, NSError * _Nullable error) {
        self.numFollowers.text = [NSString stringWithFormat:@"%lu", [followers count]];
    }];

    //get numfollowing
    PFQuery *query2 = [PFQuery queryWithClassName:@"Following"];
    [query2 whereKey:@"follower" equalTo:self.user];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable following, NSError * _Nullable error) {
        self.numFollowing.text = [NSString stringWithFormat:@"%lu", [following count]];
    }];
}

- (IBAction)didTapFollow:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Following"];
    [query whereKey:@"follower" equalTo:[PFUser currentUser]];
    [query whereKey:@"following" equalTo:self.user];
    query.limit = 1;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        if(users != nil) {
            NSLog(@"%lu", users.count);
            if(users.count == 1) {
                //delete the follow
                [users[0] deleteInBackground];
                NSLog(@"Unfollowed!");
            }
            else {
                PFObject *follow = [PFObject objectWithClassName:@"Following"];
                follow[@"follower"] = [PFUser currentUser];
                follow[@"following"] = self.user;
                
                [follow saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                  if (succeeded) {
                      NSLog(@"Followed!");
                  } else {
                     NSLog(@"Error: %@", error.description);
                  }
                }];
                
                [self refreshData];
            }
        }
        else {
            NSLog(@"%@", error.localizedDescription);
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
