//
//  LivingLandscapeGiftView.h
//  tianyueTV
//
//  Created by Mac-chen on 2017/5/8.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

static float GiftViewWidth = 320;
static float GiftViewHeight = 150;
typedef void(^GiftViewBlock)(NSInteger tag);

@interface LivingLandscapeGiftView : UIView

@property (nonatomic, copy) GiftViewBlock block;

// 加载xib
+ (instancetype)shareGiftViewInstancetype;

@end
