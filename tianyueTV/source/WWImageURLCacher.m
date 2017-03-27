//
//  WWImageURLCacher.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/1/19.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "WWImageURLCacher.h"
#import "UIImageView+WebCache.h"

#import "UIButton+WebCache.h"

#import "SDImageCache.h"

@implementation WWImageURLCacher

static WWImageURLCacher *instance = nil;
+ (WWImageURLCacher *)sharedImageURLCacher {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        
    });
    
    return instance;
    
}

- (void)ww_setCacheWithImageView:(UIImageView *)imageView imageURL:(NSString *)imageURL imageKey:(NSString *)imageKey{
    [imageView setShowActivityIndicatorView:YES];
    [imageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil];
    [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        [[SDWebImageManager sharedManager].imageCache storeImage:image forKey:imageKey toDisk:YES];
    }];
    
    //从缓存图片显示
    UIImage *cacheImage = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:imageKey];
    [imageView setImage:cacheImage];
}

- (void)ww_setCacheWithImageButton:(UIButton *)imageButton imageURL:(NSString *)imageURL imageKey:(NSString *)imageKey{
    [imageButton sd_setImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal placeholderImage:nil];
    
    [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        [[SDWebImageManager sharedManager].imageCache storeImage:image forKey:imageKey toDisk:YES];
    }];
    //从缓存图片显示
    UIImage *cacheImage = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:imageKey];
    [imageButton setImage:cacheImage forState:UIControlStateNormal];
    
}

@end
