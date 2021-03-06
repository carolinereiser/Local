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
@dynamic location;
@dynamic placeID;
@dynamic name;
@dynamic user;
@dynamic city;
@dynamic country;
@dynamic adminArea;
@dynamic adminArea2;

+ (nonnull NSString *)parseClassName {
    return @"Place";
}

+ (void)postPlace:(NSString*)place withId:(NSString*)placeID Image:(UIImage * _Nullable)image Latitude:(double)lat Longitude:(double)lng City:(NSString*)city Country:(NSString*)country Admin:(NSString*)admin Admin2:(NSString*)admin2 withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Place* newPlace = [Place new];
    newPlace.image = [self getPFFileFromImage:image];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:lat longitude:lng];
    newPlace.location = geoPoint;
    newPlace.placeID = placeID;
    newPlace.name = place;
    newPlace.user = [PFUser currentUser];
    newPlace.city = city;
    newPlace.country = country;
    newPlace.adminArea = admin;
    newPlace.adminArea2 = admin2;
    
    [newPlace saveInBackgroundWithBlock:completion];
}

+ (void)postPlace:(Place*)place withCompletion:(PFBooleanResultBlock _Nullable)completion {
    [place saveInBackgroundWithBlock:completion];
}

+ (Place*)setPlace:(NSString*)place withId:(NSString*)placeID Image:(UIImage * _Nullable)image Latitude:(double)lat Longitude:(double)lng City:(NSString*)city Country:(NSString*)country Admin:(NSString*)admin Admin2:(NSString*)admin2 {
    
    Place* newPlace = [Place new];
    newPlace.image = [self getPFFileFromImage:image];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:lat longitude:lng];
    newPlace.location = geoPoint;
    newPlace.placeID = placeID;
    newPlace.name = place;
    newPlace.user = [PFUser currentUser];
    newPlace.city = city;
    newPlace.country = country;
    newPlace.adminArea = admin;
    newPlace.adminArea2 = admin2;
    
    return newPlace;
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
