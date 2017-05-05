//
//  LIvingViewController.h
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/13.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//


#import "BaseViewController.h"
#import "HomeModel.h"

@interface LIvingViewController : BaseViewController

@property(nonatomic,copy)NSString *isPushPOM;
@property(nonatomic,copy)NSString *uesr_id;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *ql_push_flow;
@property(nonatomic,copy)NSString *playAddress;
@property(nonatomic,copy)NSString *onlineNum;
@property(nonatomic,copy)NSString *topic;
@property(nonatomic,copy)NSString *ret;
@property(nonatomic,copy)NSString *followl;
@property(nonatomic,copy)NSString *guanz_id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *headUrl;

// 直播数据模型
@property (nonatomic, strong) HomeLiveModel *liveModel;

@end
