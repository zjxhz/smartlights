//
//  DemoGroupFinder.m
//  SmartLights
//
//  Created by Xu Huanze on 10/7/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import "DemoGroupFinder.h"
#import "DemoLightsFinder.h"
#import "Group.h"

@implementation DemoGroupFinder{
    NSMutableArray* _groups;
}
+(DemoGroupFinder*)sharedFinder{
    static dispatch_once_t onceToken;
    static DemoGroupFinder* finder = nil;
    dispatch_once(&onceToken, ^{
        finder = [[DemoGroupFinder alloc] init];
    });
    return finder;
}

-(NSArray*)findGroups{
    if (_groups) {
        return _groups;
    }
    NSArray* lights = [[DemoLightsFinder sharedFinder] findLights];
    NSMutableArray* groups = [[NSMutableArray alloc] init];
    Group* groupAll = [[Group alloc] init];
    [groupAll.lights addObjectsFromArray:lights];
    groupAll.name = @"所有灯";
    [groups addObject:groupAll];
    
    Group* livingRoom = [[Group alloc] init];
    livingRoom.name = @"客厅";
    [livingRoom.lights addObjectsFromArray:@[lights[0], lights[1], lights[2]]];
    [groups addObject:livingRoom];
    
    Group* masterBedroom = [[Group alloc] init];
    masterBedroom.name = @"主卧";
    [masterBedroom.lights addObjectsFromArray:@[lights[3], lights[4], lights[5]]];
    [groups addObject:masterBedroom];
    

    
    Group* bedroom = [[Group alloc] init];
    bedroom.name = @"次卧";
    [bedroom.lights addObjectsFromArray:@[lights[6], lights[7]]];
    [groups addObject:bedroom];
    
    Group* bookroom = [[Group alloc] init];
    bookroom.name = @"书房";
    [bookroom.lights addObjectsFromArray:@[lights[8]]];
    [groups addObject:bookroom];
    _groups = groups;
    return groups;
}
@end
