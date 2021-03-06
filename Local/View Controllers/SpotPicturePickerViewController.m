//
//  SpotPicturePickerViewController.m
//  Local
//
//  Created by Caroline Reiser on 7/17/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "SpotPlacePickerViewController.h"
#import "SpotPicturePickerViewController.h"
#import "SpotPostCell.h"

//to select multiple photos at once
@import YangMingShan;

@interface SpotPicturePickerViewController () <UICollectionViewDataSource, UICollectionViewDelegate, YMSPhotoPickerViewControllerDelegate>

@end

@implementation SpotPicturePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.images.count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.collectionView.frame = self.view.frame;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    
    CGFloat imagesPerLine = 1;
    CGFloat itemWidth = (self.collectionView.frame.size.width - (layout.minimumInteritemSpacing * (imagesPerLine - 1))) / imagesPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (IBAction)selectPictures:(id)sender {
    YMSPhotoPickerViewController *pickerViewController = [[YMSPhotoPickerViewController alloc] init];
    pickerViewController.numberOfPhotoToSelect = 10;
    
    UIColor *customColor = [UIColor colorWithRed: 1.00 green: 0.62 blue: 0.11 alpha: 1.00];
    UIColor *customCameraColor = [UIColor colorWithRed: 1.00 green: 0.62 blue: 0.11 alpha: 0.3];

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

- (void)photoPickerViewController:(YMSPhotoPickerViewController *)picker didFinishPickingImages:(NSArray *)photoAssets
{
    [picker dismissViewControllerAnimated:YES completion:^() {
        // Remember images you get here is PHAsset array, you need to implement PHImageManager to get UIImage data by yourself
        PHImageManager *imageManager = [[PHImageManager alloc] init];

        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.networkAccessAllowed = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.synchronous = YES;

        NSMutableArray *mutableImages = [NSMutableArray array];

        for (PHAsset *asset in photoAssets) {
            CGSize targetSize = CGSizeMake((CGRectGetWidth(self.collectionView.bounds) - 20*2) * [UIScreen mainScreen].scale, (CGRectGetHeight(self.collectionView.bounds) - 20*2) * [UIScreen mainScreen].scale);
            [imageManager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *image, NSDictionary *info) {
                [mutableImages addObject:image];
            }];
        }

        // Assign to Array with images
        self.images = [mutableImages copy];
        if(self.images.count != 0) {
            self.navigationItem.rightBarButtonItem = self.nextButton;
        }
        else {
            self.navigationItem.rightBarButtonItem = nil;
        }
        [self.collectionView reloadData];
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SpotPostCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"SpotPostCell" forIndexPath:indexPath];
    cell.picture.image = self.images[indexPath.item];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
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
    SpotPlacePickerViewController *spotViewController = [segue destinationViewController];
    spotViewController.images = self.images;
}


@end
