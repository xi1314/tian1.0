//
//  AVFile+UploadMoreFile.m
//  
//
//  Created by rimi on 16/7/21.
//
//

#import "AVFile+UploadMoreFile.h"

@implementation UpYun (UploadMoreFile)

+ (void)uploadFiles:(NSArray *)files completion:(Completion)completion
{
    __block UpYun *uy = [[UpYun alloc] init];
    __block  NSInteger count = 0;
    [files enumerateObjectsUsingBlock:^(UIImage *  _Nonnull file, NSUInteger idx, BOOL * _Nonnull stop) {
        count++;
         [uy uploadFile:file saveKey:[uy getSaveKeyWith:@"png"]];
        uy.failBlocker = ^(NSError * error) {
            //        NSString *message = error.description;
            //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"message" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //        [alert show];
          
            NSLog(@"error %@", error);
            
                 completion(nil,error);
            
        };
//        uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
//           
//        };
        uy.successBlocker = ^(NSURLResponse *response, id responseData) {
            
            
            
            NSMutableArray *arr = [NSMutableArray array];
//            [files enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (responseData[@"url"]) {
//                    [arr addObject:responseData[@"url"]];
//                }
//            }];
            
            NSString *str = [arr componentsJoinedByString:@","];
            completion(str,nil);
            
            
            
        } ;
        
       

        
        
        
        
        
    }];
    
     }


- (NSString * )getSaveKeyWith:(NSString *)suffix {
    /**
     *	@brief	方式1 由开发者生成saveKey
     */
    return [NSString stringWithFormat:@"/%@.%@", [self getDateString], suffix];
    /**
     *	@brief	方式2 由服务器生成saveKey
     */
    //        return [NSString stringWithFormat:@"/{year}/{mon}/{filename}{.suffix}"];
    /**
     *	@brief	更多方式 参阅 http://docs.upyun.com/api/form_api/#_4
     */
}

- (NSString *)getDateString {
    NSDate *curDate = [NSDate date];//获取当前日期
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy/MM/dd"];//这里去掉 具体时间 保留日期
    NSString * curTime = [formater stringFromDate:curDate];
    curTime = [NSString stringWithFormat:@"%@/%.0f", curTime, [curDate timeIntervalSince1970]];
    return curTime;
}


@end
