//
//  LivingLandscapeViewController.h
//  tianyueTV
//
//  Created by Mac-chen on 2017/5/5.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LivingLandscapeGiftDelegate <NSObject>

- (void)giftSendBack:(NSString *)imgString text:(NSString *)string;

@end

@interface LivingLandscapeViewController : UIViewController

@property (nonatomic, weak) id<LivingLandscapeGiftDelegate> delegate;

@end
