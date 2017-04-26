
#import <UIKit/UIKit.h>

@interface UIView (DHSAddtion)

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

//左右上下
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;

//宽度高度
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;


@property (nonatomic, assign) CGFloat centerx;
@property (nonatomic, assign) CGFloat centery;


- (void)removeAllSubviews;

@end
