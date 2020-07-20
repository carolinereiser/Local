//
//  PlacePicturePickerViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/16/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "PlacePicturePickerViewController.h"
#import "PostPlaceViewController.h"

@import YangMingShan;

@interface PlacePicturePickerViewController () <YMSPhotoPickerViewControllerDelegate>

@property (nonatomic, strong) NSArray<UIImage *> *images;

@end

@implementation PlacePicturePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)photoRollClick:(id)sender {
    YMSPhotoPickerViewController *pickerViewController = [[YMSPhotoPickerViewController alloc] init];
    pickerViewController.numberOfPhotoToSelect = 1;
    
    UIColor *customColor = [UIColor colorWithRed:64.0/255.0 green:0.0 blue:144.0/255.0 alpha:1.0];
    UIColor *customCameraColor = [UIColor colorWithRed:86.0/255.0 green:1.0/255.0 blue:236.0/255.0 alpha:1.0];

    pickerViewController.theme.titleLabelTextColor = [UIColor whiteColor];
            pickerViewController.theme.navigationBarBackgroundColor = customColor;
    pickerViewController.theme.tintColor = [UIColor whiteColor];
    pickerViewController.theme.orderTintColor = customCameraColor;
    pickerViewController.theme.cameraVeilColor = customCameraColor;
    pickerViewController.theme.cameraIconColor = [UIColor whiteColor];
    pickerViewController.theme.statusBarStyle = UIStatusBarStyleLightContent;
    
    [self yms_presentCustomAlbumPhotoView:pickerViewController delegate:self];
}

- (void)photoPickerViewControllerDidReceivePhotoAlbumAccessDenied:(YMSPhotoPickerViewController *)picker
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Allow photo album access?", nil) message:NSLocalizedString(@"Need your permission to access photo albums", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertController addAction:dismissAction];
    [alertController addAction:settingsAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)photoPickerViewControllerDidReceiveCameraAccessDenied:(YMSPhotoPickerViewController *)picker
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Allow camera access?", nil) message:NSLocalizedString(@"Need your permission to take a photo", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertController addAction:dismissAction];
    [alertController addAction:settingsAction];

    // The access denied of camera is always happened on picker, present alert on it to follow the view hierarchy
    [picker presentViewController:alertController animated:YES completion:nil];
}

- (void)photoPickerViewController:(YMSPhotoPickerViewController *)picker didFinishPickingImage:(UIImage *)image{
    [picker dismissViewControllerAnimated:YES completion:^() {
        //resize image;
        UIImage* resizedImage = [self resizeImage:image withSize:CGSizeMake(400, 400)];
        self.picture.image = resizedImage;
    }];
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
    PostPlaceViewController *postPlaceViewController = [segue destinationViewController];
    postPlaceViewController.image = self.picture.image;
}


@end
