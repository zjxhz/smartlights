//
//  LightsFinderDelegate.h
//  SmartLights
//
//  Created by Xu Huanze on 6/24/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LightsFinderDelegate <NSObject>
-(void)didFindLights:(NSArray*)lights;

@end
