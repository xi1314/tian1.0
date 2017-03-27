//
//  WWMineBianjiViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/13.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWMineBianjiViewController.h"
#import "WWBianjiView.h"
#import "WWBianjiTableViewCell.h"
#import "WWRealNameViewController.h"
#import "MBProgressHUD+MJ.h"

@interface WWMineBianjiViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    BOOL datePickerShowOrHiden;/* 日期选择器是否隐藏 */
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray <NSArray *> *leftDataArray;/* 左边显示数据 */
@property (nonatomic,strong) NSArray <NSArray *> *rightArray;/* 右边显示数据 */
@property (nonatomic,strong) UIPickerView *datePickerView;/* 日期选择器 */

@property (nonatomic,strong) NSDictionary *cityNames;/* plist文件信息 */
@property (nonatomic,strong) NSArray *provinces;/* 所有省份 */
@property (nonatomic,strong) NSArray *cities;/* 所有城市 */
@property (nonatomic,strong) NSString *city;/* 城市 */
@property (nonatomic,strong) NSString *province;/* 省份 */
@property (nonatomic,strong) UIView *topDateView;
@property (nonatomic,strong) UIButton *wanchengButton;/* 完成按钮 */
@property (nonatomic,strong) WWBianjiView *bianjiView;/* 自定义编辑视图 */



@end

@implementation WWMineBianjiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    datePickerShowOrHiden = NO;
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bianjiView];
    __weak typeof(self) ws = self;
    self.bianjiView.BackButtonHandler = ^(){
        [ws BackButtonClicked];
    };
    self.bianjiView.ChoiceHeadImageHandler = ^(){
        [ws ChoiceHeadImageHandler];
    };
    
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bianjiView];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    NSLog(@"城市数据%@",self.cityNames);
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hiddenDatePickerView];
}

#pragma mark ----UITableViewDataSource && UITableViewDelegate----
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WWBianjiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWBianjiTableViewCell"];
    if (!cell) {
        cell = [[WWBianjiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WWBianjiTableViewCell"];
    }
    cell.rightLabel.text = self.rightArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        cell.rightLabel.textColor = [UIColor redColor];
        NSString *bcard = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"bCard"];
        NSInteger bcar = [bcard integerValue];
        if (bcar == 2) {
//            [MBProgressHUD showMessage:@"已提交审核"];
            cell.rightLabel.text = @"已提交";
            
        }else if (bcar == 1){
//            [MBProgressHUD showMessage:@"你已经实名认证"];
             cell.rightLabel.text = @"已认证";
        }else{
//            [self realName];
            cell.rightLabel.text = @"未认证";
        }
    }else{
        cell.rightLabel.textColor =  WWColor(162, 162, 162);
    }
    
    cell.leftLabel.text = self.leftDataArray[indexPath.section][indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.leftDataArray[section].count;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    //组个数
    return self.leftDataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;//section头部高度
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tile = self.leftDataArray[indexPath.section][indexPath.row];
    WWBianjiTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    
    
    
    if ([tile isEqualToString:@"实名认证"]) {
        
        NSString *bcard = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"bCard"];
        NSInteger bcar = [bcard integerValue];
        if (bcar == 2) {
            
            [MBProgressHUD showSuccess:@"已提交审核"];
            
            
        }else if (bcar == 1){
            [MBProgressHUD showSuccess:@"你已经实名认证"];
            
        }else{
            [self realName];
        }
        
    }
    if ([tile isEqualToString:@"性别"]) {
        [self sexAlertChoice:cell];
        
    }
    if ([tile isEqualToString:@"地区"]) {
        if (datePickerShowOrHiden == NO) {
            [self showDatePickerView];
        }else{
            [self hiddenDatePickerView];
        }
        
//        [self.datePickerView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
//        [self.datePickerView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
//        [self.datePickerView autoPinEdgeToSuperviewEdge:ALEdgeRight];
//        [self.datePickerView autoSetDimension:ALDimensionHeight toSize:kHeightChange(300)];
    }
}


#pragma mark ----Getters----
- (NSArray<NSArray *> *)rightArray{
    if (!_rightArray) {
        NSArray *array1 = [[NSArray alloc] initWithObjects:@"未认证", nil];
        NSArray *array2 = [[NSArray alloc] initWithObjects:@"德玛西亚",@"18",@"女", nil];
        NSArray *array3 = [[NSArray alloc] initWithObjects:@"重庆",@"雕刻", nil];
        _rightArray = [[NSArray alloc] initWithObjects:array1,array2,array3, nil];
    }
    return _rightArray;
}

- (NSArray *)leftDataArray{
    if (!_leftDataArray) {
        NSArray *array1 = [[NSArray alloc] initWithObjects:@"实名认证", nil];
        NSArray *array2 = [[NSArray alloc] initWithObjects:@"姓名",@"年龄",@"性别", nil];
        NSArray *array3 = [[NSArray alloc] initWithObjects:@"地区",@"所属行业", nil];
        _leftDataArray = [[NSArray alloc] initWithObjects:array1,array2,array3, nil];
    }
    return _leftDataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[WWBianjiTableViewCell class] forCellReuseIdentifier:@"WWBianjiTableViewCell"];
        _tableView.rowHeight = kHeightChange(80);
    }
    return _tableView;
}

- (WWBianjiView *)bianjiView{
    if (!_bianjiView) {
        _bianjiView = [[WWBianjiView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeightChange(470))];
    }
    return _bianjiView;
}

#pragma mark ----Actios----
- (void)realName{
  
    WWRealNameViewController *realnameVC = [[WWRealNameViewController alloc] init];
    [self.navigationController pushViewController:realnameVC animated:YES];
}


- (void)ChoiceHeadImageHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择图片来源" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        //        [self presentModalViewController:pickerImage animated:YES];
        [self presentViewController:pickerImage animated:YES completion:nil];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        //        [self presentModalViewController:picker animated:YES];//进入照相界面
        [self presentViewController:picker animated:YES completion:nil];

    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:cancel];
     [self presentViewController: alert animated:YES completion:nil];
//    [self.navigationController pushViewController:alert animated:YES];
}

#pragma mark -----UINavigationControllerDelegate && UIImagePickerControllerDelegate----
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.bianjiView.headImages.image = image;
    self.bianjiView.bigHeadView.image = image;
//    self.headBackImage.alpha = 1.0f;
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.navigationController.navigationBarHidden = YES;
    
}


- (void)BackButtonClicked{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----性别选择器----
- (void)sexAlertChoice:(WWBianjiTableViewCell *)cell{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择性别" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *boyAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cell.rightLabel.text = @"男";
    }];
    UIAlertAction *girlAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        cell.rightLabel.text = @"女";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:boyAction];
    [alert addAction:girlAction];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
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
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cityData" ofType:@"plist"];
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
    [self.view addSubview:self.datePickerView];
    [self.view addSubview:self.topDateView];
       ;
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
    NSLog(@"删除了datePickerView");
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
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    WWBianjiTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (component == 0) {
        
        //重新加载第二列的数据
        [pickerView reloadComponent:1];
        //让第二列归位
        [pickerView selectRow:0 inComponent:1 animated:YES];
        self.province = self.provinces[row];
         NSLog(@"省份：%@",self.provinces[row]);
       
        cell.rightLabel.text = self.provinces[row];
        //获取当前选中cell
//        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        
    }else{
        self.city = self.cities[row];
        NSLog(@"城市：%@",self.cities[row]);
        if (self.province) {
            if ([self.cities[row] isEqualToString:@"不限"]) {
                cell.rightLabel.text = self.province;
            }else{
                cell.rightLabel.text = [@"" stringByAppendingFormat:@"%@-%@",self.province,self.city];
            }
            
        }
    }
}



@end
