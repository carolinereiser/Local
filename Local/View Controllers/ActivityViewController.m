//
//  ActivityViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/28/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "ActivityCell.h"
#import "ActivityViewController.h"
#import "DateTools.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "ProfileViewController.h"

@import Parse;

@interface ActivityViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSArray<PFObject *> *likes;
@property (nonatomic, strong) NSArray<PFObject *> *comments;
@property (nonatomic, strong) NSArray<PFObject *> *follows;
@property (nonatomic, strong) NSArray<PFObject *> *allActivity;
@property (weak, nonatomic) IBOutlet UIView *designView;

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
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.designView.layer.cornerRadius = 30;
    self.designView.layer.maskedCorners = kCALayerMinXMinYCorner;
}

- (void)viewWillAppear:(BOOL)animated {
    [self fetchActivity];
}

- (int)getNumNewNotifications {
    int count = 0;
    for(int i =0; i<[self.allActivity count]; i++) {
        if(i >10) {
            break;
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss";
        
        
        NSString *date1 = [PFUser currentUser][@"lastChecked"];
        NSString *date2 = [formatter stringFromDate:self.allActivity[i].createdAt];
        
        NSDate* lastChecked = [formatter dateFromString:date1];
        NSDate* createdDate = [formatter dateFromString:date2];
        
        if([lastChecked compare:createdDate] == NSOrderedAscending) {
            count++;
            NSLog(@"%d", count);
        }
        else {
            break;
        }
    }
    return count;
}

- (void)configureNotifcationText:(int)numNew {
    if(numNew < 10) {
        self.notificationLabel.text = [NSString stringWithFormat:@"%d", numNew];
    }
    else {
        self.notificationLabel.text = @"10+";
    }
    
    if(numNew == 1) {
        self.notificationText.text = @"new notification";
    }
    else {
        self.notificationText.text = @"new notifications";
    }
}

- (void)updateChecked {
    //get date/time
    NSDate* currDate = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"E MMM d HH:mm:ss"];
    NSString* generalizedDate = [formatter stringFromDate:currDate];
    

    [PFUser currentUser][@"lastChecked"] = generalizedDate;
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"Recorded new lastChecked");
        }
    }];
}

- (void)fetchActivity {
    //find the likes
    PFQuery *likeQuery = [PFQuery queryWithClassName:@"Likes"];
    [likeQuery whereKey:@"owner" equalTo:[PFUser currentUser]];
    [likeQuery whereKey:@"user" notEqualTo:[PFUser currentUser]];
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
             [commentQuery whereKey:@"user" notEqualTo:[PFUser currentUser]];
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
                      [followQuery whereKey:@"user" notEqualTo:[PFUser currentUser]];
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
                               int numNew = [self getNumNewNotifications];
                               [self configureNotifcationText:numNew];
                               [self updateChecked];
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
    //get profile pic
    if(self.allActivity[indexPath.row][@"user"][@"profilePic"]) {
        cell.profilePic.file = self.allActivity[indexPath.row][@"user"][@"profilePic"];
        [cell.profilePic loadInBackground];
    }
    else {
        cell.profilePic.image = [UIImage systemImageNamed:@"person.circle.fill"];
    }
    cell.profileButton.tag = indexPath.row;
    //get text string
    PFObject* object = [self.allActivity[indexPath.row] fetchIfNeeded];
    if([[object parseClassName] isEqualToString:@"Likes"]) {
        NSString* username = object[@"user"][@"username"];
        NSString* string = [NSString stringWithFormat:@"%@ liked your spot", username];
        
        NSMutableAttributedString* displayString = [[NSMutableAttributedString alloc]initWithString:string];
        
        [displayString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0] range:NSMakeRange(0, [username length])];
        
        cell.text.attributedText = displayString;
    }
    else if([[object parseClassName] isEqualToString:@"Comments"]) {
        NSString* username = object[@"user"][@"username"];
        NSString* string = [NSString stringWithFormat:@"%@ commented \"%@\"", username, object[@"text"]];
        
        NSMutableAttributedString* displayString = [[NSMutableAttributedString alloc]initWithString:string];
        
        [displayString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0] range:NSMakeRange(0, [username length])];
        
        cell.text.attributedText = displayString;
        
    }
    else if([[object parseClassName] isEqualToString:@"Following"]) {
        NSString* username = object[@"user"][@"username"]; 
        NSString* string = [NSString stringWithFormat:@"%@ followed you", username];
        
        NSMutableAttributedString* displayString = [[NSMutableAttributedString alloc]initWithString:string];
        
        [displayString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0] range:NSMakeRange(0, [username length])];
        
        cell.text.attributedText = displayString;
    }
    
    //get how long ago it happened
    NSDate *date = object.createdAt;
    cell.timeStamp.text = date.shortTimeAgoSinceNow;
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"profileSegue"]) {
        UIButton *tappedButton = sender;
        ProfileViewController *profileViewController = [segue destinationViewController];
        PFUser *user = self.allActivity[tappedButton.tag][@"user"];
        profileViewController.user = user;
    }
}


@end
