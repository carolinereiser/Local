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
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSString* placeID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* country;
@property (nonatomic, strong) NSString* spotDescription;
@property (nonatomic) BOOL isCertified;
@property (nonatomic, strong) PFUser* user;
@property (nonatomic, strong) Place* place;

@end

NS_ASSUME_NONNULL_END
