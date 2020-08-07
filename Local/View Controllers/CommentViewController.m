//
//  CommentViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/27/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "CommentCell.h"
#import "CommentViewController.h"
#import "DateTools.h"
#import "ProfileViewController.h"

@import MBProgressHUD;

@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray<PFObject *> *comments;
@property (weak, nonatomic) IBOutlet UIView *commentView;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.designView.layer.cornerRadius = 30;
    self.designView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardOffScreen:) name:UIKeyboardWillHideNotification object:nil];
    
    if([PFUser currentUser][@"profilePic"]) {
        self.profilePic.file = [PFUser currentUser][@"profilePic"];
        [self.profilePic loadInBackground];
    }
    
    [self getCommentCount];
    [self fetchComments];
}

- (void)viewDidAppear:(BOOL)animated {
    [self getCommentCount];
    [self fetchComments];
}

- (void)getCommentCount {
    self.numComments.text = [NSString stringWithFormat:@"%@", self.spot.commentCount];
    
    if([self.spot.commentCount isEqual:@1]) {
        self.commentLabel.text = @"comment";
    }
    else {
        self.commentLabel.text = @"comments";
    }
}

- (void)keyboardOnScreen:(NSNotification *)notification {
    //get height of keyboard
    NSDictionary *info = notification.userInfo;
    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
 
    //shift view up the height of the keyboard
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -1*keyboardFrame.size.height);
    }];
    
}

- (void)keyboardOffScreen:(NSNotification *) notification {
    //return back to normal
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
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
            [self.tableView reloadData];
            if(self.comments.count > 0) {
                NSIndexPath* ipath = [NSIndexPath indexPathForRow:(self.comments.count -1) inSection:0];
                [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didSendComment:(id)sender {
    if([self.comment.text isKindOfClass:[NSString class]] && ![self.comment.text isEqualToString:@""])
    {
        PFObject *comment = [PFObject objectWithClassName:@"Comments"];
        comment[@"user"] = [PFUser currentUser];
        comment[@"spot"] = self.spot;
        comment[@"text"] = self.comment.text;
        comment[@"owner"] = self.spot.user;
        
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
                [self.spot saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if(succeeded) {
                        [self getCommentCount];
                        NSIndexPath* ipath = [NSIndexPath indexPathForRow:(self.comments.count -1) inSection:0];
                        [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
                    }
                }];
            }
            else
            {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
    [self.view endEditing:YES];
    self.comment.text = @"";
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CommentCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    cell.comment.attributedText = nil;
    if(self.comments[indexPath.row][@"user"][@"profilePic"]) {
        cell.profilePic.file = self.comments[indexPath.row][@"user"][@"profilePic"];
        [cell.profilePic loadInBackground];
    }
    else {
        cell.profilePic.image = [UIImage systemImageNamed:@"person.circle.fill"];
    }

    NSString* username = self.comments[indexPath.row][@"user"][@"username"];
    NSString* string = [NSString stringWithFormat:@"%@ %@", username, self.comments[indexPath.row][@"text"]];
    NSMutableAttributedString* displayString = [[NSMutableAttributedString alloc]initWithString:string];
    [displayString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0] range:NSMakeRange(0, [username length])];
    
    cell.comment.attributedText = displayString;
    
    
    NSDate *date = self.comments[indexPath.row].createdAt;
    cell.timeStamp.text = date.shortTimeAgoSinceNow;
    
    cell.profileButton.tag = indexPath.row;
        
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (IBAction)didTap:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIButton *tappedButton = sender;
    ProfileViewController *profileViewController = [segue destinationViewController];
    PFUser *user = self.comments[tappedButton.tag][@"user"];
    profileViewController.user = user;
}


@end
