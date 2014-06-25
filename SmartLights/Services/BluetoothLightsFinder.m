//
//  BluetoothLightsFinder.m
//  SmartLights
//
//  Created by Xu Huanze on 6/24/14.
//  Copyright (c) 2014 Wayne. All rights reserved.
//

#import "BluetoothLightsFinder.h"
#import "AppDelegate.h"
#import "Light.h"

@implementation BluetoothLightsFinder{
    AppDelegate     *appDelegate;
}

+(BluetoothLightsFinder*)sharedFinder{
    static dispatch_once_t onceToken;
    static BluetoothLightsFinder* finder = nil;
    dispatch_once(&onceToken, ^{
        finder = [[BluetoothLightsFinder alloc] init];
    });
    return finder;
}


-(id) init{
    self = [super init];
    appDelegate = [UIApplication sharedApplication].delegate;
    return self;
}

-(void)scanLights{
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(scanWhenPowerOn) userInfo:nil repeats:YES];
}

-(void)scanWhenPowerOn{
    if(appDelegate.bleManager.CM.state == CBCentralManagerStatePoweredOn){
        [_timer invalidate];
        [self scanPeripherals];
    }
}
-(NSArray*) findLights{
    NSMutableArray* lights = [[NSMutableArray alloc] init];
    if(appDelegate.bleManager.peripherals){
        for (CBPeripheral * p in appDelegate.bleManager.peripherals) {
            Light* l = [[Light alloc] init];
            l.name = [p.name substringFromIndex:12];
            [lights addObject:l];
        }
    }
    return lights;
}

- (void)scanPeripherals {
    [self initNotification];
    if (appDelegate.bleManager.activePeripheral)
        if(appDelegate.bleManager.activePeripheral.isConnected)
            [[appDelegate.bleManager CM] cancelPeripheralConnection:[appDelegate.bleManager activePeripheral]];

    [appDelegate.bleManager.peripherals removeAllObjects];
    [appDelegate.bleManager.activeCharacteristics removeAllObjects];
    [appDelegate.bleManager.activeDescriptors removeAllObjects];
    appDelegate.bleManager.activePeripheral = nil;
    appDelegate.bleManager.activeService = nil;
    
    [appDelegate.bleManager findBLEPeripherals:1];
    
}

- (void)stopScan{
    [appDelegate.bleManager stopScan];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc  removeObserver:self name:@"DIDCONNECTEDBLEDEVICE" object:nil];
    [nc  removeObserver:self name:@"STOPSCAN" object:nil];
    [nc  removeObserver:self name:@"BLEDEVICEWITHRSSIFOUND" object:nil];
    [nc  removeObserver:self name:@"SERVICEFOUNDOVER" object:nil];
    [nc  removeObserver:self name:@"DOWNLOADSERVICEPROCESSSTEP" object:nil];
}

-(void)initNotification
{
    //设定通知
    //发现BLE外围设备
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    //成功连接到指定外围BLE设备
//    [nc addObserver: self
//           selector: @selector(didConectedbleDevice:)
//               name: @"DIDCONNECTEDBLEDEVICE"
//             object: nil];
    
    [nc addObserver: self
           selector: @selector(stopScanBLEDevice:)
               name: @"STOPSCAN"
             object: nil];
    
    [nc addObserver: self
           selector: @selector(bleDeviceWithRSSIFound:)
               name: @"BLEDEVICEWITHRSSIFOUND"
             object: nil];
    
//    [nc addObserver: self
//           selector: @selector(ServiceFoundOver:)
//               name: @"SERVICEFOUNDOVER"
//             object: nil];
//    
//    [nc addObserver: self
//           selector: @selector(DownloadCharacteristicOver:)
//               name: @"DOWNLOADSERVICEPROCESSSTEP"
//             object: nil];
    
}


//扫描ble设备
-(void)stopScanBLEDevice:(CBPeripheral *)peripheral {
    NSLog(@" BLE外设 列表 被更新 ！\r\n");
    NSMutableArray* lights = [[NSMutableArray alloc] init];
    if(appDelegate.bleManager.peripherals){
        for (CBPeripheral * p in appDelegate.bleManager.peripherals) {
            Light* l = [[Light alloc] init];
            l.name = [p.name substringFromIndex:12];
            l.color = [UIColor redColor];
            [lights addObject:l];
        }
    }
    [self.delegate didFindLights:lights];
    [self stopScan];
}

//服务发现完成之后的回调方法
//-(void)ServiceFoundOver:(CBPeripheral *)peripheral {
//    NSLog(@" 获取所有的服务 ");
//}
//
////成功扫描所有服务特征值
//-(void)DownloadCharacteristicOver:(CBPeripheral *)peripheral {
//    NSLog(@" 获取所有的特征值 ! \r\n");
//}

-(void)bleDeviceWithRSSIFound:(NSNotification *) notification{   //此方法刷新次数过多，会导致tableview界面无法刷新的情况发生
    NSLog(@" 更新RSSI 值 ！\r\n");
}

//连接成功
//-(void)didConectedbleDevice:(CBPeripheral *)peripheral {
//    NSLog(@" BLE 设备连接成功   ！\r\n");
//    [appDelegate.bleManager.activePeripheral discoverServices:nil];
//}



@end
