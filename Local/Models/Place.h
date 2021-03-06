//
//  Place.h
//  Local
//
//  Created by Caroline Reiser on 7/16/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Place : PFObject<PFSubclassing>

@property (nonatomic, strong) PFFileObject * _Nonnull image;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) NSString* placeID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* country;
@property (nonatomic, strong) PFUser* user;
@property (nonatomic, strong) NSString* adminArea;
@property (nonatomic, strong) NSString* adminArea2;

+ (void) postPlace: (NSString*)place withId:(NSString*) placeID Image:(UIImage * _Nullable)image Latitude:(double)lat Longitude:(double)lng City:(NSString*)city Country:(NSString*)country Admin:(NSString*)admin Admin2:(NSString*)admin2 withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (void)postPlace:(Place*)place withCompletion:(PFBooleanResultBlock  _Nullable)completion;
+ (Place*)setPlace:(NSString*)place withId:(NSString*)placeID Image:(UIImage * _Nullable)image Latitude:(double)lat Longitude:(double)lng City:(NSString*)city Country:(NSString*)country Admin:(NSString*)admin Admin2:(NSString*)admin2;

@end

NS_ASSUME_NONNULL_END
