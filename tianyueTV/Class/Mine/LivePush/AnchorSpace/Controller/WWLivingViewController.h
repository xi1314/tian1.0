//
//  WWLivingViewController.h
//  tianyueTV
//
//  Created by 哈儿林林 on 16/11/16.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>  
#import <ImSDK/ImSDK.h>

typedef NS_ENUM(NSInteger, AVIMCommand) {
    AVIMCMD_None                 = 0, // 无事件
    
    AVIMCMD_Custom_Text          = 1, //文本消息
    AVIMCMD_Custom_EnterLive     = 2, //用户加入直播
    AVIMCMD_Custom_ExitLive      = 3, //用户推出直播
    AVIMCMD_Custom_Like          = 4, //点赞消息
    AVIMCMD_Custom_Danmaku       = 5, //弹幕消息
};



@interface WWLivingViewController : UIViewController

@end
