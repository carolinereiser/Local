//
//  PlaceCell.m
//  Local
//
//  Created by Caroline Reiser on 7/20/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "PlaceCell.h"

@implementation PlaceCell

- (void)setPlace:(Place*)place
{
    _place = place;
    
    self.image.file = place[@"image"];
    [self.image loadInBackground];
    
    self.placeName.text = place.name;
    [self.placeName sizeToFit];
}

@end
