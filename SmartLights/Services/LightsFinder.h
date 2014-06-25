//
//  LightsFinder.h
//  SmartLights
//
//  Created by Xu Huanze on 9/30/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LightsFinderDelegate.h"

@protocol LightsFinder <NSObject>
@required
-(void)scanLights;
@property(nonatomic, weak) id<LightsFinderDelegate> delegate;
@end
