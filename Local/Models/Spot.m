//
//  Spot.m
//  Local
//
//  Created by Caroline Reiser on 7/17/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <Parse/Parse.h>
#import "Spot.h"

@implementation Spot

@dynamic images;
@dynamic placeID;
@dynamic title;
@dynamic user;
@dynamic city;
@dynamic country;
@dynamic isCertified;
@dynamic spotDescription;
@dynamic place;
@dynamic address;
@dynamic location;

+ (nonnull NSString *)parseClassName {
    return @"Spot";
}

+ (void)postSpot:(NSString*)spot withId:(NSString*)placeID Name:(NSString*)name Image:(NSArray<UIImage *> *)images Latitude:(double)lat Longitude:(double)lng City:(NSString*)city Country:(NSString*)country Caption:(NSString*)caption Place:(Place*)place withCompletion: (PFBooleanResultBlock  _Nullable)completion
{
    Spot* newSpot = [Spot new];
    //for map annotation
    
    
    //for Parse
    newSpot.images = [self getPFFilesFromImages:images];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:lat longitude:lng];
    newSpot.location = geoPoint;
    newSpot.placeID = placeID;
    newSpot.address = spot;
    newSpot.title = name;
    newSpot.user = [PFUser currentUser];
    newSpot.city = city;
    newSpot.country = country;
    newSpot.spotDescription = caption;
    newSpot.place = place;
                       
    newSpot.isCertified = [self checkLatitude:geoPoint];
    
    [newSpot saveInBackgroundWithBlock: completion];
}

+ (BOOL)checkLatitude:(PFGeoPoint*)loc1
{
    CLLocation *point1 = [[CLLocation alloc] initWithLatitude:loc1.latitude longitude:loc1.longitude];
    PFGeoPoint *userGeoPoint = [PFUser currentUser][@"location"];
    CLLocation *point2 = [[CLLocation alloc] initWithLatitude:userGeoPoint.latitude longitude:userGeoPoint.longitude];
    
    CLLocationDistance distance = [point1 distanceFromLocation:point2];
    if(distance <= 48270)
    {
        //less than 30 miles
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSArray<PFFileObject *> *)getPFFilesFromImages: (NSArray<UIImage *> *)images {
    NSMutableArray<PFFileObject *> *tempArray = [[NSMutableArray alloc] init];
    for(int i =0; i<[images count]; i++)
    {
        // check if image is not nil
           if (!images[i]) {
               continue;
           }
           
           NSData *imageData = UIImagePNGRepresentation(images[i]);
           // get image data and check if that is not nil
           if (!imageData) {
               continue;
           }
        PFFileObject *picture = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
        [tempArray addObject:picture];
    }
    NSArray<PFFileObject *> *arr = [tempArray copy];
    
    return arr;
}

@end
