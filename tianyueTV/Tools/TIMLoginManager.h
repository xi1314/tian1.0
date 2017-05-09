//
//  TIMLoginManager.h
//  tianyueTV
//
//  Created by Mac-chen on 2017/5/9.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TIMLoginManagerBlock)(BOOL successed);

@interface TIMLoginManager : NSObject

@property (nonatomic, assign) BOOL success;

+ (instancetype)shareManager;

- (void)timSdkLogin:(TIMLoginManagerBlock)block;

@end
