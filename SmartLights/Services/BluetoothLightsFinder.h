//
//  BluetoothLightsFinder.h
//  SmartLights
//
//  Created by Xu Huanze on 6/24/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LightsFinder.h"
#import "LightsFinderDelegate.h"
#import "DeviceManager.h"

@interface BluetoothLightsFinder : NSObject <LightsFinder, DeviceManagerDelegate>
+(BluetoothLightsFinder*)sharedFinder;
@property(nonatomic, weak) id<LightsFinderDelegate> delegate;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) DeviceManager* deviceManager;

@end
