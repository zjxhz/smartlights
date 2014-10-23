//
//  DeviceManager.m
//  SmartLights
//
//  Created by Xu Huanze on 6/30/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "DeviceManager.h"

@implementation DeviceManager
+(DeviceManager*)sharedInstance{
    static dispatch_once_t onceToken;
    static DeviceManager* dm = nil;
    dispatch_once(&onceToken, ^{
        dm = [[DeviceManager alloc] init];
    });
    return dm;
}

-(id)init{
    self = [super init];
    CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
	self.centralManager = centralManager;
    self.peripherals = [NSMutableArray array];
    return self;
}


-(void)scanWithTimeout:(NSTimeInterval)seconds{
    NSArray *services = @[[CBUUID UUIDWithString:SERVICE_UUID]];
	[self.centralManager scanForPeripheralsWithServices:services options:nil];
    _scanTimer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(stopScan) userInfo:nil repeats:NO];
}

-(void)stopScan{
    [_centralManager stopScan];
    [_scanTimer invalidate];
    [_delegate didFindPeripherals:_peripherals];
}

-(void)connectPeripheral:(CBPeripheral*)peripheral{
    if (_connectingPeripheral) {
        NSLog(@"Canceling connecting to %@", peripheral.name);
        [_centralManager cancelPeripheralConnection:_connectingPeripheral];
        if (_connectingPeripheral == peripheral) {
            NSLog(@"Reconnecting when disconnected later...");
            _reconnecting = YES;
            return;
        }
    }
    if (peripheral.isConnected) {
        if ([self hasRightService:peripheral]) {
            [self.delegate didConnectToPeripheral:peripheral];
        } else {
            [_centralManager cancelPeripheralConnection:peripheral];
            _reconnecting = true;
            return;
        }
    } else {
        [_centralManager connectPeripheral:peripheral options:nil];//TODO check what options are there
        _connectingPeripheral = peripheral;
    }
}

-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data {
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        NSLog(@"Could not find service with UUID %@ on peripheral %@", su.UUIDString, p.name);
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", cu.UUIDString, su.UUIDString, p.name);
        return;
    }
    [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}

-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p {
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
    }
    return nil; //Service not found on this peripheral
}

-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service {
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil; //Characteristic not found on this service
}

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2 {
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
}

-(UInt16) swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}

-(BOOL)hasRightService:(CBPeripheral*)peripheral{
    for (CBService* service in peripheral.services) {
        NSLog(@"service: %@", [service.UUID UUIDString]);
        if ([[service.UUID UUIDString] isEqual:SERVICE_UUID]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - CBCentralManagerDelegate
// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"Connected to %@, discovering services...", peripheral.name);
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    _connectingPeripheral = nil;
    NSLog(@"Failed to connect to %@ with error: %@", peripheral.name, error);
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"didDiscoverPeripheral");
    if(![_peripherals containsObject:peripheral]){
        [_peripherals addObject:peripheral];
        peripheral.delegate = self;
    }
//    [_peripherals addObject:peripheral];
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    _connectingPeripheral = nil;
    if (error) {
        if (_connectingPeripheral) {
            _connectingPeripheral = nil;
            _reconnecting = NO;
        }
        NSLog(@"failed to disconnect %@ with error: %@", peripheral.name, error);
        [_delegate didFailedToConnectToPeripheral:peripheral withError:error];
        NSLog(@"Reconnecting after unexpected disconnect");
        [self connectPeripheral:peripheral];
        return;
    }

    if (_reconnecting) {
        _reconnecting = NO;
        [self connectPeripheral:peripheral];
    }
}

// method called whenever the device state changes.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    // Determine the state of the peripheral
    if ([central state] == CBCentralManagerStatePoweredOff) {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
    }
    else if ([central state] == CBCentralManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
    }
    else if ([central state] == CBCentralManagerStateUnauthorized) {
        NSLog(@"CoreBluetooth BLE state is unauthorized");
    }
    else if ([central state] == CBCentralManagerStateUnknown) {
        NSLog(@"CoreBluetooth BLE state is unknown");
    }
    else if ([central state] == CBCentralManagerStateUnsupported) {
        NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
    }
}

#pragma mark - CBPeripheralDelegate

// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@"DID DISCOVER SERVICES...");
    if (error) {
        NSLog(@"DISCOVER SERVICE FAILED WITH ERROR: %@", error);
    } else {
        if (_connectingPeripheral && [self hasRightService:peripheral]) { //delegate didConnectToPeripheral should be called only once
            [self discoverCharacteristics:peripheral];
            _connectingPeripheral = nil;
            if ([_delegate respondsToSelector:@selector(didConnectToPeripheral:)]) {
                [_delegate didConnectToPeripheral:peripheral];
            }
        }
    }
}

//获取所有服务的特征值
-(void) discoverCharacteristics:(CBPeripheral *)p{
    for (CBService* service in p.services) {
        if ([[service.UUID UUIDString] isEqual:SERVICE_UUID]) {
            NSLog(@"DISCOVERING CHARACTERISTICS FOR SERVICE: %@", [service.UUID UUIDString]);
            [p discoverCharacteristics:nil forService:service];
        }
    }
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error) {
        NSLog(@"CHARACTERISTICS discovering failed with error: %@", error);
    } else {
        NSLog(@"CHARACTERISTICS discovered for service %@", service.UUID.UUIDString);
    }

}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
}

@end
