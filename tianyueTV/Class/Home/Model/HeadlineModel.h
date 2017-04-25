//
//  HeadlineModel.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/25.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 匠人头条
 */
@interface HeadlineModel : NSObject

// 新闻列表
@property (nonatomic, strong) NSArray *newsList;

@end


/**
 头条内容
 */
@interface HeadNewsModel : NSObject

// 新闻id
@property (nonatomic, copy) NSString *ID;

//
@property (nonatomic, copy) NSString *bhot;

// 新闻来源
@property (nonatomic, copy) NSString *newsFrom;

// 时间
@property (nonatomic, copy) NSString *newsTime;

// 时间（string）
@property (nonatomic, copy) NSString *time_new;

// 作者
@property (nonatomic, copy) NSString *author;

// 点赞数
@property (nonatomic, copy) NSString *praiseNum;

//
@property (nonatomic, copy) NSString *shortImage;

// 标题
@property (nonatomic, copy) NSString *title;

// 新闻数量
@property (nonatomic, copy) NSString *newsCount;

// 封面图片
@property (nonatomic, copy) NSString *faceImage;

// 新闻类型
@property (nonatomic, copy) NSString *newsType;

// 新闻简介
@property (nonatomic, copy) NSString *newsDesc;

// 新闻内容
@property (nonatomic, copy) NSString *content;


@end
