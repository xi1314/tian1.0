//
//  GuideViewController.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/12/26.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "GuideViewController.h"
#import "ZQFCycleView.h"
#import "UIImage+CustomImage.h"
#import "ViewController.h"
@interface GuideViewController ()<UIScrollViewDelegate>
{
    NSMutableArray *_images;
}
@property(nonatomic,strong)ZQFCycleView *cycleView;


@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)UIScrollView *scrollerView;
@property(nonatomic,strong)UIPageControl *pageControl;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _images =[[NSMutableArray alloc]initWithObjects:@"版本2-拷贝",@"契合你的内心-",@"实时匠人直播-", nil];
    [self scrollerView];
    [self pageControl];
    for (int i=0; i<3; i++)
    {
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(kWidth*i, 0, kWidth, kHeight)];
        imageView.image =[UIImage imageNamed:_images[i]];
        imageView.userInteractionEnabled =YES;
        if (i==2)
        {
            UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame =CGRectMake(kWidthChange(264), kHeightChange(1048),kWidthChange(212) , kHeightChange(50));
            [button setTitle:@"进入APP" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button.titleLabel.font =[UIFont systemFontOfSize:kWidthChange(24)];
            button.layer.cornerRadius =kHeightChange(25);
            button.clipsToBounds =YES;
            button.layer.borderColor =[[UIColor redColor]CGColor];
            button.layer.borderWidth =kWidthChange(2);
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor redColor]] forState:UIControlStateHighlighted];
            [imageView addSubview:button];
        }
        [self.scrollerView addSubview:imageView];
    }
}
-(UIScrollView *)scrollerView
{
    if (!_scrollerView)
    {
        _scrollerView =[[UIScrollView alloc]initWithFrame:self.view.frame];
        _scrollerView.bounces =NO;
        _scrollerView.showsVerticalScrollIndicator=NO;
        _scrollerView.showsHorizontalScrollIndicator =NO;
        _scrollerView.pagingEnabled =YES;
        _scrollerView.contentSize =CGSizeMake(kWidth*3, kHeight);
        _scrollerView.delegate =self;
        [self.view addSubview:self.scrollerView];
    }
    return _scrollerView;
}
-(UIPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl =[[UIPageControl alloc] initWithFrame:CGRectMake(0, kHeightChange(1152), kWidth, kHeightChange(48))];
        _pageControl.currentPageIndicatorTintColor =[UIColor redColor];
        _pageControl.pageIndicatorTintColor =[UIColor lightGrayColor];
        _pageControl.numberOfPages = _images.count;
        _pageControl.userInteractionEnabled = NO;
        
        [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
        [_pageControl bringSubviewToFront:self.scrollerView];
        [self.view addSubview:_pageControl];

    }
    return _pageControl;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage =scrollView.contentOffset.x /scrollView.bounds.size.width;
}
-(void)pageChanged:(UIPageControl *)pageControl
{
    CGFloat x =(pageControl.currentPage)* self.scrollerView.bounds.size.width;
    [self.scrollerView setContentOffset:CGPointMake(x, 0) animated:YES];
}
-(void)buttonClick:(id)sender
{
    NSString *key =@"CFBundleShortVersionString";
    NSString *currentVersion =[NSBundle mainBundle].infoDictionary[key];
    
    ViewController *vc =[[ViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
    [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
