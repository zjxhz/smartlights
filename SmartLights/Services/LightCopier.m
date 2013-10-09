//
//  LightCopier.m
//  SmartLights
//
//  Created by Xu Huanze on 10/8/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import "LightCopier.h"


@implementation LightCopier
+(Light*)copy:(Light*)light{
    Light* copy = [[Light alloc] init];
    copy.name = light.name;
    copy.on = light.on;
    copy.brightness = light.brightness;
    copy.color = light.color;
    return copy;
}
@end
