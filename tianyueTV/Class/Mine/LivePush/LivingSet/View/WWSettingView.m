//
//  WWSettingView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/11/28.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWSettingView.h"
#import "WWAnchorSpaceViewController.h"
#import "WWBiaoqianViewController.h"


@interface WWSettingView()<UITextViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL datePickerShowOrHiden;/* 日期选择器是否隐藏 */
}
@property (nonatomic,strong) UIView *nameBgView;//房间名字的背景输入框
@property (nonatomic,strong) UILabel *nameLabel;//房间名字


@property (nonatomic,strong) UIView *typeBgView;//分类背景
@property (nonatomic,strong) UILabel *typerLabel;//分类


@property (nonatomic,strong) UIView *custumLabelBgView;//自定义标签栏的背景
@property (nonatomic,strong) UILabel *cumstomLabel;//自定义标签
@property (nonatomic,strong) UIButton *bianjiButtom;//右边编辑按钮

@property (nonatomic,strong) UIView *biaoqianBgView;//标签背景视图
@property (nonatomic,strong) UIButton *buttom1;//标签一
@property (nonatomic,strong) UIButton *buttom2;//标签二
@property (nonatomic,strong) UIButton *button3;//标签三
@property (nonatomic,strong) UIButton *button4;//标签四

@property (nonatomic,strong) UIView *roomWarningBgView;//房间公告背景
@property (nonatomic,strong) UILabel *rooWarningLbael;//房间公告
@property (nonatomic,strong) UITextView *contentLabel;//房间公告内容

@property (nonatomic,strong) UIPickerView *datePickerView;/* 日期选择器 */
@property (nonatomic,strong) NSDictionary *cityNames;/* plist文件信息 */
@property (nonatomic,strong) NSArray *provinces;/* 所有省份 */
@property (nonatomic,strong) NSArray *cities;/* 所有城市 */
@property (nonatomic,strong) NSString *city;/* 城市 */
@property (nonatomic,strong) NSString *province;/* 省份 */
@property (nonatomic,strong) UIView *topDateView;
@property (nonatomic,strong) UIButton *wanchengButton;/* 完成按钮 */


@end


@implementation WWSettingView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
      
        [self addPureLayOut];

    }
    return self;
}



- (void)respondsToBianjiClicked:(UIButton *)sender{
    if (self.SettingHandler) {
        self.SettingHandler();
    }
    NSLog(@"修改");
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"请输入房间公告"]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请输入房间公告";
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (datePickerShowOrHiden == NO) {
        [self showDatePickerView];
    }else{
        [self hiddenDatePickerView];
    }
    //写你要实现的：页面跳转的相关代码
    
    return NO;
    
}

#pragma mark ----UICollectionViewDataSource-----

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"_collectionViewW" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}
#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(20, 20);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(20, 20);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(20, 20);
}
#pragma mark ---- UICollectionViewDelegate

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hiddenDatePickerView];
   
   
}


#pragma mark ----日期选择器----
- (UIPickerView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0 , SCREEN_HEIGHT, SCREEN_WIDTH, kHeightChange(300))];
        //        _datePickerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _datePickerView.backgroundColor = [UIColor whiteColor];
        _datePickerView.dataSource = self;
        _datePickerView.delegate = self;
        _datePickerView.showsSelectionIndicator = YES;
        _datePickerView.layer.borderWidth = 0.5;
        _datePickerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _datePickerView.userInteractionEnabled = YES;
        
    }
    return _datePickerView;
}

- (NSDictionary *)cityNames{
    if (_cityNames == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"typeData" ofType:@"plist"];
        _cityNames = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _cityNames;
}

- (NSArray *)provinces{
    if (_provinces == nil) {
        _provinces = [self.cityNames allKeys];
    }
    return _provinces;
}

- (UIView *)topDateView{
    if (!_topDateView) {
        _topDateView = [[UIView alloc] initWithFrame:CGRectMake(0 , SCREEN_HEIGHT, SCREEN_WIDTH, kHeightChange(80))];
        _topDateView.backgroundColor = [UIColor blueColor];
    }
    return _topDateView;
}



- (void)showDatePickerView{
    [self addSubview:self.datePickerView];
    [self addSubview:self.topDateView];
    
    [UIView beginAnimations:@"showDatePickerView" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    //    [UIView setAnimationWillStartSelector:<#(nullable SEL)#>]
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGPoint cent = CGPointMake(SCREEN_WIDTH *0.5, SCREEN_HEIGHT - kHeightChange(150));
    self.datePickerView.center = cent;
    datePickerShowOrHiden = YES;
    [UIView commitAnimations];
}

- (void)hiddenDatePickerView{
    [UIView beginAnimations:@"hiddenDatePickerView" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    //    [UIView setAnimationWillStartSelector:<#(nullable SEL)#>]
    [UIView setAnimationDidStopSelector:@selector(removeDatePickerView)];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGPoint cent = CGPointMake(SCREEN_WIDTH *0.5, SCREEN_HEIGHT + kHeightChange(150));
    self.datePickerView.center = cent;
    self.topDateView.center = cent;
    datePickerShowOrHiden = NO;
    [UIView commitAnimations];
    //    [self.datePickerView removeFromSuperview];
}

- (void)removeDatePickerView{
    [self.datePickerView removeFromSuperview];
   
}


#pragma mark ----UIPickerViewDataSource && UIPickerViewDelegate----


//返回cell
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *pickerTextLb = (UILabel *)view;
    if (!pickerTextLb) {
        pickerTextLb = [[UILabel alloc]init];
        pickerTextLb.textColor = [UIColor blackColor];
        pickerTextLb.adjustsFontSizeToFitWidth = YES;
        pickerTextLb.textAlignment = NSTextAlignmentCenter;
        pickerTextLb.font = [UIFont systemFontOfSize:kWidthChange(34)];
    }
    pickerTextLb.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerTextLb;
}
/**
 *  返回每一列的行数
 */
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    
    
    if (component == 0) {
        return self.provinces.count;
    }
    else {
        
        [self loadData:pickerView];
        
        
        return self.cities.count;
    }
}

/**
 *  返回每一行显示的文本
 */
- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    //第一列返回所有的省份
    if (component == 0) {
        
        
        return self.provinces[row];
        
    }else{
        
        
        //         [self loadData:pickerView];
        return self.cities[row];
    }
}




/**
 *  加载第二列显示的数据
 */
-(void)loadData:(UIPickerView*)pickerView
{
    
    //一定要首先获取用户选择的那一行 然后才可以根据选中行获取省份 获取省份以后再去字典中加载省份对应的城市
    NSInteger selRow = [pickerView selectedRowInComponent:0];
    
    NSString *key = self.provinces[selRow];
    
    self.cities = [self.cityNames valueForKey:key];
    
}

/**
 *  一共多少咧
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 2;
}

/**
 *  选中某一行后回调 联动的关键
 */
- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //    WWBianjiTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (component == 0) {
        
        //重新加载第二列的数据
        [pickerView reloadComponent:1];
        //让第二列归位
        [pickerView selectRow:0 inComponent:1 animated:YES];
        self.province = self.provinces[row];
        NSLog(@"省份：%@",self.provinces[row]);
        self.Namelevel = self.province;
        if (self.NamelevelHandler) {
            self.NamelevelHandler(self.province);
        }
//        self.settingVc.Namelevel = self.province;
        
//        self.typerTextFiled.text = self.cities[0];
        self.typerTextFiled.text = self.cities[0];
        
        //        cell.rightLabel.text = self.provinces[row];
        //获取当前选中cell
        //        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        
    }else{
        self.city = self.cities[row];
        NSLog(@"城市：%@",self.cities[row]);
        if (self.province) {
//            self.typerTextFiled.text = self.city;
            self.typerTextFiled.text = self.city;
           
        }
        self.city = self.cities[row];
        NSLog(@"城市：%@",self.cities[row]);
//        if (self.province) {
//            if ([self.cities[row] isEqualToString:@"不限"]) {
//                self.typerTextFiled.text = self.province;
//            }else{
//                self.typerTextFiled.text = [@"" stringByAppendingFormat:@"%@-%@",self.province,self.city];
//            }
//            
//        }
    }
}



#pragma mark ----添加约束----

- (void)addPureLayOut{
    //背景
    [self addSubview:self.nameBgView];
    [self.nameBgView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:64];
    [self.nameBgView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.nameBgView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.nameBgView autoSetDimension:ALDimensionHeight toSize:kHeightChange(98)];

    //房间名
    [self.nameBgView addSubview:self.nameLabel];
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.nameLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    //房间名输入框
    [self.nameBgView addSubview:self.nameTextFiled];
    [self.nameTextFiled autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.nameTextFiled autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(100)];
    [self.nameTextFiled autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(100)];
    
    //分类背景
    [self addSubview:self.typeBgView];
    [self.typeBgView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.typeBgView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.typeBgView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameBgView];
    [self.typeBgView autoSetDimension:ALDimensionHeight toSize:kHeightChange(98)];
    
    //分类
    [self.typeBgView addSubview:self.typerLabel];
    [self.typerLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.typerLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    //分类选择
    [self.typeBgView addSubview:self.typerTextFiled];
    [self.typerTextFiled autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.typerTextFiled autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(100)];
    [self.typerTextFiled autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(100)];
    
    //自定义标签背景
    [self addSubview:self.custumLabelBgView];
    [self.custumLabelBgView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.typeBgView];
    [self.custumLabelBgView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.custumLabelBgView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.custumLabelBgView autoSetDimension:ALDimensionHeight toSize:kHeightChange(90)];
    
    //自定义标签
    [self.custumLabelBgView addSubview:self.cumstomLabel];
    [self.cumstomLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.cumstomLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    //编辑修改按钮
    [self.custumLabelBgView addSubview:self.bianjiButtom];
    [self.bianjiButtom autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    [self.bianjiButtom autoSetDimensionsToSize:CGSizeMake(kWidthChange(40), kWidthChange(40))];
    [self.bianjiButtom autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    //标签背景
    [self addSubview:self.biaoqianBgView];
    [self.biaoqianBgView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.custumLabelBgView];
    [self.biaoqianBgView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.biaoqianBgView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.biaoqianBgView autoSetDimension:ALDimensionHeight toSize:kHeightChange(98)];
    
//    //标签一
//    [self.biaoqianBgView addSubview:self.buttom1];
//    [self.buttom1 autoSetDimensionsToSize:CGSizeMake(kWidthChange(140), kHeightChange(40))];
//    [self.buttom1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
//    [self.buttom1 autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//    
//    //标签二
//    [self.biaoqianBgView addSubview:self.buttom2];
//    [self.buttom2 autoSetDimensionsToSize:CGSizeMake(kWidthChange(140), kHeightChange(40))];
////    [self.buttom2 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
//    [self.buttom2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.buttom1 withOffset:kWidthChange(40)];
//    [self.buttom2 autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//    
//    //标签三
//    [self.biaoqianBgView addSubview:self.button3];
//    [self.button3 autoSetDimensionsToSize:CGSizeMake(kWidthChange(140), kHeightChange(40))];
//    //    [self.buttom2 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
//    [self.button3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.buttom2 withOffset:kWidthChange(40)];
//    [self.button3 autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//    
//    //标签四
//    [self.biaoqianBgView addSubview:self.button4];
//    [self.button4 autoSetDimensionsToSize:CGSizeMake(kWidthChange(140), kHeightChange(40))];
//    //    [self.buttom2 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
//    [self.button4 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.button3 withOffset:kWidthChange(40)];
//    [self.button4 autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    //房间公告背景
    [self addSubview:self.roomWarningBgView];
    [self.roomWarningBgView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.roomWarningBgView autoPinEdgeToSuperviewEdge:ALEdgeRight]
    ;
    [self.roomWarningBgView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.biaoqianBgView];
    [self.roomWarningBgView autoSetDimension:ALDimensionHeight toSize:kHeightChange(90)];
    
    //房间公告
//    [self.roomWarningBgView addSubview:self.rooWarningLbael];
//    [self.rooWarningLbael autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
//    [self.rooWarningLbael autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    //房间公告内容
//    [self addSubview:self.contentLabel];
//    [self.contentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.roomWarningBgView withOffset:kHeightChange(30)];
//    [self.contentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(40)];
//    [self.contentLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(40)];
//    [self.contentLabel autoSetDimension:ALDimensionHeight toSize:kHeightChange(300)];
    
    NSInteger baudit = [[[NSUserDefaults standardUserDefaults] objectForKey:@"baudit"] integerValue];
    if (baudit == 1) {
        [self netWorkRequestGet];
    }else{
        
//        CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
//        CGFloat h = kHeightChange(20);//用来控制button距离父视图的高
//        
//        for (int i = 0; i < arr.count; i++) {
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//            button.tag = 100 + i;
//            button.backgroundColor = [UIColor greenColor];
//            [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [button setBackgroundColor:WWColor(244, 117, 6)];
//            
//            button.layer.cornerRadius = kWidthChange(10);
//            button.layer.masksToBounds = YES;
//            button.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(24)];
//            //根据计算文字的大小
//            
//            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:kWidthChange(24)]};
//            CGFloat length = [arr[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
//            //为button赋值
//            [button setTitle:arr[i] forState:UIControlStateNormal];
//            //设置button的frame
//            button.frame = CGRectMake(kWidthChange(35) + w, h, kWidthChange(length)*2.8 , kHeightChange(50));
//            //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
//            if(kWidthChange(35) + w + length + 15 > SCREEN_WIDTH){
//                w = 0; //换行时将w置为0
//                h = h + button.frame.size.height + 10;//距离父视图也变化
//                button.frame = CGRectMake(10 + w, h, length + 15, 30);//重设button的frame
//            }
//            w = button.frame.size.width + button.frame.origin.x;
//            [self.biaoqianBgView addSubview:button];
//        }
        
    }
//    
//    [self.biaoqianBgView addSubview:self.collectionViewW];
//    [self.collectionViewW autoPinEdgesToSuperviewEdges];
    
    }


- (void)handleClick:(UIButton *)btn{
    
}


- (void)netWorkRequestGet{
    NSString *url = @"broadcast_app";
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"userId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
//    [MBProgressHUD showMessage:nil];
    [[NetWorkTool sharedTool] requestMethod:POST URL:url paraments:param finish:^(id responseObject, NSError *error) {
        NSLog(@"%@_______________________________%@",responseObject,error);
        if ([responseObject[@"ret"] isEqualToString:@"success"]) {
//            [MBProgressHUD hideHUD];
            NSString *messageString = responseObject[@"broadcast"][0][@"keyWord"];
            if (messageString.length != 0) {
                
                NSArray *arr = [messageString componentsSeparatedByString:@"_"];
                self.biaoqianArray = [arr mutableCopy];
                
            }
            
//            NSArray *arr = [self.biaoqianArray copy];
//            CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
//            CGFloat h = kHeightChange(20);//用来控制button距离父视图的高
//            
//            for (int i = 0; i < arr.count; i++) {
//                UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//                button.tag = 100 + i;
//                button.backgroundColor = [UIColor greenColor];
//                [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
//                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                [button setBackgroundColor:WWColor(244, 117, 6)];
//                
//                button.layer.cornerRadius = kWidthChange(10);
//                button.layer.masksToBounds = YES;
//                button.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(24)];
//                //根据计算文字的大小
//                
//                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:kWidthChange(24)]};
//                CGFloat length = [arr[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
//                //为button赋值
//                [button setTitle:arr[i] forState:UIControlStateNormal];
//                //设置button的frame
//                button.frame = CGRectMake(kWidthChange(35) + w, h, kWidthChange(length)*2.8 , kHeightChange(50));
//                //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
//                if(kWidthChange(35) + w + length + 15 > SCREEN_WIDTH){
//                    w = 0; //换行时将w置为0
//                    h = h + button.frame.size.height + 10;//距离父视图也变化
//                    button.frame = CGRectMake(10 + w, h, length + 15, 30);//重设button的frame
//                }
//                w = button.frame.size.width + button.frame.origin.x;
//                [self.biaoqianBgView addSubview:button];
//            }
            
            NSArray *arr = [self.biaoqianArray copy];
            [self.biaoqianBgView addSubview:self.tagView];
//            [self.collectionViewW autoPinEdgesToSuperviewEdges];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                // 初始化标签
                
                SKTag *tag = [[SKTag alloc] initWithText:arr[idx]];
                
                // 标签相对于自己容器的上左下右的距离
                
                tag.padding = UIEdgeInsetsMake(8, 15, 8, 15);
                
                // 弧度
                
                tag.cornerRadius = 8.0f;
                
                // 字体
                
                tag.font = [UIFont boldSystemFontOfSize:kWidthChange(24)];
                
                // 边框宽度
                
                tag.borderWidth = 0;
                
                // 背景
                
//                tag.bgColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
                tag.bgColor = WWColor(244, 117, 6);
                
                // 边框颜色
                
                tag.borderColor = [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
                
                // 字体颜色
                
//                tag.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1];
                tag.textColor = [UIColor whiteColor];
                // 是否可点击
                
                tag.enable = YES;
                
                // 加入到tagView
                
                [self.tagView addTag:tag];
                
            }];


            
//            self.roomInafos = responseObject[@"broadcast"][0];
            
            //            [MBProgressHUD showSuccess:@"修改成功"];
            //            WWAnchorSpaceViewController *achorSpace = [[WWAnchorSpaceViewController alloc] init];
            //            achorSpace.roomName = self.settingView.nameTextFiled.text;
            //            [self.navigationController pushViewController:achorSpace animated:YES];
        }
    }];
    
}






#pragma mark ----Getters----
//一级标题
- (NSString *)Namelevel{
    if (!_Namelevel) {
        _Namelevel = [[NSString alloc] init];
        
    }
    return _Namelevel;
}


- (SKTagView *)tagView{
    if (!_tagView) {
        _tagView = [[SKTagView alloc] init];
         // 整个tagView对应其SuperView的上左下右距离
        _tagView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
        _tagView.lineSpacing = 10;//上下之间的距离
        _tagView.interitemSpacing = 20;//item之间的距离
        // 最大宽度
        _tagView.preferredMaxLayoutWidth = 375;
        
    }
    return _tagView;
}



//- (NSMutableArray *)biaoqianArray{
//    if (!_biaoqianArray) {
//        _biaoqianArray = [[NSMutableArray alloc] init];
//    }
//    
//    return _biaoqianArray;
//}

- (UITextView *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UITextView alloc] init];
        _contentLabel.text = @"请输入房间公告";
        _contentLabel.delegate = self;
        _contentLabel.font = [UIFont systemFontOfSize:kWidthChange(24)];
        _contentLabel.textColor = WWColor(124, 124, 124);
//        _contentLabel.numberOfLines = 0;
        
    }
    return _contentLabel;
    
}

- (UILabel *)rooWarningLbael{
    if (!_rooWarningLbael) {
        _rooWarningLbael = [[UILabel alloc] init];
        _rooWarningLbael.text = @"房间公告";
        _rooWarningLbael.font = [UIFont systemFontOfSize:kWidthChange(24)];
        _rooWarningLbael.textColor = WWColor(15, 14, 14);
    }
    return _rooWarningLbael;
}

- (UIView *)roomWarningBgView{
    if (!_roomWarningBgView) {
        _roomWarningBgView = [[UIView alloc] init];
        _roomWarningBgView.backgroundColor = WWColor(245, 245, 245);
    }
    return _roomWarningBgView;
}

- (UIButton *)button4{
    if (!_button4) {
        _button4  = [[UIButton alloc] init];
        [_button4 setBackgroundColor:WWColor(244, 117, 6)];
        [_button4 setTitle:@"无语伦比" forState:UIControlStateNormal];
        _button4.layer.cornerRadius = kWidthChange(10);
        _button4.layer.masksToBounds = YES;
        _button4.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(24)];
    }
    return _button4;
}

- (UIButton *)button3{
    if (!_button3) {
        _button3  = [[UIButton alloc] init];
        [_button3 setBackgroundColor:WWColor(244, 117, 6)];
        [_button3 setTitle:@"无语伦比" forState:UIControlStateNormal];
        _button3.layer.cornerRadius = kWidthChange(10);
        _button3.layer.masksToBounds = YES;
        _button3.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(24)];
    }
    return _button3;
}

- (UIButton *)buttom2{
    if (!_buttom2) {
        _buttom2  = [[UIButton alloc] init];
        [_buttom2 setBackgroundColor:WWColor(244, 117, 6)];
        [_buttom2 setTitle:@"无语伦比" forState:UIControlStateNormal];
        _buttom2.layer.cornerRadius = kWidthChange(10);
        _buttom2.layer.masksToBounds = YES;
        _buttom2.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(24)];
        
      
    }
    return _buttom2;
}

- (UIButton *)buttom1{
    if (!_buttom1) {
        _buttom1  = [[UIButton alloc] init];
        [_buttom1 setBackgroundColor:WWColor(244, 117, 6)];
        [_buttom1 setTitle:@"无语伦比" forState:UIControlStateNormal];
        _buttom1.layer.cornerRadius = kWidthChange(10);
        _buttom1.layer.masksToBounds = YES;
        _buttom1.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(24)];
    }
    return _buttom1;
}

- (UIView *)biaoqianBgView{
    if (!_biaoqianBgView) {
        _biaoqianBgView = [[UIView alloc] init];
        _biaoqianBgView.backgroundColor = [UIColor whiteColor];
    
    }
    return _biaoqianBgView;
}

- (UIButton *)bianjiButtom{
    if (!_bianjiButtom) {
        _bianjiButtom = [[UIButton alloc] init];
        [_bianjiButtom setBackgroundImage:[UIImage imageNamed:@"修改-拷贝-2"] forState:UIControlStateNormal];
        [_bianjiButtom addTarget:self action:@selector(respondsToBianjiClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bianjiButtom;
}

- (UILabel *)cumstomLabel{
    if (!_cumstomLabel) {
        _cumstomLabel = [[UILabel alloc] init];
        _cumstomLabel.text = @"自定义标签";
        _cumstomLabel.font = [UIFont systemFontOfSize:kWidthChange(24)];
         _cumstomLabel.textColor = WWColor(15, 14, 14);
    }
    return _cumstomLabel;
}

- (UIView *)custumLabelBgView{
    if (!_custumLabelBgView) {
        _custumLabelBgView = [[UIView alloc] init];
        _custumLabelBgView.backgroundColor = WWColor(245, 245, 245);
    }
    return _custumLabelBgView;
}

- (UIView *)typeBgView{
    if (!_typeBgView) {
        _typeBgView = [[UIView alloc] init];
        _typeBgView.backgroundColor = [UIColor whiteColor];
    }
    return _typeBgView;
}

- (UITextField *)typerTextFiled{
    if (!_typerTextFiled) {
        _typerTextFiled = [[UITextField alloc] init];
        _typerTextFiled.placeholder = @"请选择分类";
        _typerTextFiled.layer.borderWidth = 0;
        _typerTextFiled.backgroundColor = [UIColor whiteColor];
        [_typerTextFiled setValue:[UIFont systemFontOfSize:kWidthChange(28)] forKeyPath:@"_placeholderLabel.font"];
        _typerTextFiled.delegate = self;
        _typerTextFiled.textAlignment = NSTextAlignmentCenter;
        
    }
    return _typerTextFiled;
}

- (UILabel *)typerLabel{
    if (!_typerLabel) {
        _typerLabel = [[UILabel alloc] init];
        _typerLabel.text = @"分类";
        _typerLabel.font = [UIFont systemFontOfSize:kWidthChange(24)];
        _typerLabel.textColor = WWColor(15, 14, 14);
    }
    return _typerLabel;
}

- (UITextField *)nameTextFiled{
    if (!_nameTextFiled) {
        _nameTextFiled = [[UITextField alloc] init];
        _nameTextFiled.placeholder = @"设置直播间名称";
        _nameTextFiled.layer.borderWidth = 0;
        _nameTextFiled.textAlignment = NSTextAlignmentCenter;
        [_nameTextFiled setValue:[UIFont systemFontOfSize:kWidthChange(28)] forKeyPath:@"_placeholderLabel.font"];
        
    }
    return _nameTextFiled;
}
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    
    //return CGRectInset(bounds, 20, 0);
    CGRect inset = CGRectMake(bounds.origin.x+50, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    return inset;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"房间名";
        _nameLabel.font = [UIFont systemFontOfSize:kWidthChange(24)];
        _nameLabel.textColor = WWColor(15, 14, 14);
    }
    return _nameLabel;
}

//
-(UIView *)nameBgView{
    if (!_nameBgView) {
        _nameBgView = [[UIView alloc] init];
        _nameBgView.backgroundColor = WWColor(245, 245, 245);
    }
    return _nameBgView;
}

@end
