//
//  ViewController.m
//  WheelInC
//
//  Created by David MacGuidwin on 1/29/16.
//  Copyright © 2016 David MacGuidwin. All rights reserved.
//

#import "ViewController.h"
#import "SMRotaryWheel.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface ViewController () <WCSessionDelegate>

@end

@implementation ViewController
@synthesize sectorLabel, sectorColor;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    
    sectorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    //sectorLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:sectorLabel];
    
    SMRotaryWheel *wheel = [[SMRotaryWheel alloc] initWithFrame:CGRectMake(0, 0, 425, 600) andDelegate:self withSections:4];
    
    //wheel.center = CGPointMake(160, 240);
    
    [self.view addSubview:wheel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) wheelDidChangeValue:(NSString *)newValue {
    self.sectorLabel.text = newValue;
}


@end
