//
//  Light.m
//  SmartLights
//
//  Created by Xu Huanze on 9/30/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import "Light.h"

@implementation Light
-(void)setBrightness:(CGFloat)brightness{
    _brightness = brightness;
    if (_brightness == 0) {
        _on = NO;
    } else {
        _on = YES;
    }
}

-(void)setOn:(BOOL)on{
    _on = on;
//    if (on) {
//        _brightness = 100.0;
//    } else {
//        _brightness = 0.0;
//    }
}

-(BOOL)isEqual:(id)object{
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    Light* other = object;
    return [self.name isEqual:other.name];
}

-(NSString*)description{
    return [NSString stringWithFormat:@"%s: %.0f", _name, _brightness];
}

@end
