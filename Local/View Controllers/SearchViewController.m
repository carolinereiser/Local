//
//  SearchViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/27/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "SearchViewController.h"

@import Parse;

@interface SearchViewController () <UISearchBarDelegate>

@property (nonatomic, strong) NSArray<PFUser *> *users;
@property (nonatomic, strong) NSArray<PFUser *> *filteredUsers;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchBar.delegate = self;
    //self.tableView.delegate = self;
    //self.tableView.dataSource = self;
    
    //get users
    [self fetchUsers];
}

- (void)fetchUsers {
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" notEqualTo:[PFUser currentUser].username];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        if(users)
        {
            self.users = users;
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
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
