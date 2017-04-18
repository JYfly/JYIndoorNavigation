//
//  ScanBlueTooth.m
//  JYIndoorNavigation
//
//  Created by csy on 2017/4/18.
//  Copyright © 2017年 chen_sy. All rights reserved.
//

#import "ScanBlueTooth.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "NearbyPeripheralInfo.h"

@interface ScanBlueTooth() <CBCentralManagerDelegate>

@property (atomic,strong) NSMutableArray *devicesArray;
@property (nonatomic,strong) NSTimer *scanTimer;
@property (nonatomic,strong) CBCentralManager *centralManager;

@end

@implementation ScanBlueTooth

- (instancetype)init {
    self = [super init];
    if (self) {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.devicesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)startScanPeripherals {
    if (!_scanTimer) {
        _scanTimer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(scanForPeripherals) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_scanTimer forMode:NSDefaultRunLoopMode];
    }
    if (_scanTimer && !_scanTimer.valid) {
        [_scanTimer fire];
    }
}

- (void)stopScan {
    if (_scanTimer && _scanTimer.valid) {
        [_scanTimer invalidate];
        _scanTimer = nil;
    }
    [_centralManager stopScan];
}

- (void)scanForPeripherals {
    if (_centralManager.state == CBManagerStateUnsupported) {//设备不支持蓝牙
        
    }else {//设备支持蓝牙连接
        if (_centralManager.state == CBManagerStatePoweredOn) {//蓝牙开启状态
            //            [_centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:[NSNumber numberWithBool:NO]}];
            
            [_centralManager scanForPeripheralsWithServices:nil options:nil];
        }
    }
}

#pragma mark - CBCentralManager Delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBManagerStatePoweredOff:
            NSLog(@"CBCentralManagerStatePoweredOff");
            break;
        case CBManagerStatePoweredOn:
            NSLog(@"CBCentralManagerStatePoweredOn");
            break;
        case CBManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            break;
            
        default:
            break;
    }
}

//发现蓝牙设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    BOOL isExist = NO;
    NearbyPeripheralInfo *info = [[NearbyPeripheralInfo alloc] init];
    info.peripheral = peripheral;
    info.advertisementData = advertisementData;
    info.RSSI = RSSI;
    
    if (_devicesArray.count == 0) {
        [_devicesArray addObject:info];
        
    }else {
        for (int i = 0;i < _devicesArray.count;i++) {
            NearbyPeripheralInfo *originInfo = [_devicesArray objectAtIndex:i];
            CBPeripheral *per = originInfo.peripheral;
            if ([peripheral.identifier.UUIDString isEqualToString:per.identifier.UUIDString]) {
                isExist = YES;
                [_devicesArray replaceObjectAtIndex:i withObject:info];
            }
        }
        if (!isExist) {
            [_devicesArray addObject:info];
        }
    }
    
    [self.delegate updateNearByBlueTooth:_devicesArray];
}


@end
