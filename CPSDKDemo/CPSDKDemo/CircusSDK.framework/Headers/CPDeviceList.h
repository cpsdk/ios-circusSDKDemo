//
//  CPDeviceList.h
//  CircusSDK
//
//  Created by 二哥 on 2018/2/27.
//  Copyright © 2018年 ydld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPDevice.h"

@interface CPDeviceList : NSObject


/**
    总设备数
 */
@property(nonatomic,assign) int total;
/**
    当前页数
 */
@property(nonatomic,assign) int currentPage;
/**
    设备列表
 */
@property(nonatomic,strong) NSArray<CPDevice *> *devices;


@end
