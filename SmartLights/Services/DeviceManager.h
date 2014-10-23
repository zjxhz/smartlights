//
//  DeviceManager.h
//  SmartLights
//
//  Created by Xu Huanze on 6/30/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;
@import QuartzCore;
#define SERVICE_UUID @"FFB0"

@protocol DeviceManagerDelegate <NSObject>
-(void)didFindPeripherals:(NSArray*)peripherals;
-(void)didConnectToPeripheral:(CBPeripheral*)peripheral;
-(void)didFailedToConnectToPeripheral:(CBPeripheral*)peripheral withError:(NSError*)error;
@end


@interface DeviceManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral     *polarH7HRMPeripheral;
@property (nonatomic, strong) NSTimer* scanTimer;
@property (nonatomic, strong) NSMutableArray* peripherals;
@property (nonatomic, weak) id<DeviceManagerDelegate> delegate;
@property (nonatomic, strong) CBPeripheral* connectingPeripheral;
@property (nonatomic) BOOL reconnecting;
-(void)scanWithTimeout:(NSTimeInterval)seconds;
+(DeviceManager*)sharedInstance;
-(void)connectPeripheral:(CBPeripheral*)peripheral;
-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data;
@end
