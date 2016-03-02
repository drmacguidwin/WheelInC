//
//  SMSector.m
//  WheelInC
//
//  Created by David MacGuidwin on 2/9/16.
//  Copyright © 2016 David MacGuidwin. All rights reserved.
//

#import "SMSector.h"

@implementation SMSector

@synthesize minValue, maxValue, midValue, sector;

- (NSString *) description {
    return [NSString stringWithFormat: @"%i | %f, %f, %f", self.sector, self.minValue, self.midValue, self.maxValue];
}

@end
