//
//  SearchViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/27/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "Place.h"
#import "PlaceViewController.h"
#import "ProfileViewController.h"
#import "SearchResultCell.h"
#import "SearchViewController.h"

@import Parse;

@interface SearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSArray<PFObject *> *results;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView reloadEmptyDataSet];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(![searchText isEqualToString:@""]) {
        [self search:searchText];
    }
    else {
        self.results = @[];
        [self.tableView reloadData];
    }
}

- (IBAction)switchSearch:(id)sender {
    if(![self.searchBar.text isEqualToString:@""]) {
        [self search:self.searchBar.text];
    }
}

- (void)search:(NSString*)searchText {
    //search users
    if([self.segmentedControl selectedSegmentIndex] == 0) {
        PFQuery *query1 = [PFUser query];
        [query1 whereKey:@"username" notEqualTo:[PFUser currentUser].username];
        [query1 whereKey:@"username" containsString:[searchText lowercaseString]];
        
        PFQuery *query2 = [PFUser query];
        [query2 whereKey:@"username" notEqualTo:[PFUser currentUser].username];
        [query2 whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)%@",searchText]];
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1, query2]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
            if(users)
            {
                self.results = users;
                [self.tableView reloadData];
            }
            else
            {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
    //search places
    else {
        PFQuery *query1 = [PFQuery queryWithClassName:@"Place"];
        [query1 whereKey:@"user" notEqualTo:[PFUser currentUser]];
        [query1 whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)%@",searchText]];
        
        PFQuery *query2 = [PFQuery queryWithClassName:@"Place"];
        [query2 whereKey:@"user" notEqualTo:[PFUser currentUser]];
        [query2 whereKey:@"city" matchesRegex:[NSString stringWithFormat:@"(?i)%@",searchText]];
        
        PFQuery *query3 = [PFQuery queryWithClassName:@"Place"];
        [query3 whereKey:@"user" notEqualTo:[PFUser currentUser]];
        [query3 whereKey:@"country" matchesRegex:[NSString stringWithFormat:@"(?i)%@",searchText]];
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1, query2, query3]];
        [query includeKey:@"user"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable places, NSError * _Nullable error) {
            if(places)
            {
                self.results = places;
                [self.tableView reloadData];
            }
            else
            {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
}

//dismiss the keyboard when a user presses search
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SearchResultCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    if([self.segmentedControl selectedSegmentIndex] == 0) {
        cell.profilePic.file = self.results[indexPath.row][@"profilePic"];
        [cell.profilePic loadInBackground];
        cell.username.text = [NSString stringWithFormat:@"%@", self.results[indexPath.row][@"username"]];
        PFQuery *query = [PFQuery queryWithClassName:@"Following"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query whereKey:@"following" equalTo:self.results[indexPath.row]];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if(objects != nil) {
                if(objects.count == 1) {
                    cell.subtitle.text = @"Following";
                }
                else {
                    cell.subtitle.text = @"Not Following";
                }
            }
            else {
                NSLog(@"%@", error.localizedDescription);
                cell.subtitle.text = @"";
            }
        }];
    }
    else {
        cell.profilePic.file = self.results[indexPath.row][@"image"];
        [cell.profilePic loadInBackground];
        cell.username.text = self.results[indexPath.row][@"name"];
        cell.subtitle.text = [NSString stringWithFormat:@"@%@", self.results[indexPath.row][@"user"][@"username"]];
    }
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if([self.segmentedControl selectedSegmentIndex] == 0) {
        [self performSegueWithIdentifier:@"profileSegue" sender:cell];
    }
    else {
        [self performSegueWithIdentifier:@"placeSegue" sender:cell];
    }
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [self resizeImage:[UIImage imageNamed:@"icons8-nothing-found-80"] withSize:(CGSizeMake(100,100))];
}


- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
        NSString *text = @"No Results";
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                     NSForegroundColorAttributeName: [UIColor darkGrayColor]};
        
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString* text = @"Try searching for something else";

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"profileSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        PFUser *user = self.results[indexPath.row];
        ProfileViewController* profileViewController = [segue destinationViewController];
        profileViewController.user = user;
    }
    else if([[segue identifier] isEqualToString:@"placeSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Place *place = self.results[indexPath.row];
        PlaceViewController* placeViewController = [segue destinationViewController];
        placeViewController.place = place;
        placeViewController.user = place.user;
    }
}




@end
