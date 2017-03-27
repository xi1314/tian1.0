
//
//  TypeView.m
//  AddShoppingCart
//
//  Created by 主用户 on 16/3/23.
//  Copyright © 2016年 江萧. All rights reserved.
//

#import "TypeView.h"

@implementation TypeView
-(instancetype)initWithFrame:(CGRect)frame andDatasource:(NSArray *)arr :(NSString *)typename
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        lab.text = typename;
        lab.textColor = [UIColor blackColor];
        lab.font = [UIFont systemFontOfSize:14];
        [self addSubview:lab];
        
        BOOL  isLineReturn = NO;
        float upX = 50;
        float upY = 10;
        for (int i = 0; i<arr.count; i++) {
            NSString *str = [arr objectAtIndex:i] ;
          
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
            CGSize size = [str sizeWithAttributes:dic];
            //NSLog(@"%f",size.height);
            if ( upX > (self.frame.size.width -size.width-35)) {
                
                isLineReturn = YES;
                upX = 60;
                upY += 30;
            }
            
            UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(upX, upY, size.width+30,25);
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitleColor:WWColor(163, 163, 163) forState:0];
            [btn setTitleColor:THEME_COLOR forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitle:[arr objectAtIndex:i] forState:0];
            btn.layer.cornerRadius = 3;
            btn.layer.borderColor = LINE_COLOR.CGColor;
            btn.layer.borderWidth =1;
            [btn.layer setMasksToBounds:YES];
            
            [self addSubview:btn];
            btn.tag = 100+i;
            [btn addTarget:self action:@selector(touchbtn:) forControlEvents:UIControlEventTouchUpInside];
            upX+=size.width+40;
        }

        upY +=30;
        
        self.height = upY+11;
        
        self.seletIndex = -1;
    }
    return self;
}

-(void)touchbtn:(UIButton *)btn
{
    
    if (btn.selected == NO) {
        
        self.seletIndex = (int)btn.tag-100;
//        btn.backgroundColor = [UIColor redColor];
        btn.layer.borderColor = THEME_COLOR.CGColor;
    
    }else {
        self.seletIndex = -1;
        btn.selected = NO;
        btn.layer.borderColor = LINE_COLOR.CGColor;
        [btn setTitleColor:WWColor(163, 163, 163) forState:0];
    }
    [self.delegate btnindex:(int)btn.tag-100];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
