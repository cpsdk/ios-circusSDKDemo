//
//  CPDeviceListCollectionViewController.m
//  CircusSDKDemo
//
//  Created by 二哥 on 2018/2/9.
//  Copyright © 2018年 ydld. All rights reserved.
//

#import "CPDeviceListCollectionViewController.h"
#import <CircusSDK/CPSDK.h>
#import "CPDeviceListCollectionViewCell.h"
#import "CPDeviceDetailViewController.h"

@interface CPDeviceListCollectionViewController ()

@property(nonatomic,strong) NSMutableArray *data;

@end

@implementation CPDeviceListCollectionViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data = [[NSMutableArray alloc] init];
    
    [self.collectionView registerNib:[UINib nibWithNibName:CPDeviceListCollectionViewCellReusedId bundle:nil] forCellWithReuseIdentifier:CPDeviceListCollectionViewCellReusedId];
    
    [[CPSDK sharedCPSDK] getDeviceListWithRoomType:0 currentPage:0 countPerPage:0 success:^(CPDeviceList * _Nullable deviceList) {
        NSLog(@"%zd", deviceList.total);
        NSLog(@"%zd", deviceList.currentPage);
       
        self.data = deviceList.devices;
        [self.collectionView reloadData];
    }];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.data.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CPDevice *device = self.data[indexPath.item];
    CPDeviceListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CPDeviceListCollectionViewCellReusedId forIndexPath:indexPath];
    cell.nameLabel.text = [NSString stringWithFormat:@"设备id：%@", device.id];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(collectionView.bounds.size.width / 2 - 15, collectionView.bounds.size.width / 2 - 15);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
    
}


#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CPDevice *device = self.data[indexPath.item];
    CPDeviceDetailViewController *deviceDetailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CPDeviceDetailViewController"];
    deviceDetailVC.deviceId = device.id.intValue;
    [self.navigationController pushViewController:deviceDetailVC animated:YES];
    
}

@end
