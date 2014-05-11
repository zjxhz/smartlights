//
//  GroupFinder.h
//  SmartLights
//
//  Created by Xu Huanze on 10/7/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GROUP_CHANGED_NOTIFICATION @"GROUP_CHANGED_NOTIFICATION"
@protocol GroupFinder <NSObject>
-(NSArray*)findGroups;
@end
