//
//  SearchViewController.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/13.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "SearchViewController.h"
#import "SKTagView.h"
#import "SearchResultViewController.h"
#import "MBProgressHUD+MJ.h"
#import "LiveModel.h"
@interface SearchViewController ()<UISearchBarDelegate>
{
    UISearchBar *_searchBar;
}
@property(nonatomic,strong)UILabel *hotSearch;
@property(nonatomic,strong)SKTagView *tagView;
@property(nonatomic,strong)UILabel *historyLabel;
@property(nonatomic,strong)NSArray *data;
@property(nonatomic,strong)SKTagView *historyTagView;
@property(nonatomic,strong)NSMutableArray *historydata;
@property(nonatomic,strong)UIButton *cleanBtn;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self customBackBtn];
    [self addLayout];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_searchBar resignFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
-(void)hotSearchRequest
{
//    NSString *url =@"http://192.168.0.88:8080/ApphotWordslist";
    //NSString *url =@"http://www.tianyue.tv/ApphotWordslist";
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"ApphotWordslist" paraments:nil finish:^(id responseObject, NSError *error) {
        
        NSLog(@"--hot-responseObject---%@------",responseObject);
        //NSString *hotSearch =[NSString replaceUnicode:responseObject[@"Textarea_rc"]];
        NSString *hotSearch =responseObject[@"Textarea_rc"];
        NSLog(@"---hotSearch--%@---",hotSearch);
        self.data =[hotSearch componentsSeparatedByString:@","];
        
        [self.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            SKTag *tag =[[SKTag alloc]initWithText:self.data[idx]];
            tag.padding =UIEdgeInsetsMake(kHeightChange(10), kWidthChange(20), kHeightChange(10), kWidthChange(20)) ;
            
            tag.cornerRadius =kHeightChange(50/2);
            tag.font =[UIFont systemFontOfSize:kWidthChange(25)];
            tag.borderColor =WWColor(199, 199, 199);
            tag.borderWidth =1;
            tag.bgColor =[UIColor whiteColor];
            tag.textColor =WWColor(83, 83, 83);
            tag.enable =YES;
            [self.tagView addTag:tag];
        }];
        __weak typeof(self) weakSelf = self;
        __weak UISearchBar *weakBar =_searchBar;
        self.tagView.didTapTagAtIndex = ^(NSUInteger idx)
        {
            NSLog(@"---点击了第%ld个",idx);
            weakBar.text = weakSelf.data[idx];
        };
        [self.tagView layoutSubviews];
    }];
}
-(void)netRequest
{
    //NSString *url =@"http://192.168.0.88:8082/Querycorrespondence";
//    NSString *url =@"http://www.tianyue.tv/Querycorrespondence";
    NSMutableDictionary *paraments =[[NSMutableDictionary alloc]init];
    paraments[@"name"] =_searchBar.text;
    [[NetWorkTool sharedTool]requestMethod:POST URL:@"Querycorrespondence" paraments:paraments finish:^(id responseObject, NSError *error) {
        if ([responseObject[@"ret"] isEqualToString:@"error"])
        {
            [MBProgressHUD showError:@"您搜索的主播还未开播"];
        }
        if ([responseObject[@"ret"] isEqualToString:@"success"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:_searchBar.text forKey:@"historydata"];
            [[NSUserDefaults standardUserDefaults]synchronize];

            if (![self.historydata containsObject:_searchBar.text])
            {
                [self.historydata addObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"historydata"]];
                
                [self.historyTagView removeAllTags];

                [self.historydata enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    SKTag *tag =[[SKTag alloc]initWithText:self.historydata[idx]];
                    tag.padding =UIEdgeInsetsMake(kHeightChange(10), kWidthChange(20), kHeightChange(10), kWidthChange(20));
                    
                    tag.cornerRadius =kHeightChange(50/2);
                    tag.font =[UIFont systemFontOfSize:kWidthChange(25)];
                    tag.borderColor =WWColor(199, 199, 199);
                    tag.borderWidth =1;
                    tag.bgColor =[UIColor whiteColor];
                    tag.textColor =WWColor(83, 83, 83);
                    tag.enable =YES;
                    
                    [self.historyTagView addTag:tag];
                }];
                __weak SearchViewController *weakSelf =self;
                __weak UISearchBar *weakBar =_searchBar;
                self.historyTagView.didTapTagAtIndex = ^(NSUInteger idx)
                {
                    NSLog(@"点击了第%ld个",idx);
                    weakBar.text = weakSelf.historydata[idx];
                };
                
                [self.historyTagView layoutSubviews];
            }
            NSArray *data =responseObject[@"BroadCastUser"];
            NSMutableArray *array =[NSMutableArray array];
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                LiveModel *model =[[LiveModel alloc]initWithDictionary:obj];
                [array addObject:model];
            }];
            
            SearchResultViewController *vc =[[SearchResultViewController alloc]init];
            vc.results =array;
            vc.titl =_searchBar.text;
            [vc.collcetionView reloadData];
            UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }];
}
-(SKTagView *)historyTagView
{
    if (!_historyTagView)
    {
        _historyTagView =[[SKTagView alloc]init];
        _historyTagView.lineSpacing =kHeightChange(35);
        _historyTagView.interitemSpacing =kWidthChange(52);
        _historyTagView.preferredMaxLayoutWidth =kWidth;
        _historyTagView.userInteractionEnabled =YES;
        [self.historyTagView removeAllTags];
        
        _historyTagView.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.historyTagView];
        }
    return _historyTagView;
}

-(SKTagView *)tagView
{
    if (!_tagView)
    {
        _tagView =[[SKTagView alloc]init];
        _tagView.lineSpacing =kHeightChange(35);
        _tagView.interitemSpacing =kWidthChange(52);
        _tagView.preferredMaxLayoutWidth =kWidth;
        _tagView.userInteractionEnabled =YES;
        [self.tagView removeAllTags];
        [self hotSearchRequest];
        _tagView.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.tagView];
    }
    return _tagView;
}

-(NSArray *)data
{
    if (!_data)
    {
        _data =[[NSArray alloc]init]
        ;
    }
    return _data;
}
-(NSMutableArray *)historydata
{
    if (!_historydata)
    {
        _historydata =[[NSMutableArray alloc]initWithCapacity:0];
        
        _historydata =(NSMutableArray *)[[_historydata reverseObjectEnumerator] allObjects];
    }
    return _historydata;
}
-(UILabel *)hotSearch
{
    if (!_hotSearch)
    {
        _hotSearch=[[UILabel alloc]init];
        _hotSearch.text =@"热门搜索";
        _hotSearch.textColor=WWColor(199, 199, 199);
        _hotSearch.font =[UIFont systemFontOfSize:kWidthChange(30)];
        _hotSearch.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addSubview:self.hotSearch];
    }
    return _hotSearch;
}
-(UILabel *)historyLabel
{
    if (!_historyLabel)
    {
        _historyLabel =[[UILabel alloc]init];;
        _historyLabel.text =@"历史搜索";
        _historyLabel.textColor =WWColor(199, 199, 199);
        _historyLabel.font =[UIFont systemFontOfSize:kWidthChange(30)];
        _historyLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.historyLabel];
    }
    return _historyLabel;
}
-(UIButton *)cleanBtn
{
    if (!_cleanBtn)
    {
        _cleanBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_cleanBtn setBackgroundImage:[UIImage imageNamed:@"清空"] forState:UIControlStateNormal];
        
        [_cleanBtn addTarget:self action:@selector(cleanBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _cleanBtn.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addSubview:self.cleanBtn];
    }
    return _cleanBtn;
}
-(void)customBackBtn
{
    UIButton *backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame =CGRectMake(0, 0, kWidthChange(75), kHeightChange(35));
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    backBtn.titleLabel.font =[UIFont systemFontOfSize:kWidthChange(30)];
    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem =[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem =backItem;
    
    _searchBar =[[UISearchBar alloc]init];
    _searchBar.frame=CGRectMake(kWidthChange(30), kHeightChange(40), kWidthChange(650), kHeightChange(50));
    _searchBar.placeholder =@"搜你所好";
    UITextField *textField =[_searchBar valueForKey:@"_searchField"];
    textField.borderStyle =UITextBorderStyleRoundedRect;
//    [textField setValue:[UIFont boldSystemFontOfSize:kWidthChange(24)] forKeyPath:@"_placeholderLabel.font"];
//    textField.clipsToBounds =YES;
//    textField.layer.cornerRadius =kHeightChange(40);
    _searchBar.barTintColor =[UIColor whiteColor];
    _searchBar.delegate =self;
    self.navigationItem.titleView =_searchBar;
    self.navigationController.navigationBar.backgroundColor =WWColor(204, 204, 204);
}
#pragma mark ----UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self netRequest];
}
-(void)addLayout
{
    [self.hotSearch autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(50)+64];
    [self.hotSearch autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(10)];
    [self.hotSearch autoSetDimensionsToSize:CGSizeMake(kWidthChange(130), kHeightChange(33))];
    
    [self.tagView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(58)];
    [self.tagView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.hotSearch withOffset:kHeightChange(37)];
    [self.tagView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(58)];
    [self.tagView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.historyLabel withOffset:-kHeightChange(28)];
    
    [self.historyLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(10)];
    [self.historyLabel autoSetDimensionsToSize:CGSizeMake(kWidthChange(130), kHeightChange(33))];
    
    [self.historyTagView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(58)];
    [self.historyTagView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.historyLabel withOffset:kHeightChange(37)];
    [self.historyTagView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(58)];
    [self.historyTagView autoSetDimension:ALDimensionWidth toSize:kHeightChange(700)];
    
    [self.cleanBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(38)];
    [self.cleanBtn autoSetDimensionsToSize:CGSizeMake(kWidthChange(33), kHeightChange(33))];
    [@[self.cleanBtn,self.historyLabel]autoAlignViewsToAxis:ALAxisHorizontal];
}

-(void)backBtnClick:(id)sender
{
    _searchBar.text =@"";
    [self.view endEditing:YES];
}
-(void)cleanBtnClick
{
    [self.historyTagView removeAllTags];
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
