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
    if (!_group) {
        for (id<SmartLight> light  in group.lights) {
            [self addLight:light];
        }
    } else {
        if (![group.name isEqual:_group.name]) {
            NSLog(@"WARN: trying to set another group to profile which is probably a programming error");
            return;
        }

        //keep those still exist
        NSMutableOrderedSet* existingLights = [[NSMutableOrderedSet alloc] init];
        for (id<SmartLight> light in _lights) {
            if ([group.lights containsObject:light]) { //light still exists
                [existingLights addObject:light];
            }
        }
        _lights = existingLights;
        
        // add those new
        for (id<SmartLight> light in group.lights) {
            if (![_lights containsObject:light]) { //a new light added to group
                [self addLight:light];
            }
        }
    }

    _group = group;
}

-(void)addLight:(id<SmartLight>)light{
    [_lights addObject:[LightCopier copy:light]];
}

@end
