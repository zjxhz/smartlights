//
//  DemoProfileFinder.m
//  SmartLights
//
//  Created by Xu Huanze on 10/7/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import "DemoProfileFinder.h"
#import "DemoGroupFinder.h"
#import "Group.h"
#import "Profile.h"
#import "SmartLight.h"

@implementation DemoProfileFinder{
    NSMutableArray* _profiles;
}
+(DemoProfileFinder*)sharedFinder{
    static dispatch_once_t onceToken;
    static DemoProfileFinder* finder = nil;
    dispatch_once(&onceToken, ^{
        finder = [[DemoProfileFinder alloc] init];
    });
    return finder;
}

-(NSArray*)findProfiles{
    if (_profiles) {
        return _profiles;
    }
    _profiles = [[NSMutableArray alloc] init];
    NSArray* groups = [[DemoGroupFinder sharedFinder] findGroups];
    
    Profile* p0 = [[Profile alloc] init];
    p0.group = groups[1];
    p0.name = @"明亮";
    
    Profile* p1 = [[Profile alloc] init];
    p1.group = groups[1];
    p1.name = @"清凉";
    
    Profile* p2 = [[Profile alloc] init];
    p2.group = groups[2];
    for (id<SmartLight> light in p2.lights) {
        light.color = [UIColor orangeColor];
    }
    p2.name = @"温暖";
    
    [_profiles addObjectsFromArray:@[p0,p1,p2] ];
    
    return _profiles;
}

-(void)addProfile:(Profile*)profile{
    if (!_profiles) {
        _profiles = [[NSMutableArray alloc] init];
    }
    [_profiles addObject:profile];
    [[NSNotificationCenter defaultCenter] postNotificationName:PROFILE_ADDED_NOTIFICATION object:profile];
    
}
@end
