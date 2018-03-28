//
//  YDMainCollectionViewCell.h
//  OpenLive
//
//  Created by 二哥 on 2017/11/22.
//  Copyright © 2017年 YunDianLianDong. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class CPDeviceListModel;

static NSString *CPDeviceListCollectionViewCellReusedId = @"CPDeviceListCollectionViewCell";

@interface CPDeviceListCollectionViewCell : UICollectionViewCell


//@property(nonatomic,strong) CPDeviceListModel *deviceListModel;


/*
    机器图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;


/*
    状态
 */
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

/*
    机器名称
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;






@end
