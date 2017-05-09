//
//  TIMLoginManager.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/5/9.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "TIMLoginManager.h"
#import <ImSDK/ImSDK.h>
#import "LoginModel.h"

@implementation TIMLoginManager


+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static TIMLoginManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[TIMLoginManager alloc] init];
        instance.success = NO;
    });
    return instance;
}


- (void)timSdkLogin:(TIMLoginManagerBlock)block
{

    //     self.userSig = @"eJxtz11PgzAUgOH-0luNaUu7MZNdwAIGbcPGdHO7aZpRluPkY1CRZfG-iwTjjbfvc05OzhU9i-WdripIlbbKqVN0jwjDGFPGOUe3g5uugtoonVlT-3gvtB8ZtTV1A2XRA8WEE*pg-IeQmsJCBsOiNY0dewPHPshgtYh8AZ5OQvEalJ86cbQ*zVi7ifAuXuRhst*SNRydaVfE55kHnt-FUbGH90Dszn4oJbw88di9LHP5lsh2a7LlzQQ-iGbzuJrPf4*lJzX8*N9zFnIzdHcyJZS5bOz6cCg-CqvspRocM0bQ1zeeuVlk";
    //     self.userIdentifiler = @"test";
    
    LoginModel *loginM = [self gainObjectFromUsersDefaults:@"loginSuccess"];
    
    NSString *userIdentify = [NSString stringWithFormat:@"ty%@", loginM.ID];
    NSString *userSig = loginM.userSig;
    
    TIMLoginParam * login_param = [[TIMLoginParam alloc] init];
    // accountType 和 sdkAppId 通讯云管理平台分配
    // identifier为用户名，userSig 为用户登录凭证
    // appidAt3rd 在私有帐号情况下，填写与sdkAppId 一样
    login_param.accountType = @"10441";
    login_param.identifier = userIdentify;
    login_param.userSig = userSig;
    login_param.appidAt3rd = @"1400024555";
    login_param.sdkAppId = 1400024555;
    
    TIMManager *manager = [TIMManager sharedInstance];
    [manager initSdk:[@"1400024555" intValue] accountType:@"10441"];

    [manager login:login_param succ:^(){
        
        [TIMLoginManager shareManager].success = YES;
        
        block(YES);
        
    } fail:^(int code, NSString * err) {
        
        [TIMLoginManager shareManager].success = NO;
        
        block(NO);
        
    }];
}

@end
