//
//  Profile.m
//  SmartLights
//
//  Created by Xu Huanze on 10/7/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import "Profile.h"
#import "LightCopier.h"

@implementation Profile

-(id)init{
    if (self = [super init]) {
        _lights = [[NSMutableOrderedSet alloc] init];
    }
    return self;
}

-(void)setGroup:(id<LightGroup>)group{
    _group = group;
    [_lights removeAllObjects];
    for (id<SmartLight> light  in group.lights) {
        [_lights addObject:[LightCopier copy:light]];
    }
}

@end
