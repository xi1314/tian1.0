//
//  WWCameraCutViewController.h
//  tianyueTV
//
//  Created by 哈儿林林 on 16/11/14.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WWCameraCutViewDelegate <NSObject>
- (void)cropImage:(UIImage *)cropyImage forOriginalImage:(UIImage*)originalImage;

@end
@interface WWCameraCutViewController : UIViewController
//下面俩哪个后面设置，即是哪个有效
@property(nonatomic,strong) UIImage *image;
@property(nonatomic,strong) NSURL *imageURL;

@property(nonatomic,weak) id<WWCameraCutViewDelegate> delegate;

@property(nonatomic,assign) CGFloat ratioOfWidthAndHeight; //截取比例，宽高比
- (void)showWithAnimation:(BOOL)animation;
@property (nonatomic,copy) void (^quedingClickedHandler)();



@end
