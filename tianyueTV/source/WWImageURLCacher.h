//
//  WWImageURLCacher.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/1/19.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWImageURLCacher : NSObject
+ (WWImageURLCacher *)sharedImageURLCacher;
- (void)ww_setCacheWithImageView:(UIImageView *)imageView imageURL:(NSString *)imageURL imageKey:(NSString *)imageKey;
- (void)ww_setCacheWithImageButton:(UIButton *)imageButton imageURL:(NSString *)imageURL imageKey:(NSString *)imageKey;
@end
