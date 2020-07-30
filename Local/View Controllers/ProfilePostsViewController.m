//
//  ProfilePostsViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/22/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "Place.h"
#import "PlaceCell.h"
#import "PlaceViewController.h"
#import "ProfilePlacesViewController.h"
#import "ProfilePostsViewController.h"
#import "ProfileViewController.h"
#import "RandomSpotViewController.h"
#import "SaveCell.h"
#import "Spot.h"

@import MBProgressHUD;
@import Parse;

@interface ProfilePostsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray<Place *> *places;
@property (strong, nonatomic) NSArray<PFObject *> *saved;

@end

@implementation ProfilePostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.saveCollectionView.delegate = self;
    self.saveCollectionView.dataSource = self;
    
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
    [query2 whereKey:@"user" equalTo:self.user];
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
    
    //follow button configuration
    //if it's the current user's account, don't show the button
    if([self.user isEqual:[PFUser currentUser]])
    {
        self.followButton.alpha = 0;
        self.editButton.alpha = 1;
    }
    else
    {
        self.followButton.alpha = 1;
        self.editButton.alpha = 0;
        //see if the current user follows the user
        PFQuery *query = [PFQuery queryWithClassName:@"Following"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query whereKey:@"following" equalTo:self.user];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
            if(users != nil) {
                if(users.count == 1) {
                    [self.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
                }
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
    
    [self fetchPlaces];
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
    
    self.saveCollectionView.frame = self.view.frame;
    UICollectionViewFlowLayout *layout2 = (UICollectionViewFlowLayout *)self.saveCollectionView.collectionViewLayout;

    layout2.minimumInteritemSpacing = 5;
    layout2.minimumLineSpacing = 5;
    
    //three images per line
    CGFloat itemWidth2 = (self.saveCollectionView.frame.size.width - (layout2.minimumInteritemSpacing * (imagesPerLine - 1))) / imagesPerLine;
    CGFloat itemHeight2 = itemWidth2;
    layout2.itemSize = CGSizeMake(itemWidth2, itemHeight2);
}

- (void)viewWillAppear:(BOOL)animated {
    [self fetchPlaces];
    [self fetchSaves];
    
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
    [query2 whereKey:@"user" equalTo:self.user];
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

- (void)fetchSaves {
    PFQuery* query = [PFQuery queryWithClassName:@"Saves"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"spot"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *spots, NSError *error) {
        if (spots != nil) {
            // do something with the array of object returned by the call
            self.saved = spots;
            [self.saveCollectionView reloadData];
            NSLog(@"%@", self.saved);
        } else {
            NSLog(@"%@", error.localizedDescription);
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
    [query2 whereKey:@"user" equalTo:self.user];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable following, NSError * _Nullable error) {
        self.numFollowing.text = [NSString stringWithFormat:@"%lu", [following count]];
    }];
}

- (IBAction)didTapFollow:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Following"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"following" equalTo:self.user];
    query.limit = 1;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        if(users != nil) {
            NSLog(@"%lu", users.count);
            if(users.count == 1) {
                //delete the follow
                [users[0] deleteInBackground];
                NSLog(@"Unfollowed!");
                [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
            }
            else {
                PFObject *follow = [PFObject objectWithClassName:@"Following"];
                follow[@"user"] = [PFUser currentUser];
                follow[@"following"] = self.user;
                
                [follow saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                  if (succeeded) {
                      NSLog(@"Followed!");
                      [self.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
                  } else {
                     NSLog(@"Error: %@", error.description);
                  }
                }];
            }
            [self refreshData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(collectionView == self.collectionView)
    {
        if(indexPath.item == 0 && self.user == [PFUser currentUser])
        {
            //create a custom cell
            UICollectionViewCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"AddPlaceCell" forIndexPath:indexPath];
            return cell;
        }
        else {
            PlaceCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PlaceCell" forIndexPath:indexPath];
            
            Place* place = self.places[indexPath.item];
            [cell setPlace:place];
            
            return cell;
        }
    }
    else
    {
        //NSLog(@"hey");
        SaveCell *cell = [self.saveCollectionView dequeueReusableCellWithReuseIdentifier:@"SaveCell" forIndexPath:indexPath];
        Spot* spot = self.saved[indexPath.item][@"spot"];
        [cell setSpot:spot];
        
        return cell;
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == self.collectionView)
    {
        return (self.places.count < 10) ? self.places.count : 10;
    }
    else
    {
        return (self.saved.count < 10) ? self.saved.count : 10;
    }
    
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
    else if([[segue identifier] isEqualToString:@"spotSegue"]) {
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.saveCollectionView indexPathForCell:tappedCell];
        Spot *spot = self.saved[indexPath.item][@"spot"];
        RandomSpotViewController *spotViewController = [segue destinationViewController];
        spotViewController.spot = spot;
    }
    else if([[segue identifier] isEqualToString:@"profilePlacesSegue"]) {
        ProfilePlacesViewController *viewController = [segue destinationViewController];
        viewController.user = self.user;
    }
}


@end
