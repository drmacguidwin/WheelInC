//
//  InterfaceController.m
//  watchAppExtension Extension
//
//  Created by David MacGuidwin on 3/1/16.
//  Copyright © 2016 David MacGuidwin. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>


@interface InterfaceController() <WCSessionDelegate>

- (void)drawCircle;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *counterLabel;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
-(void) drawCircle {
#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)
    
}

@end



