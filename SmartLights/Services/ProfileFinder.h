//
//  ProfileFinder.h
//  SmartLights
//
//  Created by Xu Huanze on 10/7/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"

#define PROFILE_ADDED_NOTIFICATION @"PROFILE_ADDED_NOTIFICATION"
@protocol ProfileFinder <NSObject>
-(NSArray*)findProfiles;
-(void)addProfile:(Profile*)profile;
@end
