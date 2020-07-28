//
//  SearchViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/27/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "ProfileViewController.h"
#import "SearchResultCell.h"
#import "SearchViewController.h"

@import Parse;

@interface SearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray<PFUser *> *results;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(![self.searchBar.text isEqualToString:@""]) {
        [self search:searchText];
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
        cell.username.text = [NSString stringWithFormat:@"@%@", self.results[indexPath.row].username];
    }
    else {
        cell.profilePic.file = self.results[indexPath.row][@"image"];
        [cell.profilePic loadInBackground];
        cell.username.text = self.results[indexPath.row][@"name"];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    PFUser *user = self.results[indexPath.row];
    ProfileViewController* profileViewController = [segue destinationViewController];
    profileViewController.user = user;
}




@end
