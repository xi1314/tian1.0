//
//  MessageModel.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/9.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
@property (nonatomic, copy) NSString *headImageStr;   //头像地址
@property (nonatomic, copy) NSString *message;        //用户留言
@property (nonatomic, copy) NSString *standard;       //产品规格
@property (nonatomic, copy) NSString *size;           //尺寸
@property (nonatomic, copy) NSArray  *imgArr;         //评论图片arr
@property (nonatomic, strong) NSDictionary * paraDic;
@end
