//
//  DemoProfileFinder.h
//  SmartLights
//
//  Created by Xu Huanze on 10/7/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileFinder.h"

@interface DemoProfileFinder : NSObject<ProfileFinder>
+(DemoProfileFinder*)sharedFinder;
@end
