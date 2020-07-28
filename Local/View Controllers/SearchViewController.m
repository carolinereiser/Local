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

@property (nonatomic, strong) NSArray<PFUser *> *users;
@property (nonatomic, strong) NSArray<PFUser *> *filteredUsers;

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
    [self search:searchText];
}

- (void)search:(NSString*)searchText {
    //search users
    if([self.segmentedControl selectedSegmentIndex] == 0) {
        PFQuery *query1 = [PFUser query];
        [query1 whereKey:@"username" notEqualTo:[PFUser currentUser].username];
        [query1 whereKey:@"username" containsString:[searchText lowercaseString]];
        
        PFQuery *query2 = [PFUser query];
        [query2 whereKey:@"username" notEqualTo:[PFUser currentUser].username];
        [query2 whereKey:@"name" containsString:searchText];
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1, query2]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
            if(users)
            {
                self.users = users;
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
        
    }
}

//dismiss the keyboard when a user presses search
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SearchResultCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    cell.profilePic.file = self.users[indexPath.row][@"profilePic"];
    [cell.profilePic loadInBackground];
    cell.username.text = [NSString stringWithFormat:@"@%@", self.users[indexPath.row].username];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    PFUser *user = self.users[indexPath.row];
    ProfileViewController* profileViewController = [segue destinationViewController];
    profileViewController.user = user;
}




@end
