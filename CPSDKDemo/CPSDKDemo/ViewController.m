//
//  ViewController.m
//  CPSDKDemo
//
//  Created by 二哥 on 2018/2/7.
//  Copyright © 2018年 ydld. All rights reserved.
//

#import "ViewController.h"
#import <CircusSDK/CPSDK.h>
#import "CPDeviceListCollectionViewController.h"
#import "AFHTTPSessionManager.h"
#import "Test.h"

@interface ViewController ()<NSURLSessionDelegate>

@property(nonatomic,assign) BOOL isBinded;

@property (weak, nonatomic) IBOutlet UITextField *uidTextField;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    
    [manager GET:@"http://billingaccount.cpo2o.com:8090/billing/statement/v2/getStatement?balance_date=2018-03-19" parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSLog(@"responseObject  ==    %@", responseObject);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
         }];
    
    Test *test = [Test new];
    test.testValue = @"testtesttesttesttesttest";
    NSLog(@"testValue  ===    %@", test.testValue);
    
}


/**
    绑定用户
 */
- (IBAction)bindButtonClicked:(UIButton *)sender {
    
    [self.uidTextField resignFirstResponder];
    
    if ([self.uidTextField.text isEqualToString:@""] || !self.uidTextField.text) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入用户id" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:cancleAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    [[CPSDK sharedCPSDK] bindingUid:self.uidTextField.text success:^(NSDictionary * _Nullable responseObject) {
        
        self.isBinded = YES;
        
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"绑定成功"]) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户绑定成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:cancleAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.destinationViewController isKindOfClass:[CPDeviceListCollectionViewController class]]) {
        
        if (!self.isBinded) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先绑定用户" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:cancleAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        
    }
    
}



@end
