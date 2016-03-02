//
//  SMRotaryProtocol.h
//  WheelInC
//
//  Created by David MacGuidwin on 2/2/16.
//  Copyright © 2016 David MacGuidwin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMRotaryProtocol <NSObject>

- (void) wheelDidChangeValue:(NSString *)newValue;

@end
