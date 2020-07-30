//
//  ActivityViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/28/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "ActivityCell.h"
#import "ActivityViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@import Parse;

@interface ActivityViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSArray<PFObject *> *likes;
@property (nonatomic, strong) NSArray<PFObject *> *comments;
@property (nonatomic, strong) NSArray<PFObject *> *follows;
@property (nonatomic, strong) NSArray<PFObject *> *allActivity;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.tableFooterView = [UIView new];
    
    [self fetchActivity];
}

- (void)viewWillAppear:(BOOL)animated {
    [self fetchActivity];
}

- (void)fetchActivity {
    //find the likes
    PFQuery *likeQuery = [PFQuery queryWithClassName:@"Likes"];
    [likeQuery whereKey:@"owner" equalTo:[PFUser currentUser]];
    [likeQuery includeKey:@"createdAt"];
    [likeQuery includeKey:@"user"];
    [likeQuery orderByDescending:@"createdAt"];
    likeQuery.limit = 50;
    [likeQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable likes, NSError * _Nullable error) {
         if(likes) {
             self.likes = likes;
             //once likes are found, find the comments
             PFQuery *commentQuery = [PFQuery queryWithClassName:@"Comments"];
             [commentQuery whereKey:@"owner" equalTo:[PFUser currentUser]];
             [commentQuery includeKey:@"createdAt"];
             [commentQuery includeKey:@"user"];
             [commentQuery orderByDescending:@"createdAt"];
             commentQuery.limit = 50;
             [commentQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable comments, NSError * _Nullable error) {
                  if(comments) {
                      self.comments = comments;
                      //once comments found, find the follows
                      PFQuery *followQuery = [PFQuery queryWithClassName:@"Following"];
                      [followQuery whereKey:@"following" equalTo:[PFUser currentUser]];
                      [followQuery includeKey:@"createdAt"];
                      [followQuery includeKey:@"user"];
                      [followQuery orderByDescending:@"createdAt"];
                      followQuery.limit = 50;
                      [followQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable follows, NSError * _Nullable error) {
                          if(follows) {
                               self.follows = follows;
                               //sort the arrays, must do in here because of asynchronous API calls
                               NSArray* temp = [self mergeArray:self.likes rightArray:self.comments];
                               self.allActivity = [self mergeArray:temp rightArray:self.follows];
                               [self.tableView reloadData];
                           }
                           else {
                               NSLog(@"%@", error.localizedDescription);
                           }
                       }];
                  }
                  else {
                      NSLog(@"%@", error.localizedDescription);
                  }
              }];
         }
         else {
             NSLog(@"%@", error.localizedDescription);
         }
     }];
}

- (NSArray *) mergeArray:(NSArray *)leftArray rightArray:(NSArray *)rightArray {
    NSMutableArray *returnArray = [NSMutableArray array];
    int i = 0, e = 0;
 
    while (i < [leftArray count] && e < [rightArray count]) {
        //sort by createdAt date
        NSDate *leftDate = [[leftArray objectAtIndex:i] createdAt];
        NSDate *rightDate = [[rightArray objectAtIndex:e] createdAt];
        if ([leftDate compare:rightDate] == NSOrderedDescending) {
            [returnArray addObject: [leftArray objectAtIndex:i++]];
        } else {
            [returnArray addObject: [rightArray objectAtIndex:e++]];
        }
    }
 
    while (i < [leftArray count]) {
        [returnArray addObject: [leftArray objectAtIndex:i++]];
    }
 
    while (e < [rightArray count]) {
        [returnArray addObject: [rightArray objectAtIndex:e++]];
    }
 
    return returnArray;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ActivityCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
    cell.profilePic.file = self.allActivity[indexPath.row][@"user"][@"profilePic"];
    [cell.profilePic loadInBackground];

    PFObject* object = [self.allActivity[indexPath.row] fetchIfNeeded];
    if([[object parseClassName] isEqualToString:@"Likes"]) {
        cell.text.text = [NSString stringWithFormat:@"%@ liked your spot", object[@"user"][@"username"]];
    }
    else if([[object parseClassName] isEqualToString:@"Comments"]) {
        cell.text.text = [NSString stringWithFormat:@"%@ commented \"%@\"", object[@"user"][@"username"], object[@"text"]];
    }
    else if([[object parseClassName] isEqualToString:@"Following"]) {
        cell.text.text = [NSString stringWithFormat:@"%@ followed you", object[@"user"][@"username"]];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allActivity.count;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
        NSString *text = @"No Activity";
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                     NSForegroundColorAttributeName: [UIColor darkGrayColor]};
        
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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
