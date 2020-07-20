//
//  Spot.h
//  Local
//
//  Created by Caroline Reiser on 7/17/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <Parse/Parse.h>
#import "Place.h"

NS_ASSUME_NONNULL_BEGIN

@interface Spot : PFObject <PFSubclassing>

@property (nonatomic, strong) NSArray <PFFileObject *> *images;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) NSString* placeID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* country;
@property (nonatomic, strong) NSString* spotDescription;
@property (nonatomic) BOOL isCertified;
@property (nonatomic, strong) PFUser* user;
@property (nonatomic, strong) Place* place;

+ (BOOL)checkLatitude:(PFGeoPoint*)loc1;
+ (void)postSpot:(NSString*)spot withId:(NSString*)placeID Image:(NSArray<UIImage *> *)images Latitude:(double)lat Longitude:(double)lng City:(NSString*)city Country:(NSString*)country Caption:(NSString*)caption Place:(Place*)place withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
