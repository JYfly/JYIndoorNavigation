//
//  ScanBlueTooth.h
//  JYIndoorNavigation
//
//  Created by csy on 2017/4/18.
//  Copyright © 2017年 chen_sy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ScanBlueToothDelegate <NSObject>

@required
- (void)updateNearByBlueTooth:(NSMutableArray *)blueToothArray;

@end

@interface ScanBlueTooth : NSObject

@property (nonatomic, weak) id <ScanBlueToothDelegate> delegate;

@end
