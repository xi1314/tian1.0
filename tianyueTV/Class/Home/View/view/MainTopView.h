//
//  MainTopView.h
//  tianyueTV
//
//  Created by wwwwwwww on 2016/12/6.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicButton.h"
@interface MainTopView : UIView

@property(nonatomic,strong)BasicButton *recommendedBtn;//推荐
@property(nonatomic,strong)BasicButton *clothingBtn;//衣
@property(nonatomic,strong)BasicButton *foodBtn;//食
@property(nonatomic,strong)BasicButton *liveBtn;//住
@property(nonatomic,strong)BasicButton *walkingBtn;//行
@property(nonatomic,strong)BasicButton *knowledgeBtn;//知
@property(nonatomic,strong)UIImageView *orangeLine;//橘黄色线条

@end
