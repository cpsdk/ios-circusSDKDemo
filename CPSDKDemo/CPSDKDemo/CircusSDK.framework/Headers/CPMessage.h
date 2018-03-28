//
//  CPMessage.h
//  CircusSDK
//
//  Created by 二哥 on 2018/2/28.
//  Copyright © 2018年 ydld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPMessage : NSObject


/**
    消息类型，
    gameStart : 游戏开始
    gameEnd : 游戏结束
    userLogin : 通知有用户进入房间
    bonuses : 奖励推币数广播
    addPoint : 游戏掉币广播
 */
@property(nonatomic,copy) NSString *type;

/**
    用户id
 */
@property(nonatomic,copy) NSString *uid;

/**
    掉落币数，即从推币机托盘中掉落的币数，系统会将掉落的币数所对应的钱数加到用户钱包中
 */
@property(nonatomic,copy) NSString *points;

/**
    奖励币数，游戏过程中 中奖奖励的推币数
 */
@property(nonatomic,copy) NSString *bonuses;



@end
