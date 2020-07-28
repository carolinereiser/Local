//
//  ActivityViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/28/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "ActivityViewController.h"

@import Parse;

@interface ActivityViewController () //<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<PFObject *> *likes;
@property (nonatomic, strong) NSArray<PFObject *> *comments;
@property (nonatomic, strong) NSArray<PFObject *> *follows;
@property (nonatomic, strong) NSArray<PFObject *> *allActivity;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.tableView.delegate = self;
    //self.tableView.dataSource = self;
    
    [self fetchActivity];
}

- (void)fetchActivity {
    PFQuery *likeQuery = [PFQuery queryWithClassName:@"Likes"];
    [likeQuery whereKey:@"owner" equalTo:[PFUser currentUser]];
    [likeQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable likes, NSError * _Nullable error) {
         if(likes) {
             self.likes = likes;
         }
         else {
             NSLog(@"%@", error.localizedDescription);
         }
     }];
    
    PFQuery *commentQuery = [PFQuery queryWithClassName:@"Comments"];
    [commentQuery whereKey:@"owner" equalTo:[PFUser currentUser]];
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable comments, NSError * _Nullable error) {
         if(comments) {
             self.comments = comments;
         }
         else {
             NSLog(@"%@", error.localizedDescription);
         }
     }];
    
    PFQuery *followQuery = [PFQuery queryWithClassName:@"Following"];
    [followQuery whereKey:@"following" equalTo:[PFUser currentUser]];
    [followQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable follows, NSError * _Nullable error) {
        if(follows) {
            NSLog(@"%@", follows);
             self.follows = follows;
         }
         else {
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
