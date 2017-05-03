//
//  WWChatRoomView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/12/5.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWChatRoomView.h"
#import "WWChatCell.h"
#import "WWLivingViewController.h"

#define noDisableVerticalScrollTag 836913
#define noDisableHorizontalScrollTag 836914

@implementation UIImageView (WLScrollView)

- (void)setAlpha:(CGFloat)alpha
{
    
    if (self.superview.tag == noDisableVerticalScrollTag) {
        if (alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleLeftMargin) {
            if (self.frame.size.width < 10 && self.frame.size.height > self.frame.size.width) {
                UIScrollView *sc = (UIScrollView*)self.superview;
                if (sc.frame.size.height < sc.contentSize.height) {
                    return;
                }
            }
        }
    }
    
    if (self.superview.tag == noDisableHorizontalScrollTag) {
        if (alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleTopMargin) {
            if (self.frame.size.height < 10 && self.frame.size.height < self.frame.size.width) {
                UIScrollView *sc = (UIScrollView*)self.superview;
                if (sc.frame.size.width < sc.contentSize.width) {
                    return;
                }
            }
        }
    }
    
    [super setAlpha:alpha];
}
@end

@class WWLivingViewController;

@interface WWChatRoomView()
<UIScrollViewDelegate,
UITableViewDataSource,
UITableViewDelegate>

// 互动按钮
@property (nonatomic,strong) UIButton *hudongButton;

// 礼物按钮
@property (nonatomic,strong) UIButton *liwuButton;

// 显示或隐藏
@property (nonatomic,strong) UIButton *showOrHiddenButton;

// 底部不隐藏的选项
@property (nonatomic,strong) UIView *bottomView;


@property (nonatomic,strong) UIView *lineView;

@end

@implementation WWChatRoomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
//        self.chatRoomView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addPureLayOut];
    }
    return self;
}



#pragma mark - Actions
//点击显示或者隐藏
- (void)respondsToShowOrHiddenButton:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.chatRoomView.hidden = sender.selected;
    
}

- (void)respondsToHudongClicked:(UIButton *)sender{
    self.chatRoomView.contentOffset = CGPointMake(0 * self.chatRoomView.frame.size.width, 0);
    NSLog(@"互动");
}
- (void)respondsToLiwuClicked:(UIButton *)sender{
    self.chatRoomView.contentOffset = CGPointMake(1 * self.chatRoomView.frame.size.width, 0);
    NSLog(@"liw");
}

#pragma mark ----UITableViewDataSource && UITableViewDelegate----
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WWChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWChatCell"];
    if (!cell) {
        cell = [[WWChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WWChatCell"];
    }
//     [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    cell.messageLabel.text = self.messageArray[indexPath.row];
   NSString *str = self.messageArray[indexPath.row];
    if ([str rangeOfString:@"{aodiandmssplit}"].location != NSNotFound) {
        NSRange range = [str rangeOfString:@"{aodiandmssplit}"];
        NSString *nameString = [str substringToIndex:range.location];
        //        NSString *messageString = [message.payloadString substringFromIndex:range.location];
        NSLog(@"昵称：%@",nameString);
        NSString *messageString = [str stringByReplacingOccurrencesOfString:@"{aodiandmssplit}" withString:@":"];
        
        //        NSLog(@"%@",newString);
        messageString = [messageString stringByReplacingCharactersInRange:NSMakeRange([str rangeOfString:@"{aodiandmssplit}"].location, 10) withString:@":"];
        NSLog(@"消息：%@",messageString);
        //            NSLog(@"%lu",(unsigned long)[message.payloadString rangeOfString:@"{aodiandmssplit}"].location);
        NSMutableAttributedString *textMesage = [[NSMutableAttributedString alloc] initWithString:messageString];
        NSRange textName = [[textMesage string] rangeOfString:nameString];
        [textMesage addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:textName];
        [textMesage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:textName];
        [cell.messageLabel setAttributedText:textMesage];
    }else{
        NSString *string = @"系统消息:";
        NSString *messageStr = [string stringByAppendingString:str];
        NSMutableAttributedString *textMesage = [[NSMutableAttributedString alloc] initWithString:messageStr];
        NSRange textName = [[textMesage string] rangeOfString:string];
        [textMesage addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:textName];
        [textMesage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:textName];
//        NSLog(@"%lu",(unsigned long)textMesage.length);
        if (textMesage.length == 5) {
            cell.messageLabel.text = @"";
        }else{
            [cell.messageLabel setAttributedText:textMesage];
        }
        
        
    }

    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    
    return self.messageArray.count;
  
    
}



#pragma mark ----添加视图-----
- (void)addPureLayOut{
    
   
    [self addSubview:self.chatRoomView];
    [self.chatRoomView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.chatRoomView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.chatRoomView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.chatRoomView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
//    [self.chatRoomView reloadData];
    [self.chatRoomView flashScrollIndicators];
//
    //聊天
    [self.chatRoomView addSubview:self.chatRoomTableView];
  
//    [self.chatRoomTableView autoPinEdgeToSuperviewEdge:ALEdgeTop];
//    [self.chatRoomTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(100)];
//    [self.chatRoomTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
//    [self.chatRoomTableView autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH];
    
    //
    //底部背景图
    [self addSubview:self.bottomView];
    [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.bottomView autoSetDimension:ALDimensionHeight toSize:kHeightChange(70)];
    
    
    [self addSubview:self.hudongButton];
    [self.hudongButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.hudongButton autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH *0.5];
    [self.hudongButton autoSetDimension:ALDimensionHeight toSize:kHeightChange(70)];
    [self.hudongButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    [self addSubview:self.liwuButton];
    [self.liwuButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(130)];
    [self.liwuButton autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH *0.3];
    [self.liwuButton autoSetDimension:ALDimensionHeight toSize:kHeightChange(70)];
    [self.liwuButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(0)];
    
    [self addSubview:self.lineView];
    [self.lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.lineView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.lineView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.hudongButton];
    [self.lineView autoSetDimension:ALDimensionHeight toSize:kHeightChange(2)];
    
    [self addSubview:self.showOrHiddenButton];
    [self.showOrHiddenButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [self.showOrHiddenButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.liwuButton withOffset:0];
    
//    [self addObserver:self forKeyPath:@"messageArray" options:NSKeyValueObservingOptionOld context:nil];
}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    NSLog(@"数据源：%@",self.messageArray);
//    if ([keyPath isEqualToString:@"messageArray"]) {
//        [UIView animateWithDuration:0.2 animations:^{
//            [self.chatRoomTableView reloadData];
//        }];
//    
//        NSLog(@"监听到%@对象的%@属性发生了改变， %@", object, keyPath, change);
//    }
//    
////    [self.chatRoomTableView reloadData];
//    
//    
//}

#pragma mark - Getters
//底部不隐藏按钮
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 72, SCREEN_WIDTH, 72);
        
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    }
    return _bottomView;
}

// 显示或隐藏按钮
- (UIButton *)showOrHiddenButton{
    if (!_showOrHiddenButton) {
        _showOrHiddenButton = [[UIButton alloc] init];
        _showOrHiddenButton.size = CGSizeMake(24, 13);
        [_showOrHiddenButton setBackgroundImage:[UIImage imageNamed:@"收起"] forState:UIControlStateNormal];
        [_showOrHiddenButton setBackgroundImage:[UIImage imageNamed:@"显示"] forState:UIControlStateSelected];
        [_showOrHiddenButton addTarget:self action:@selector(respondsToShowOrHiddenButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showOrHiddenButton;
}

- (NSMutableArray *)messageArray{
    if (!_messageArray) {
//        _messageArray = [[NSMutableArray alloc] initWithObjects:@"", @"",@"",@"",@"",@"",@"",@"",nil];
        _messageArray = [[NSMutableArray alloc] init];
            }
    return _messageArray;
}

//横线
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
        _lineView.alpha = 0.5;
    }
    return _lineView;
}

- (UITableView *)chatRoomTableView{
    if (!_chatRoomTableView) {
        _chatRoomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,kHeightChange(430)) style:UITableViewStylePlain];
        _chatRoomTableView.dataSource = self;
        _chatRoomTableView.delegate = self;
        _chatRoomTableView.rowHeight = kHeightChange(60);
        _chatRoomTableView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
        [_chatRoomTableView registerClass:[WWChatCell class] forCellReuseIdentifier:@"WWChatCell"];
        _chatRoomTableView.userInteractionEnabled = YES;
        _chatRoomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _chatRoomTableView.showsHorizontalScrollIndicator = NO;
        _chatRoomTableView.showsVerticalScrollIndicator = NO;
//        [_chatRoomTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
      
            
        
        
        
    }
    return _chatRoomTableView;
}

- (UIButton *)liwuButton{
    if (!_liwuButton) {
        _liwuButton = [[UIButton alloc] init];
        [_liwuButton setTitle:@"礼物" forState:UIControlStateNormal];
        _liwuButton.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
        _liwuButton.titleLabel.textColor = [UIColor whiteColor];
        _liwuButton.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(34)];
        [_liwuButton addTarget:self action:@selector(respondsToLiwuClicked:) forControlEvents:UIControlEventTouchUpInside];
        

    }
    return _liwuButton;
}

- (UIButton *)hudongButton{
    if (!_hudongButton) {
        _hudongButton = [[UIButton alloc] init];
        [_hudongButton setTitle:@"互动" forState:UIControlStateNormal];
        _hudongButton.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
        _hudongButton.titleLabel.textColor = [UIColor whiteColor];
        _hudongButton.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(34)];
        [_hudongButton addTarget:self action:@selector(respondsToHudongClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hudongButton;
}

- (UIScrollView *)chatRoomView{
    if (!_chatRoomView) {
        _chatRoomView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH *0.5, kHeightChange(100))];
        _chatRoomView.contentSize = CGSizeMake(self.frame.size.width * 2, kHeightChange(430));
        _chatRoomView.pagingEnabled = YES;
        _chatRoomView.showsHorizontalScrollIndicator = YES;
        _chatRoomView.showsVerticalScrollIndicator = YES;
        _chatRoomView.delegate = self;
        _chatRoomView.scrollEnabled = NO;
        _chatRoomView.userInteractionEnabled = YES;
//        _chatRoomView.backgroundColor = [UIColor greenColor];
          _chatRoomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        _chatRoomView.tag = 836914;
        
        
    }
    return _chatRoomView;
}


@end
