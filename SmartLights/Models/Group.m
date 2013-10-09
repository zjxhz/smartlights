//
//  Group.m
//  SmartLights
//
//  Created by Xu Huanze on 10/7/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import "Group.h"
#import "SmartLight.h"

@implementation Group
-(id)init{
    if (self == [super init]) {
        _lights = [NSMutableArray array];
    }
    return self;
}

//-(void)on:(BOOL)on{
//    [_lights makeObjectsPerformSelector:@selector(on:) withObject:on];
//}

@end
