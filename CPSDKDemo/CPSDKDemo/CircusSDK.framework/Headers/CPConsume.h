//
//  CPConsume.h
//  CircusSDK
//
//  Created by 二哥 on 2018/2/27.
//  Copyright © 2018年 ydld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPConsume : NSObject

/**
    消费档位id
 */
@property(nonatomic,copy) NSString *id;
/**
    售价，单位：分
 */
@property(nonatomic,assign) int price;
/**
    推币次数
 */
@property(nonatomic,assign) int coins;


@end
