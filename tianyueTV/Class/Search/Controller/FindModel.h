//
//  FindModel.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/26.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 直播间列表
 */
@interface FindModel : NSObject

// 数据数组
@property (nonatomic, strong) NSArray *dataList;

@end


@interface SearchModel : NSObject

// 直播间数组
@property (nonatomic, strong) NSArray *BroadCastUser;

@end


/**
 发现 直播间详情
 */
@interface FindLiveModel : NSObject

// 七牛直播地址
@property (nonatomic, copy) NSString *ql_push_flow;

// 头像图片
@property (nonatomic, copy) NSString *headUrl;

// 在线人数
@property (nonatomic, copy) NSString *onlineNum;

// 关注人数
@property (nonatomic, copy) NSString *focusNum;

// 分类子id
@property (nonatomic, copy) NSString *tytypeId;

// id
@property (nonatomic, copy) NSString *ID;

// 播放地址
@property (nonatomic, copy) NSString *playAddress;

// 直播间名称
@property (nonatomic, copy) NSString *name;

// 判断奥点云或七牛（0 奥点云，1 七牛）
@property (nonatomic, copy) NSString *isPushPOM;

// 房间号
@property (nonatomic, copy) NSString *stream;

// 用户id
@property (nonatomic, copy) NSString *user_id;

// 分类id
@property (nonatomic, copy) NSString *bctypeId;

// 主播名称
@property (nonatomic, copy) NSString *nickName;

// 开始时间
@property (nonatomic, copy) NSString *beginTime;

// 几小时
@property (nonatomic, copy) NSString *directseeding_time;

// 是否关注
@property (nonatomic, copy) NSString *follow;

// 实时封面
@property (nonatomic, copy) NSString *image;


@end
