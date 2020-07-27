//
//  CommentViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/27/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "CommentCell.h"
#import "CommentViewController.h"

@import MBProgressHUD;

@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray<PFObject *> *comments;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchComments];
}

- (void)fetchComments {
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query orderByAscending:@"createdAt"];
    [query whereKey:@"spot" equalTo:self.spot];
    [query includeKey:@"user"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable comments, NSError * _Nullable error) {
        if(comments != nil)
        {
            self.comments = comments;
            NSLog(@"%@", self.comments);
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didSendComment:(id)sender {
    if([self.comment.text isKindOfClass:[NSString class]])
    {
        PFObject *comment = [PFObject objectWithClassName:@"Comments"];
        comment[@"user"] = [PFUser currentUser];
        comment[@"spot"] = self.spot;
        comment[@"text"] = self.comment.text;
        
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded)
            {
                NSLog(@"Successfully commented!");
                [self fetchComments];
                //update comment count
                NSNumber *currCount = self.spot.commentCount;
                int val = [currCount intValue];
                val += 1;
                self.spot.commentCount = [NSNumber numberWithInt:val];
                [self.spot saveInBackground];
            }
            else
            {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CommentCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    cell.profilePic.file = self.comments[indexPath.row][@"profilePic"];
    [cell.profilePic loadInBackground];
    cell.username.text = self.comments[indexPath.row][@"user"][@"username"];
    cell.comment.text = self.comments[indexPath.row][@"text"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (IBAction)didTap:(id)sender {
    [self.view endEditing:YES];
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
