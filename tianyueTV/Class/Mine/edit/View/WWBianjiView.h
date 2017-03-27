//
//  WWBianjiView.h
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/20.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWBianjiView : UIView
@property (nonatomic,copy) void (^BackButtonHandler)();
@property (nonatomic,copy) void (^ChoiceHeadImageHandler)();
@property (nonatomic,strong) UIImageView *headImages;
@property (nonatomic,strong) UIImageView *bigHeadView;
@end
