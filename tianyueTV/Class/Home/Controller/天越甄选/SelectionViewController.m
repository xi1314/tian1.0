//
//  SelectionViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/27.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "SelectionViewController.h"
#import "SelectionTopView.h"
#import "CycleCarouselView.h"
#import "CardView.h"


@interface SelectionViewController ()

// 卡片视图
@property (nonatomic, strong) CardView *cardView;

// 下方滚动视图
@property (nonatomic, strong) UIScrollView *bottomScrollView;

@end

@implementation SelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initilizeInterface];
    [self addCardViewToSuperview];
    [self addBottomScrollViewToSuperview];
}

- (void)initilizeInterface {
    self.title = @"天越甄选";
    self.view.backgroundColor = WWColor(243, 244, 246);
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToLeftItem:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}


/**
 卡片视图
 */
- (void)addCardViewToSuperview {
    _cardView = [[CardView alloc] initWithFrame:CGRectMake(18, 35, SCREEN_WIDTH - 36, SCREEN_HEIGHT * 0.54 - 64)];
    [self.view addSubview:_cardView];
}


/**
 小滚动视图
 */
- (void)addBottomScrollViewToSuperview {
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cardView.frame) + 36, SCREEN_WIDTH, 147)];
    _bottomScrollView.backgroundColor = [UIColor whiteColor];
    _bottomScrollView.contentSize = CGSizeMake(72 + (130 + 16) * 5, _bottomScrollView.height);
    _bottomScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_bottomScrollView];
    
    for (int i = 0; i < 5; i++) {
        SelectionTopView *selecView = [[SelectionTopView alloc] initWithFrame:CGRectMake(36 + (130 + 16) * i, 12, 130, CGRectGetHeight(self.bottomScrollView.frame) - 24)];
        [_bottomScrollView addSubview:selecView];
    }
}


#pragma mark - respondsToLeftItem
- (void)respondsToLeftItem:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
