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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SMRotaryWheel *wheel = [[SMRotaryWheel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) andDelegate:self withSections:4];
    [self.view addSubview:wheel];
}
- (void) wheelDidChangeValue:(NSString *)newValue {
    // create connectivity session to pass data between phone and watch
    WCSession* session = [WCSession defaultSession];
    session.delegate = self;
    [session activateSession];
    // pass 'newValue' as "theSector" the phone app is currently on
    [session sendMessage:@{@"theSector":newValue} replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        NSLog(@"Phone Message Sent From Phone");
    } errorHandler:^(NSError * _Nonnull error) {
        NSLog(@"Error Sending Message From Phone");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end