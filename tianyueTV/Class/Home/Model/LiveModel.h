//
//  LiveModel.h
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/12.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveModel : NSObject

//直播分类
@property(nonatomic,copy)NSString *tytypeId;
//直播间名称
@property(nonatomic,copy)NSString *name;
//背景图片(直播实时截图)
@property(nonatomic,copy)NSString *image;
//主播图像
@property(nonatomic,copy)NSString *headUrl;
//用户名
@property(nonatomic,copy)NSString *nickName;
//在线人数
@property(nonatomic,copy)NSString *onlineNum;
//判断七牛或者奥点云直播
@property(nonatomic,copy)NSString *isPushPOM;
//七牛直播地址
@property(nonatomic,copy)NSString *ql_push_flow;
//奥点云直播地址
@property(nonatomic,copy)NSString *playAddress;

@property(nonatomic,copy)NSString *ID;
//用户id
@property(nonatomic,copy)NSString *user_id;
//房间号
@property(nonatomic,copy)NSString *stream;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
@interface BannerImageModel : NSObject

//排序值
@property(nonatomic,copy)NSString *mobileset;
//图片链接
@property(nonatomic,copy)NSString *uil;
//上传的图片
@property(nonatomic,copy)NSString *chart;
//图片标题
@property(nonatomic,copy)NSString *carousel_name;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
@interface TypeModel : NSObject

@property(nonatomic,copy)NSString *typeName;
@property(nonatomic,copy)NSString *typeLevel;
@property(nonatomic,copy)NSString *typeID;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
