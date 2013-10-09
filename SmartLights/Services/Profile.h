//
//  Profile.h
//  SmartLights
//
//  Created by Xu Huanze on 10/7/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LightGroup.h"

@interface Profile : NSObject
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) id<LightGroup> group;
@property(nonatomic, strong) NSMutableOrderedSet* lights;
@end
