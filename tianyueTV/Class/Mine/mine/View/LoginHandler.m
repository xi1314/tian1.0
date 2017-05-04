//
//  LoginHandler.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/5/4.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "LoginHandler.h"


@implementation LoginHandler

/**
 登录
 
 @param phone 用户名
 @param pwd   密码
 @param completeBlock 返回值
 */
+ (void)requestForLoginWithPhone:(NSString *)phone
                             pwd:(NSString *)pwd
                   completeBlock:(HandlerBlock)completeBlock
{
    
    NSDictionary *dic = @{@"userName" : phone,
                          @"password" : pwd};
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_mobileLogin paraments:dic finish:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"status"] isEqualToString:SUCCESS]) {
            
            // userSig用于初始化腾讯sdk
            [USER_Defaults setObject:responseObject[@"user"][@"userSig"] forKey:@"userSig"];
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"user"][@"id"] forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"user"][@"nickName"] forKey:@"nickName"];
            if (responseObject[@"user"][@"bCard"] != [NSNull null]) {
                [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"user"][@"bCard"] forKey:@"bCard"];
            }
            
            // 判断是否有直播间
            if (responseObject[@"user"][@"baudit"] != [NSNull null]) {
                [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"user"][@"baudit"] forKey:@"baudit"];
            }
            if ([responseObject[@"user"][@"userName"] isKindOfClass:[NSString class]]) {
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"user"][@"userName"] forKey:@"account" ];
            }
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSDictionary *dicUser = responseObject[@"user"];
            LoginModel *userModel = [LoginModel mj_objectWithKeyValues:dicUser];
            
            completeBlock(userModel, nil);
            
        } else {
            completeBlock(nil, error);
        }
        
    }];
    
    /*
    NSMutableDictionary *paraments = [[NSMutableDictionary alloc]init];
    paraments[@"userName"] = self.phoneTextField.text;
    paraments[@"password"] = self.passwordTextField.text;
    
    @weakify(self);
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"mobileLogin" paraments:paraments finish:^(id responseObject, NSError *error) {
        
        @strongify(self);
        
        NSLog(@" 登录----%@----%@",responseObject,error);
        if ([responseObject[@"status"] isEqualToString:@"success"])
        {
            // userSig用于初始化腾讯sdk
            [USER_Defaults setObject:responseObject[@"user"][@"userSig"] forKey:@"userSig"];
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"user"][@"id"] forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"user"][@"nickName"] forKey:@"nickName"];
            if (responseObject[@"user"][@"bCard"] != [NSNull null]) {
                [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"user"][@"bCard"] forKey:@"bCard"];
            }
            
            // 判断是否有直播间
            if (responseObject[@"user"][@"baudit"] != [NSNull null]) {
                [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"user"][@"baudit"] forKey:@"baudit"];
            }
            if ([responseObject[@"user"][@"userName"] isKindOfClass:[NSString class]]) {
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"user"][@"userName"] forKey:@"account" ];
            }
            
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self saveUserAccountInfo];
            [self getAndSaveCookie];
            
            [self goToMain];
        }else
        {
            [MBProgressHUD showError:@"账号或密码错误"];
        }
    }];
     */
}

@end
