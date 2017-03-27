//
//  AVFile+UploadMoreFile.h
//  
//
//  Created by rimi on 16/7/21.
//
//

#import "UpYun.h"

typedef void(^Completion)(NSString *fileUrlString,NSError *error);

@interface UpYun (UploadMoreFile)
+ (void)uploadFiles:(NSArray *)files completion:(Completion)completion;
- (NSString * )getSaveKeyWith:(NSString *)suffix;

@end
