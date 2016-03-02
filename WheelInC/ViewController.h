//
//  ViewController.h
//  WheelInC
//
//  Created by David MacGuidwin on 1/29/16.
//  Copyright © 2016 David MacGuidwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRotaryProtocol.h"


//@interface ViewController : UIViewController
@interface ViewController : UIViewController<SMRotaryProtocol>

@property (nonatomic, strong) UILabel *sectorLabel;
@property (nonatomic, strong) UIColor *sectorColor;

@end

//@end

