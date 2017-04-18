//
//  NearbyPeripheralInfo.h
//  JYIndoorNavigation
//
//  Created by csy on 2017/4/18.
//  Copyright © 2017年 chen_sy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface NearbyPeripheralInfo : NSObject

@property (nonatomic,strong) CBPeripheral *peripheral;
@property (nonatomic,strong) NSDictionary *advertisementData;
@property (nonatomic,strong) NSNumber *RSSI;

@end
