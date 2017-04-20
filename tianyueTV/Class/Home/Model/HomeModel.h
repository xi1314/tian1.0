//
//  HomeModel.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/20.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject

// 首页匠作间
@property (nonatomic, strong) NSArray *dataList;

@end


@interface HomeLiveModel : NSObject

// 房间号
@property (nonatomic, copy) NSString *stream;

// 奥点云直播地址
@property (nonatomic, copy) NSString *playAddress;

// 用户名
@property (nonatomic, copy) NSString *nickName;

// 直播间名称
@property (nonatomic, copy) NSString *name;

// 头像
@property (nonatomic, copy) NSString *headUrl;

// id
@property (nonatomic, copy) NSString *ID;

// 在线人数
@property (nonatomic, copy) NSString *onlineNum;

// 判断七牛或奥点云
@property (nonatomic, copy) NSString *isPushPOM;

// 用户id
@property (nonatomic, copy) NSString *user_id;

// 当前直播地址
@property (nonatomic, copy) NSString *ql_push_flow;

// 主播对应视频
@property (nonatomic, copy) NSString *url_video;

// 封面图片
@property (nonatomic, copy) NSString *img_cover;

@end
