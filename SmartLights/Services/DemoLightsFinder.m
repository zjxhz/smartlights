//
//  DemoLightsFinder.m
//  SmartLights
//
//  Created by Xu Huanze on 9/30/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import "DemoLightsFinder.h"
#import "Light.h"
#include <stdlib.h>

@implementation DemoLightsFinder{
    NSArray* _lights;
}

+(DemoLightsFinder*)sharedFinder{
    static dispatch_once_t onceToken;
    static DemoLightsFinder* finder = nil;
    dispatch_once(&onceToken, ^{
        finder = [[DemoLightsFinder alloc] init];
    });
    return finder;
}

-(void)scanLights{
//    if (_lights) {
//        return _lights;
//    }
    int num = 9;//arc4random() % 9 + 3;
    NSMutableArray* lights = [[NSMutableArray alloc] init];
    for(int i = 0; i < num; ++i){
        Light* l = [[Light alloc] init];
        if (i < 10) {
            l.name = [NSString stringWithFormat:@"00%d", i+1];
        } else {
            l.name = [NSString stringWithFormat:@"0%d", i+1];
        }

        l.on = arc4random() % 2;
        l.brightness = arc4random() % 101;
//        CGFloat red = (arc4random() % 255) / 255.0;
//        CGFloat green = (arc4random() % 255) / 255.0;
//        CGFloat blue = (arc4random() % 255) / 255.0;
        l.color = [self randomColor];
        [lights addObject:l];
    }
    _lights = lights;
//    return lights;
}

-(UIColor*)randomColor{
    int r = arc4random() % 5;
    switch (r) {
        case 0:
            return [UIColor redColor];
        case 1:
            return [UIColor yellowColor];
        case 2:
            return [UIColor purpleColor];
        case 3:
            return [UIColor greenColor];
        case 4:
            return [UIColor blueColor];
        default:
            return [UIColor whiteColor];
    }
}

@end
