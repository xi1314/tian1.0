//
//  AnimOperationManager.m
//  presentAnimation
//
//  Created by 许博 on 16/7/28.
//  Copyright © 2016年 许博. All rights reserved.
//  新增动画管理类

#import "AnimOperationManager.h"
#import "AnimOperation.h"

static float viewWidth = 220;

@interface AnimOperationManager ()
/// 队列1
@property (nonatomic,strong) NSOperationQueue *queue1;
/// 队列2
@property (nonatomic,strong) NSOperationQueue *queue2;
//队列3
@property (nonatomic,strong) NSOperationQueue *queue3;

/// 操作缓存池
@property (nonatomic,strong) NSCache *operationCache;
/// 维护用户礼物信息
@property (nonatomic,strong) NSCache *userGigtInfos;
@end


@implementation AnimOperationManager

+ (instancetype)sharedManager
{
    static AnimOperationManager *manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AnimOperationManager alloc] init];
        
    });
    return manager;
}

/// 动画操作 : 需要UserID和回调
- (void)animWithUserID:(NSString *)userID model:(GiftModel *)model finishedBlock:(void(^)(BOOL result))finishedBlock {
//    NSLog(@"i am coming!!!!!!");
    
    float giftHei = ([UIScreen mainScreen].bounds.size.height - 90)/3.0f;

    // 在有用户礼物信息时
    if ([self.userGigtInfos objectForKey:userID]) {

        // 如果有操作缓存，则直接累加，不需要重新创建op
        if ([self.operationCache objectForKey:userID]!=nil) {
            AnimOperation *op = [self.operationCache objectForKey:userID];
            op.presentView.giftCount = model.giftCount;
            [op.presentView shakeNumberLabel];
            return;
        }
        // 没有操作缓存，创建op
        AnimOperation *op = [AnimOperation animOperationWithUserID:userID model:model finishedBlock:^(BOOL result,NSInteger finishCount) {
            // 回调
            if (finishedBlock) {
                finishedBlock(result);
            }
            // 将礼物信息数量存起来
            [self.userGigtInfos setObject:@(finishCount) forKey:userID];
            // 动画完成之后,要移除动画对应的操作
            [self.operationCache removeObjectForKey:userID];
            // 延时删除用户礼物信息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.userGigtInfos removeObjectForKey:userID];
            });
            
        }];
        
        // 注意：下面两句代码是和无用户礼物信息时不同的，其余的逻辑一样
        op.presentView.animCount = [[self.userGigtInfos objectForKey:userID] integerValue];
        op.model.giftCount = op.presentView.animCount + 1;
        
        op.listView = self.parentView;
        op.index = [userID integerValue] % 2;
        
        // 将操作添加到缓存池
        [self.operationCache setObject:op forKey:userID];
        
        if ([userID integerValue] == 0) {
            
            if (op.model.giftCount != 0) {
                op.presentView.frame  = CGRectMake(-viewWidth, (giftHei - 40)/2.0f + 45, viewWidth, 40);
                op.presentView.originFrame = op.presentView.frame;
                [self.queue1 addOperation:op];
            }
            
        }else if ([userID integerValue] == 1) {
            
            if (op.model.giftCount != 0) {
                op.presentView.frame  = CGRectMake(-viewWidth, (giftHei - 40)/2.0f + 45 + giftHei, viewWidth, 40);
                op.presentView.originFrame = op.presentView.frame;
                [self.queue2 addOperation:op];
            }
            
        }else if ([userID integerValue] == 2) {
            
            if (op.model.giftCount != 0) {
                op.presentView.frame  = CGRectMake(-viewWidth, (giftHei - 40)/2.0f + 45 + giftHei*2, viewWidth, 40);
                op.presentView.originFrame = op.presentView.frame;
                [self.queue3 addOperation:op];
            }
            
        }

    }
    // 在没有用户礼物信息时
    else
    {
     
        // 如果有操作缓存，则直接累加，不需要重新创建op
        if ([self.operationCache objectForKey:userID] != nil) {
            AnimOperation *op = [self.operationCache objectForKey:userID];
            op.presentView.giftCount = model.giftCount;
            [op.presentView shakeNumberLabel];
            return;
        }
        
        AnimOperation *op = [AnimOperation animOperationWithUserID:userID model:model finishedBlock:^(BOOL result,NSInteger finishCount) {
            // 回调
            if (finishedBlock) {
                finishedBlock(result);
            }
            // 将礼物信息数量存起来
            [self.userGigtInfos setObject:@(finishCount) forKey:userID];
            // 动画完成之后,要移除动画对应的操作
            [self.operationCache removeObjectForKey:userID];
            // 延时删除用户礼物信息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.userGigtInfos removeObjectForKey:userID];
            });
            
        }];
        op.listView = self.parentView;
        op.index = [userID integerValue] % 2;
        // 将操作添加到缓存池
        [self.operationCache setObject:op forKey:userID];
        
        if ([userID integerValue] == 0) {
            
            if (op.model.giftCount != 0) {
                op.presentView.frame  = CGRectMake(-viewWidth, (giftHei - 40)/2.0f + 45, viewWidth, 40);
                op.presentView.originFrame = op.presentView.frame;
                [self.queue1 addOperation:op];
            }
            
        }else if ([userID integerValue] == 1) {
            
            if (op.model.giftCount != 0) {
                op.presentView.frame  = CGRectMake(-viewWidth, (giftHei - 40)/2.0f + 45 + giftHei, viewWidth, 40);
                op.presentView.originFrame = op.presentView.frame;
                [self.queue2 addOperation:op];
            }
            
        }else if ([userID integerValue] == 2) {
            
            if (op.model.giftCount != 0) {
                op.presentView.frame  = CGRectMake(-viewWidth, (giftHei - 40)/2.0f + 45 + giftHei*2, viewWidth, 40);
                op.presentView.originFrame = op.presentView.frame;
                [self.queue3 addOperation:op];
            }
            
        }
     
    }

}

/// 取消上一次的动画操作 暂时没用到
- (void)cancelOperationWithLastUserID:(NSString *)userID {
    // 当上次为空时就不执行取消操作 (第一次进入执行时才会为空)
    if (userID!=nil) {
        [[self.operationCache objectForKey:userID] cancel];
    }
}

- (NSOperationQueue *)queue1
{
    if (_queue1==nil) {
        _queue1 = [[NSOperationQueue alloc] init];
        _queue1.maxConcurrentOperationCount = 1;
        
    }
    return _queue1;
}

- (NSOperationQueue *)queue2
{
    if (_queue2==nil) {
        _queue2 = [[NSOperationQueue alloc] init];
        _queue2.maxConcurrentOperationCount = 1;
    }
    return _queue2;
}
- (NSOperationQueue *)queue3
{
    if (_queue3==nil) {
        _queue3 = [[NSOperationQueue alloc] init];
        _queue3.maxConcurrentOperationCount = 1;
    }
    return _queue3;
}

- (NSCache *)operationCache
{
    if (_operationCache==nil) {
        _operationCache = [[NSCache alloc] init];
    }
    return _operationCache;
}

- (NSCache *)userGigtInfos {
    if (_userGigtInfos == nil) {
        _userGigtInfos = [[NSCache alloc] init];
    }
    return _userGigtInfos;
}

@end
