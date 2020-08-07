//
//  ProfileSavesViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/30/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "ProfileSavesViewController.h"
#import "RandomSpotViewController.h"
#import "SaveCell.h"

@import Parse;

@interface ProfileSavesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) NSArray<PFObject *> *saved;

@end

@implementation ProfileSavesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    self.collectionView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    
    self.navigationItem.title = @"Saves";
    
    [self fetchSaves];
    
    if(self.user[@"profilePic"]) {
        self.profilePic.file = self.user[@"profilePic"];
        [self.profilePic loadInBackground];
    }
    else {
        self.profilePic.image = [UIImage systemImageNamed:@"person.circle.fill"];
    }
    
    self.username.text = [NSString stringWithFormat:@"@%@", self.user.username];
    
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

- (void)viewDidAppear:(BOOL)animated {
    [self fetchSaves];
}

- (void)fetchSaves {
    PFQuery* query = [PFQuery queryWithClassName:@"Saves"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"spot"];
    [query whereKey:@"user" equalTo:self.user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *spots, NSError *error) {
        if (spots != nil) {
            // do something with the array of object returned by the call
            self.saved = spots;
            [self.collectionView reloadData];
        }
        else {
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


- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [self resizeImage:[UIImage imageNamed:@"icons8-palm-tree-80"] withSize:(CGSizeMake(100,100))];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No Saves";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString* text = @"";
    if([self.user isEqual:[PFUser currentUser]]) {
        text = @"When you save Spots, they will show up here!";
    }
    else {
        text = [NSString stringWithFormat:@"When %@ saves a Spot, it will show up here!", self.user.username];
    }
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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
