//
//  CPDevice.h
//  CircusSDK
//
//  Created by 二哥 on 2018/2/27.
//  Copyright © 2018年 ydld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPDevice : NSObject

/**
    设备id
 */
@property(nonatomic,copy) NSString *id;
/**
    设备状态  ， 0:空闲,1:游戏中,2:维修
 */
@property(nonatomic,assign) int state;


@end
