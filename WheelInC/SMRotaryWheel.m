//
//  SMRotaryWheel.m
//  WheelInC
//
//  Created by David MacGuidwin on 2/2/16.
//  Copyright © 2016 David MacGuidwin. All rights reserved.
//

#import "SMRotaryWheel.h"
#import <QuartzCore/QuartzCore.h>
#import <WatchConnectivity/WatchConnectivity.h>


@interface SMRotaryWheel()

- (void)drawWheel;
- (float)calculateDistanceFromCenter:(CGPoint)point;
- (void) buildSectorsEven;
- (void) buildSectorsOdd;

@end

static float deltaAngle;
@implementation SMRotaryWheel

@synthesize currentSector, sectors, startTransform, delegate, container, numberOfSections;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber {
    if ((self = [super initWithFrame:frame])) {
        
        self.currentSector = 0;
        self.numberOfSections = sectionsNumber;
        self.delegate = del;
        
        [self drawWheel];
    }
    return self;
}

-(void) drawWheel {
#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)
    
    // set entire screen as container
    container = [[UIView alloc] initWithFrame:self.frame];
    CGFloat angleSize = 2*M_PI/numberOfSections;
    CGPoint centerOne = CGPointMake(CGRectGetWidth(container.bounds)/2.f, CGRectGetHeight(container.bounds)/2.f);
    CGFloat radius = 150;
    
    //create a color array to hold optional colors for the wheel
    NSMutableArray *colorArray = [[NSMutableArray alloc] initWithObjects:[UIColor blueColor], [UIColor greenColor], [UIColor redColor], [UIColor purpleColor], nil];
    
    // create a loop to fill the entire circle with the colored sections
    for (int i = 0; i < numberOfSections; i++) {
    
        CGFloat angle = DEGREES_TO_RADIANS(-135);
        CGFloat startingAngle = angle + (angleSize * i);
        CGFloat endingAngle = angle + (angleSize * (i + 1));
    
        CAShapeLayer *slice = [CAShapeLayer layer];
        UIColor *color;
        color = [colorArray objectAtIndex:i];
        slice.fillColor = color.CGColor;
    
        UIBezierPath *piePath = [UIBezierPath bezierPath];
        [piePath moveToPoint:centerOne];
        [piePath addLineToPoint:CGPointMake(centerOne.x + radius * cosf(startingAngle), centerOne.y + radius * sinf(startingAngle))];
        [piePath addArcWithCenter:centerOne radius:radius startAngle:startingAngle endAngle:endingAngle clockwise:YES];
    
        [piePath closePath];
        slice.path = piePath.CGPath;
        [[self.container layer] addSublayer:slice];
    }
    
    // 7
    container.userInteractionEnabled = NO;
    [self addSubview:container];
    // 8
    sectors = [NSMutableArray arrayWithCapacity:numberOfSections];
    if (numberOfSections % 2 == 0) {
        [self buildSectorsEven];
    } else {
        [self buildSectorsOdd];
    }
    [self.delegate wheelDidChangeValue:[NSString stringWithFormat:@"%i", self.currentSector]];
    
}


- (void) rotate {
    CGAffineTransform t = CGAffineTransformRotate(container.transform, -0.78);
    container.transform = t;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    float dist = [self calculateDistanceFromCenter:touchPoint];
    if (dist < 10 || dist > 150) {
        NSLog(@"ignoring tap (%f,%f)", touchPoint.x, touchPoint.y);
        return NO;
        }
    float dx = touchPoint.x - container.center.x;
    float dy = touchPoint.y - container.center.y;
    deltaAngle = atan2(dy, dx);
    startTransform = container.transform;
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    NSLog(@"rad is %f", radians);
    CGPoint pt = [touch locationInView:self];
    float dx = pt.x - container.center.x;
    float dy = pt.y - container.center.y;
    float ang = atan2(dy, dx);
    float angleDifference = deltaAngle - ang;
    container.transform = CGAffineTransformRotate(startTransform, -angleDifference);
    return YES;
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    //1 - get current container rotation in radians
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    //2 - initialize new value
    CGFloat newVal = 0.0;
    //3 - iterate through all sectors
    for (SMSector *s in sectors) {
        //4 - check for anomly (occurs wit heven number of sectors)
        if (s.minValue > 0 && s.maxValue < 0) {
            if (s.maxValue > radians || s.minValue < radians) {
                //5 - find the quadrant (positive or negative)
                if (radians > 0) {
                    newVal = radians - M_PI;
                } else {
                    newVal = M_PI + radians;
                }
                currentSector = s.sector;
            }
        }
        //6 - all non-anomalous cases
        else if (radians > s.minValue && radians < s.maxValue) {
            newVal = radians - s.midValue;
            currentSector = s.sector;
        }
    }
    //7 - set up animation for final rotation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform t = CGAffineTransformRotate(container.transform, -newVal);
    container.transform = t;
    [UIView commitAnimations];
    
    [self.delegate wheelDidChangeValue:[NSString stringWithFormat:@"%i", self.currentSector]];
    //[self.delegate wheelDidChangeValue:[(int),self.currentSector]];
    

    
    
    
    
}
- (float) calculateDistanceFromCenter:(CGPoint)point {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float dx = point.x - center.x;
    float dy = point.y - center.y;
    return sqrt(dx*dx + dy*dy);
}
- (void) buildSectorsOdd {
    // 1 - define sector length
    CGFloat fanWidth = M_PI*2/numberOfSections;
    // 2 - set initial midpoint
    CGFloat mid = 0;
    // 3 - iterate through all sectors
    for (int i = 0; i < numberOfSections; i++) {
        SMSector *sector = [[SMSector alloc] init];
        // 4 - set sector values
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.sector = i;
        mid -= fanWidth;
        if (sector.minValue < - M_PI) {
            mid = -mid;
            mid -= fanWidth;
        }
        // 5 - add sector to array
        [sectors addObject:sector];
        NSLog(@"cl is %@", sector);
    }
}
- (void) buildSectorsEven {
    //1 - define sector length
    CGFloat fanWidth = M_PI*2/numberOfSections;
    //2 - set inital midpoint
    CGFloat mid = 0;
    //3 - iterate through all sectors
    for (int i = 0; i < numberOfSections; i++) {
        SMSector *sector = [[SMSector alloc] init];
        //4 - set sector values
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.sector = i;
        if (sector.maxValue-fanWidth < - M_PI) {
            mid = M_PI;
            sector.midValue = mid;
            sector.minValue = fabsf(sector.maxValue);
        }
        mid -= fanWidth;
        NSLog(@"cl is %@", sector);
        //5 - add sector to array
        [sectors addObject:sector];
    }
    
}

@end
