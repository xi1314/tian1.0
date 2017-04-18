//
//  AnchorSpaceModel.h
//  tianyueTV
//
//  Created by Mac-chen on 2017/4/18.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnchorSpaceModel : NSObject

@property (nonatomic, strong) NSArray *broadcast;

@end


@interface BroadCastModel : NSObject

@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *bctypeId;
@property (nonatomic, copy) NSString *bctypeName;
@property (nonatomic, copy) NSString *blive;
@property (nonatomic, copy) NSString *focusNum;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *isPushPOM;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *onlineNum;
@property (nonatomic, copy) NSString *playAddress;
@property (nonatomic, copy) NSString *publishAddress;
@property (nonatomic, copy) NSString *ql_playAddress;
@property (nonatomic, copy) NSString *ql_push_flow;
@property (nonatomic, copy) NSString *stream;
@property (nonatomic, copy) NSString *typeRecommend;
@property (nonatomic, copy) NSString *tytypeId;
@property (nonatomic, copy) NSString *tytypeName;
@property (nonatomic, copy) NSString *uid;

@end
