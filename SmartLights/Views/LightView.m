//
//  LightView.m
//  SmartLights
//
//  Created by Xu Huanze on 10/8/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import "LightView.h"

//#define kLineWidth 2.5
@implementation LightView{
    CGFloat _lineWidth;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        _lineWidth = MIN(self.bounds.size.width, self.bounds.size.height) / 12;
    }
    return self;
}

- (CGFloat)sliderRadius {
	CGFloat radius = MIN(self.bounds.size.width/2, self.bounds.size.height/2);
	radius -= _lineWidth;
	return radius;
}

- (CGPoint)drawCircularAtPoint:(CGPoint)center withRadius:(CGFloat)radius inContext:(CGContextRef)context {
	UIGraphicsPushContext(context);
	CGContextBeginPath(context);
	
	CGFloat startAngle = 1.5 * M_PI_2;
	CGFloat endAngle = 4.5 * M_PI_2;
	CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, NO);
	
	CGPoint arcEndPoint = CGContextGetPathCurrentPoint(context);
	
	CGContextStrokePath(context);
	UIGraphicsPopContext();
	
	return arcEndPoint;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (self.light.on) {
        UIImage* onBottom = [UIImage imageNamed:@"icon_lamp_on_bottom"];
        [onBottom drawInRect:self.bounds];
        
        CGFloat radius = [self sliderRadius];
        CGPoint middlePoint;
        middlePoint.x = self.bounds.origin.x + self.bounds.size.width/2;
        middlePoint.y = self.bounds.origin.y + self.bounds.size.height/2 - radius/3;
        
        CGContextSetLineWidth(context, _lineWidth);
        
        
        [self.light.color   setStroke];
        [self drawCircularAtPoint:middlePoint withRadius:radius inContext:context];
    } else {
        UIImage* off = [UIImage imageNamed:@"icon_lamp_off"];
        [off drawInRect:self.bounds];
    }
	
}
@end
