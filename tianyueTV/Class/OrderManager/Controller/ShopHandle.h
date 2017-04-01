//
//  ShopHandle.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/1.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHandler.h"

@interface ShopHandle : BaseHandler

+ (void)requestForAddressListWithUSer:(NSString *)user
                        completeBlock:(HandlerBlock)completeBlock;
@end
