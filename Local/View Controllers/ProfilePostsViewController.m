//
//  ProfilePostsViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/22/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "Place.h"
#import "PlaceCell.h"
#import "PlaceViewController.h"
#import "ProfilePlacesViewController.h"
#import "ProfilePostsViewController.h"
#import "ProfileSavesViewController.h"
#import "ProfileViewController.h"
#import "RandomSpotViewController.h"
#import "SaveCell.h"
#import "Spot.h"

@import MBProgressHUD;
@import Parse;

@interface ProfilePostsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) NSArray<Place *> *places;
@property (strong, nonatomic) NSArray<PFObject *> *saved;

@end

@implementation ProfilePostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    if(self.user[@"name"]) {
        self.name.text = [NSString stringWithFormat:@"%@", self.user[@"name"]];
    }
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
    
    [self getNumCities];
    [self getNumCountries];
    
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

- (void)getNumCities {
    __block int cityCount = 0;
    NSMutableDictionary<NSString*, NSNumber*> *cities = [[NSMutableDictionary alloc] init];
    PFQuery *cityQuery = [PFQuery queryWithClassName:@"Spot"];
    [cityQuery whereKey:@"user" equalTo:self.user];
    [cityQuery includeKey:@"city"];
    [cityQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable spots, NSError * _Nullable error) {
        if(spots) {
            for(int i =0; i<spots.count; i++) {
                if(spots[i][@"city"] == nil) {
                    continue;
                }
                if(cities[spots[i][@"city"]] == nil) {
                    [cities setObject:[NSNumber numberWithInt:1] forKey:spots[i][@"city"]];
                    //cities[spots[i][@"city"]] = [NSNumber numberWithInt:1];
                    cityCount = cityCount + 1;
                }
            }
            self.numCities.text = [NSString stringWithFormat:@"%d", cityCount];
        }
    }];
}

- (void)getNumCountries {
    __block int countryCount = 0;
    NSMutableDictionary<NSString*, NSNumber*> *countries = [[NSMutableDictionary alloc] init];
    PFQuery *countryQuery = [PFQuery queryWithClassName:@"Spot"];
    [countryQuery whereKey:@"user" equalTo:self.user];
    [countryQuery includeKey:@"city"];
    [countryQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable spots, NSError * _Nullable error) {
        if(spots) {
            for(int i =0; i<spots.count; i++) {
                if(spots[i][@"country"] == nil) {
                    continue;
                }
                if(countries[spots[i][@"country"]] == nil) {
                    [countries setObject:[NSNumber numberWithInt:1] forKey:spots[i][@"country"]];
                    countryCount = countryCount + 1;
                }
            }
            self.numCountries.text = [NSString stringWithFormat:@"%d", countryCount];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self fetchPlaces];
    [self getNumCities];
    [self getNumCountries];
    
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

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (self.places.count < 10) ? self.places.count : 10;
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
    else if([[segue identifier] isEqualToString:@"profilePlacesSegue"]) {
        ProfilePlacesViewController *viewController = [segue destinationViewController];
        viewController.user = self.user;
    }
}


@end
