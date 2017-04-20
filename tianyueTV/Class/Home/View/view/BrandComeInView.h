//
//  BrandComeInView.h
//  tianyueTV
//
//  Created by Mac-chen on 2017/4/17.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandView.h"

typedef void(^BrandBlock)(BOOL flag);

@interface BrandComeInView : UIView

// 下拉按钮点击事件
@property (nonatomic, copy) BrandBlock block;


/**
 刷新品牌图标

 @param brandArr 网络请求数据
 */
- (void)configBrandViewWithArr:(NSArray *)brandArr;

@end
