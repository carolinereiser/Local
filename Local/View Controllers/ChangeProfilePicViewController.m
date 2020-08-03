//
//  ChangeProfilePicViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/31/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "ChangeProfilePicViewController.h"

@interface ChangeProfilePicViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ChangeProfilePicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getProfilePic];
}

- (void)getProfilePic{
    //TODO: Use CoreData to load profile pic when no network connection
    PFUser* user = [PFUser currentUser];
    if(user[@"profilePic"])
    {
        self.profilePic.file = user[@"profilePic"];
        [self.profilePic loadInBackground];
    }
}

- (IBAction)changePic:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    //self.picture.image = [self resizeImage:editedImage withSize:(CGSizeMake)(500,500)];
    PFUser* currUser = [PFUser currentUser];
    currUser[@"profilePic"] = [self getPFFileFromImage:editedImage];
    
    [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded)
        {
            NSLog(@"Uploaded profile pic!");
            [self getProfilePic];
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

- (IBAction)confirmSelection:(id)sender {
    if([PFUser currentUser][@"profilePic"]) {
        [self performSegueWithIdentifier:@"nextSegue" sender:nil];
    }
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
