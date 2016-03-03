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
- (void) wheelDidChangeValue:(NSString *)newValue {
    
    WCSession* session = [WCSession defaultSession];
    session.delegate = self;
    [session activateSession];
    
    //self.sectorLabel.text = newValue;
    
    
    [session sendMessage:@{@"theSector":newValue} replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        
        NSLog(@"Phone Message Sent From Phone");
    } errorHandler:^(NSError * _Nonnull error) {
        NSLog(@"Error Sending Message From Phone");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(void) session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.sectorLabel.text = message[@"b"];
        NSLog(@"MESSAGE FROM WATCH SETS LABEL TO; %@", message);
    });
}

@end
