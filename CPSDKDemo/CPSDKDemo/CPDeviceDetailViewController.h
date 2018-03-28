//
//  CPDeviceDetailViewController.h
//  CircusSDKDemo
//
//  Created by 二哥 on 2018/2/9.
//  Copyright © 2018年 ydld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPDeviceDetailViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *userWalletLabel;


@property(nonatomic,assign) int deviceId;

@property (weak, nonatomic) IBOutlet UITableView *consumeTableview;

@property (weak, nonatomic) IBOutlet UILabel *prizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalPrizdLabel;

@property (weak, nonatomic) IBOutlet UILabel *xiaofeiLabel;

@property (weak, nonatomic) IBOutlet UILabel *bonusLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeoutLabel;


@end
