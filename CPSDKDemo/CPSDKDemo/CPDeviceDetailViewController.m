//
//  CPDeviceDetailViewController.m
//  CircusSDKDemo
//
//  Created by 二哥 on 2018/2/9.
//  Copyright © 2018年 ydld. All rights reserved.
//

#import "CPDeviceDetailViewController.h"
#import <CircusSDK/CPSDK.h>


@interface CPDeviceDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CPSDKDelegate>

@property(nonatomic,strong) NSArray *data;
@property(nonatomic,strong) CPSDK *circus;
@property(nonatomic,assign) int totalPrize;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) int timeout;

@end

@implementation CPDeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推币机房间";
    self.data = [[NSMutableArray alloc] init];
    self.consumeTableview.tableFooterView = [UIView new];
    
    self.circus = [CPSDK sharedCPSDK];
    [self.circus joinRoom];
    self.circus.delegate = self;
    [self getUserWallet];
    // 获取消费档位列表
    [self.circus getConsumeListWithDeviceId:self.deviceId success:^(NSArray<CPConsume *> * _Nullable consumeList) {
        
        self.data = consumeList;
        [self.consumeTableview reloadData];
    }];
    
}


/**
    获取用户 币数
*/
-(void)getUserWallet{
    
    [self.circus getUserWalletSuccess:^(NSDictionary * _Nullable responseObject) {
        
        NSString *coin = [responseObject objectForKey:@"coin"];
        self.userWalletLabel.text = [NSString stringWithFormat:@"我的币数：%@",coin];
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.circus leaveRoom];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CPConsume *consume = self.data[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%zd币%d次",consume.price,consume.coins];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CPConsume *consume = self.data[indexPath.row];
    
    [[CPSDK sharedCPSDK] playGameWithConsumeId:consume.id.intValue deviceId:self.deviceId  success:^(NSDictionary * _Nullable responseObject) {
        
        self.xiaofeiLabel.text = [NSString stringWithFormat:@"消费：%zd",consume.coins];
        // 刷新用户币数
        [self getUserWallet];
        self.totalPrize = 0;
        self.prizeLabel.text = @"掉落：0";
        self.totalPrizdLabel.text = @"总掉落：0";
        self.bonusLabel.text = @"奖励：0";
    }];
    
}

/**
    给用户加币
 */
- (IBAction)chargeButtonClicked:(UIButton *)sender {
    
    // 加币数 就是  button  的 tag 值
    [self.circus addcoinWithcoinNum:(int)sender.tag deviceId:self.deviceId success:^(NSDictionary * _Nullable responseObject) {
       
        // 刷新用户币数
        [self getUserWallet];
    }];
    
}

/**
    雨刷
 */
- (IBAction)wipeButtonClicked:(UIButton *)sender {
    
    [self.circus wipeWithDeviceId:self.deviceId success:^(NSDictionary * _Nullable responseObject) {
        
        
        
    }];
    
}


/**
 *  websocket 接受到消息的回调
 *
 *  @param message   接受到的消息
 */
-(void)CPwebSocketdidReceiveMessage:(CPMessage *)message {
    
    //  30s 内收不到游戏消息，则手动退出游戏，释放该机器
    self.timeout = 30;
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    }
    
    if ([message.type isEqualToString:@"gameStart"]){          // 开始游戏
        
    }else if ([message.type isEqualToString:@"gameEnd"]){            // 游戏结束
        
        
    }else if ([message.type isEqualToString:@"addPoint"]){            // 中奖了
        
        // 刷新用户钱包
        [self getUserWallet];
        // 总掉落
        self.totalPrize += message.points.intValue;
        // 掉落 +
        self.prizeLabel.text = [NSString stringWithFormat:@"掉落：%@",message.points];
        self.totalPrizdLabel.text = [NSString stringWithFormat:@"总掉落：%d",self.totalPrize];
        
    }else if ([message.type isEqualToString:@"bonuses"]) {
        // 奖励
        self.bonusLabel.text = [NSString stringWithFormat:@"奖励：%@",message.bonuses];
    }
    
}

/**
 *  websocket 连接成功的回调
 *
 */
- (void)CPwebSocketdidOpen {
    
    NSLog(@"%s", __func__);
}

/**
 *  websocket 连接失败的回调
 *
 *  @param error   错误信息
 */
- (void)CPwebSocketDidFailWithError:(NSError * _Nullable)error {
    
    
}

-(void)timerFired:(NSTimer *)timer{
    
    self.timeoutLabel.text = [NSString stringWithFormat:@"超时：%zd",self.timeout];
    self.timeout --;
    if (self.timeout < 0) {
        
        [self.circus endGameWithDeviceId:self.deviceId success:^(NSDictionary * _Nullable responseObject) {
            [timer invalidate];
        }];
        
    }
    
}

/*!
 *  把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) return nil;
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}





@end
