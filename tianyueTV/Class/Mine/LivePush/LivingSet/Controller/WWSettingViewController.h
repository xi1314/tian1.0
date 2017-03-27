//
//  WWSettingViewController.h
//  tianyueTV
//
//  Created by 哈儿林林 on 16/11/28.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWSettingView.h"


@protocol roomNameDelegate <NSObject>

- (void)returnRoomName:(NSString *)roomName;

@end

@interface WWSettingViewController : UIViewController

@property (nonatomic,assign) BOOL isHiddenLivingButton;
@property (nonatomic,strong) NSDictionary *roomInfos;//房间信息
@property (nonatomic,strong) WWSettingView *settingView;
@property (nonatomic,strong) NSString *Namelevel;//一级标题

@property (nonatomic, weak) id <roomNameDelegate> delegate;

@end
