//
//  Place.m
//  Local
//
//  Created by Caroline Reiser on 7/16/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "Place.h"

@implementation Place

@dynamic image;
@dynamic latitude;
@dynamic longitude;
@dynamic placeID;
@dynamic name;
@dynamic user;
@dynamic city;
@dynamic country;

+ (nonnull NSString *)parseClassName {
    return @"Place";
}

+ (void)postPlace:(NSString*)place withId:(NSString*)placeID Image:(UIImage * _Nullable)image Latitude:(double)lat Longitude:(double)lng City:(NSString*)city Country:(NSString*)country withCompletion: (PFBooleanResultBlock  _Nullable)completion
{
    Place* newPlace = [Place new];
    newPlace.image = [self getPFFileFromImage:image];
    newPlace.latitude = lat;
    newPlace.longitude = lng;
    newPlace.placeID = placeID;
    newPlace.name = place;
    newPlace.user = [PFUser currentUser];
    newPlace.city = city;
    newPlace.country = country;
    
    [newPlace saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
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


@end
