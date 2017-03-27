//
//  LiveModel.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/12.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "LiveModel.h"

@implementation LiveModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self =[super init])
    {
        _name =dictionary[@"name"];
        _image =dictionary[@"image"];
        _headUrl =dictionary[@"headUrl"];
        _nickName =dictionary[@"nickName"];
        _onlineNum =dictionary[@"onlineNum"];
        _isPushPOM =dictionary[@"isPushPOM"];
        _ql_push_flow =dictionary[@"ql_push_flow"];
        _playAddress =dictionary[@"playAddress"];
        _tytypeId =dictionary[@"tytypeId"];
        _ID =dictionary[@"id"];
        _user_id =dictionary[@"user_id"];
        _stream =dictionary[@"stream"];
    }
    return self;
}

@end
@implementation BannerImageModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self =[super init])
    {
        _mobileset =dictionary[@"mobileset"];
        _chart =dictionary[@"chart"];
        _uil =dictionary[@"uil"];
        _carousel_name =dictionary[@"carousel_name"];
    }
    return self;
}

@end
@implementation TypeModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self =[super init])
    {
        _typeName =dictionary[@"typeName"];
        _typeLevel =dictionary[@"typeLevel"];
        _typeID =dictionary[@"id"];
    }
    
    return self;
}

@end
