//
//  GiftModel.h
//  presentAnimation
//
//  Created by 许博 on 16/7/15.
//  Copyright © 2016年 许博. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface GiftModel : NSObject

// 头像地址
@property (nonatomic, copy) NSString *headImageUrl;

// 头像
@property (nonatomic,strong) UIImage *headImage;

// 礼物
@property (nonatomic,strong) UIImage *giftImage;

// 送礼物者
@property (nonatomic,copy) NSString *name;

// 礼物名称
@property (nonatomic,copy) NSString *giftName;

// 礼物个数
@property (nonatomic,assign) NSInteger giftCount;

@end


