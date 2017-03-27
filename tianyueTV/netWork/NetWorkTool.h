//
//  NetWorkTool.h
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/11.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef enum :NSUInteger{
    GET,
    POST

} requestMthod;
typedef NS_ENUM(NSUInteger ,NetworkStates){
    NetworkStatusNone,
    NetworkStatus2G,
    NetworkStatus3G,
    NetworkStatus4G,
    NetworkStatusWIFI
};

typedef void(^callBackBlock)(id responseObject ,NSError* error);

@interface NetWorkTool : AFHTTPSessionManager

+(instancetype)sharedTool;
-(void)requestMethod:(requestMthod)method URL:(NSString *)url paraments:(id)paraments finish:(callBackBlock)finished;

+(NetworkStates)getNetworkStatus;
@end
