//
//  UIImage+CustomImage.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/12.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "UIImage+CustomImage.h"

@implementation UIImage (CustomImage)

+(UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end
