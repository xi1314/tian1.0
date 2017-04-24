//
//  WWSettingViewController.h
//  tianyueTV
//
//  Created by 哈儿林林 on 16/11/28.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWSettingView.h"
#import "BaseViewController.h"


@protocol roomNameDelegate <NSObject>

- (void)returnRoomName:(NSString *)roomName;

@end

@interface WWSettingViewController : BaseViewController


@property (nonatomic,assign) BOOL isHiddenLivingButton;

// 房间信息
@property (nonatomic,strong) NSDictionary *roomInfos;


@property (nonatomic,strong) WWSettingView *settingView;

// 一级标题
@property (nonatomic,strong) NSString *Namelevel;


@property (nonatomic, weak) id <roomNameDelegate> delegate;

@end
