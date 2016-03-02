//
//  SMRotaryWheel.h
//  WheelInC
//
//  Created by David MacGuidwin on 2/2/16.
//  Copyright © 2016 David MacGuidwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRotaryProtocol.h"
#import "SMSector.h"

@interface SMRotaryWheel : UIControl

@property (nonatomic, strong) NSMutableArray *sectors;
@property int currentSector;

@property (weak) id <SMRotaryProtocol> delegate;
@property (nonatomic, strong) UIView *container;
@property int numberOfSections;
@property CGAffineTransform startTransform;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber;
- (void)rotate;

@end
