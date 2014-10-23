//
//  SmartLight.h
//  SmartLights
//
//  Created by Xu Huanze on 9/30/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;

@protocol SmartLight <NSObject>
@required
@property(nonatomic, strong) NSString* name;
@property(nonatomic) BOOL on;
@property(nonatomic, strong) UIColor* color;
@property(nonatomic) CGFloat brightness;
@property(nonatomic, strong) CBPeripheral* peripheral; 
@end
