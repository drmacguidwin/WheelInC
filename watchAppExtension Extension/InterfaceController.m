//
//  InterfaceController.m
//  watchAppExtension Extension
//
//  Created by David MacGuidwin on 3/1/16.
//  Copyright © 2016 David MacGuidwin. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import <UIKit/UIKit.h>
#import <WatchKit/WatchKit.h>


@interface InterfaceController() <WCSessionDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *screenImage;

@end

@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(void) session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler{
    NSString *colorSector = [message valueForKey:@"theSector"];
    int colorSectorNumber = [colorSector intValue];
    NSLog(@"this is the sector number %i", colorSectorNumber);

    UIColor *fillColor;
    switch (colorSectorNumber) {
        case 0:
            fillColor = [UIColor blueColor];
            break;
        case 1:
            fillColor = [UIColor greenColor];
            break;
        case 2:
            fillColor = [UIColor redColor];
            break;
        case 3:
            fillColor = [UIColor purpleColor];
            break;
        default:
            break;
    }
    
    CGFloat scale = [WKInterfaceDevice currentDevice].screenScale;
    UIGraphicsBeginImageContextWithOptions(self.contentFrame.size, false, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGColorRef newColor = fillColor.CGColor;
    CGContextSetFillColorWithColor(context, newColor);
    
    CGFloat contentFrameWidth = self.contentFrame.size.width;
    CGFloat contentFrameHeight = self.contentFrame.size.height;
    CGPoint center = CGPointMake(contentFrameWidth / 2.0, contentFrameHeight / 2.0);
    CGFloat radius = MIN(contentFrameWidth / 2.0, contentFrameHeight/ 2.0) - 2;
    
    CGContextBeginPath (context);
    CGContextAddArc(context, center.x, center.y, radius, 0, 2 * M_PI, 1);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    
    CGImageRef cgimage = CGBitmapContextCreateImage(context);
    UIImage *drawingImage = [UIImage imageWithCGImage:cgimage];
    UIGraphicsEndImageContext();
    
    [self.screenImage setImage:drawingImage];
    }


@end