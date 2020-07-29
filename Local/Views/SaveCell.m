//
//  SaveCell.m
//  Local
//
//  Created by Caroline Reiser on 7/29/20.
//  Copyright © 2020 Caroline Reiser. All rights reserved.
//

#import "SaveCell.h"

@implementation SaveCell

- (void)setSpot:(Spot*)spot
{
    _spot = spot;
    
    self.picture.file = spot[@"images"][0];
    [self.picture loadInBackground];
    
    self.name.text = spot[@"title"];
    [self.name sizeToFit];
}

@end
