//
//  AddAddressViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/15.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "AddAddressViewController.h"
#import "ShopHandle.h"
#import "TianyueTools.h"

// picker的高度
static CGFloat pickerHeight = 200;

// 指示view高度
static CGFloat indicateHeight = 40;

@interface AddAddressViewController ()
<UIPickerViewDelegate,
UIPickerViewDataSource,
UITextViewDelegate>

// 名字
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

// 电话
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

// 详细地址
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

// 选择地区
@property (weak, nonatomic) IBOutlet UIButton *cityButton;

// 邮编
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

// 占位label
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

// 地区选择区
@property (strong, nonatomic) UIPickerView *pickerView;

// picker 操作栏
@property (strong, nonatomic) UIView *indicateView;

// 取消
@property (strong, nonatomic) UIButton *cancelButton;

// 确认
@property (strong, nonatomic) UIButton *sureButton;

// 省
@property (strong, nonatomic) NSArray *provinceData;

// 市
@property (strong, nonatomic) NSArray *cityData;

// 区
@property (strong, nonatomic) NSArray *regionData;

// 省
@property (copy, nonatomic) NSString *province;

// 市
@property (copy, nonatomic) NSString *city;

// 区
@property (copy, nonatomic) NSString *region;

// 地区数据
@property (strong, nonatomic) NSDictionary *dataDic;

// 省
@property (strong, nonatomic) NSDictionary *provinceDic;

// 省ID数组
@property (strong, nonatomic) NSArray *provinceCodeArr;

// 市
@property (strong, nonatomic) NSDictionary *cityDic;

// 区
@property (strong, nonatomic) NSDictionary *regionDic;

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initilizeDatasource];
    [self initilizeUserInterface];
}

#pragma mark -- Init method
- (void)initilizeDatasource {
    if (self.dataModel) {
        self.nameTextField.text = self.dataModel.name;
        self.phoneTextField.text = self.dataModel.telephone;
        self.addressTextView.text = self.dataModel.address;
        self.codeTextField.text = self.dataModel.zipCode;
        [self.cityButton setTitle:[NSString stringWithFormat:@"%@%@%@", self.dataModel.provinceName, self.dataModel.cityName, self.dataModel.area] forState:UIControlStateNormal];
    }
}

- (void)initilizeUserInterface {
    self.title = @"添加地址";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"向左(5)"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToBackItem:)];
    self.navigationItem.leftBarButtonItem = backItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(respondsToRightItem:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.addressTextView.delegate = self;
    [self.indicateView addSubview:self.cancelButton];
    [self.indicateView addSubview:self.sureButton];
    
    [self.cityButton addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)hiddenBaseMaskView {
    [self dismissPickerViewAnmation];
}

#pragma mark -- Button method
//返回
- (void)respondsToBackItem:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//确认
- (void)respondsToRightItem:(UIBarButtonItem *)sender {
    if (self.nameTextField.text.length == 0) {
        [MBProgressHUD showError:@"请输入收货人"];
        return;
    } else if (![TianyueTools isMobileNumber:self.phoneTextField.text]) {
        [MBProgressHUD showError:@"联系电话格式有误"];
        return;
    } else if ([self.cityButton.titleLabel.text isEqualToString:@"选择地区"]) {
        [MBProgressHUD showError:@"请选择地区"];
        return;
    } else if (self.codeTextField.text.length != 6) {
        [MBProgressHUD showError:@"输入邮编有误"];
        return;
    } else if (self.addressTextView.text.length == 0) {
        [MBProgressHUD showError:@"请输入详细地址"];
        return;
    }
    
    [MBProgressHUD showMessage:nil];
    @weakify(self);
    if (self.dataModel) { // 编辑信息
        [ShopHandle requestForEditAddressWithUser:USER_ID addressID:self.dataModel.ID name:self.nameTextField.text phone:self.phoneTextField.text province:_province city:_city area:_region address:self.addressTextView.text zipcode:self.codeTextField.text completeBlock:^(id respondsObject, NSError *error) {
            @strongify(self);
            [MBProgressHUD hideHUD];
            if (respondsObject) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [MBProgressHUD showError:@"编辑失败"];
            }
        }];
    } else { // 新增信息
        [ShopHandle requestForAddNewAddressWithUser:USER_ID name:self.nameTextField.text phone:self.phoneTextField.text province:_province city:_city area:_region address:self.addressTextView.text zipcode:self.codeTextField.text completeBlock:^(id respondsObject, NSError *error) {
            @strongify(self);
            [MBProgressHUD hideHUD];
            NSLog(@"respondsObject.. %@ %@",respondsObject,error);
            if (respondsObject) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [MBProgressHUD showError:@"添加失败"];
            }
        }];
    }
}

// 删除地址
- (IBAction)deleteAddress_action:(UIButton *)sender {
    if (!self.dataModel) {
        return;
    }
    [MBProgressHUD showMessage:nil];
    @weakify(self);
    if (self.dataModel) {
        [ShopHandle requestForDeleteAddressWithUser:USER_ID addressID:self.dataModel.ID completeBlock:^(id respondsObject, NSError *error) {
            @strongify(self);
            if (respondsObject) {
                [MBProgressHUD showSuccess:@"删除成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [MBProgressHUD showError:@"删除失败"];
            }
        }];
    }
}

// 地区选择框
- (void)selectCity:(UITextField *)sender {
    [self showPickerViewAnmation];
    
    NSString *areaJsonPath=[[NSBundle mainBundle]pathForResource:@"area.json" ofType:nil];
    NSString *areaList=[NSString stringWithContentsOfFile:areaJsonPath encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData=[areaList dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    _dataDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    NSDictionary *province = _dataDic[@"province"];
    _provinceData = province.allValues;
    _provinceCodeArr = province.allKeys;
    [self.pickerView reloadComponent:0];
    _province = _provinceData[0];
    
    _cityDic = _dataDic[@"city"];
    _cityData = _cityDic[_provinceCodeArr[0]];
    [self.pickerView reloadComponent:1];
    _city = _cityData[0][0];
    
    _regionDic = _dataDic[@"area"];
    NSString *regionCode = _cityData[0][1];
    _regionData = _regionDic[regionCode];
    [self.pickerView reloadComponent:2];
    _region = _regionData[0][0];
}

// 确认地区选择
- (void)respondsToSureButton:(UIButton *)sender {
    [self dismissPickerViewAnmation];
    NSString *string = [NSString stringWithFormat:@"%@%@%@",_province,_city,_region];
    [self.cityButton setTitle:string forState:UIControlStateNormal];
}


#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _provinceData.count;
    } else if (component == 1) {
        return _cityData.count;
    } else if (component == 2) {
        return _regionData.count;
    }
    return 3;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 30)];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    [myView addSubview:label];
    if (component == 0) {
        label.text = _provinceData[row];
    } else if (component == 1) {
        label.text = _cityData[row][0];
    } else if (component == 2) {
        label.text = _regionData[row][0];
    }
    return myView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _cityData = _cityDic[_provinceCodeArr[row]];
        [self.pickerView reloadComponent:1];
        
        NSString *regionCode = _cityData[0][1];
        _regionData = _regionDic[regionCode];
        [self.pickerView reloadComponent:2];
        
        _province = _provinceData[row];
        _city = _cityData[0][0];
        _region = _regionData[0][0];
        
    } else if (component == 1) {
        NSString *regionCode = _cityData[row][1];
        _regionData = _regionDic[regionCode];
        [self.pickerView reloadComponent:2];
        
        _city = _cityData[row][0];
        _region = _regionData[0][0];
        
    } else if (component == 2) {
        _region = _regionData[row][0];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.placeHolderLabel.hidden = YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
    }
    return YES;
}

#pragma mark - Pravite method
// 弹出地区选择框
- (void)showPickerViewAnmation {
    [self.view endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.baseMaskView];
    [self.baseMaskView addSubview:self.pickerView];
    [self.baseMaskView addSubview:self.indicateView];
    [UIView animateWithDuration:0.3 animations:^{
        self.indicateView.frame = CGRectMake(0, SCREEN_HEIGHT-indicateHeight-pickerHeight, SCREEN_WIDTH, indicateHeight);
        self.pickerView.frame = CGRectMake(0, CGRectGetMaxY(self.indicateView.frame), SCREEN_WIDTH, pickerHeight);
    }];
}

// 回收地区选择框
- (void)dismissPickerViewAnmation {
    [UIView animateWithDuration:0.3 animations:^{
        self.indicateView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, indicateHeight);
        self.pickerView.frame = CGRectMake(0, CGRectGetMaxY(self.indicateView.frame), SCREEN_WIDTH, pickerHeight);
    } completion:^(BOOL finished) {
        [self.baseMaskView removeAllSubviews];
        [self.baseMaskView removeFromSuperview];
    }];
}

#pragma mark - Getter method
- (UIView *)indicateView {
    if (!_indicateView) {
        _indicateView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, indicateHeight)];
        //        _indicateView.backgroundColor = WWColor(245, 245, 245);
        _indicateView.backgroundColor = [UIColor whiteColor];
        // 添加分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, indicateHeight-1, SCREEN_WIDTH, 1)];
        line.backgroundColor = LINE_COLOR;
        [_indicateView addSubview:line];
    }
    return _indicateView;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.indicateView.frame), SCREEN_WIDTH, pickerHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, 70, indicateHeight);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:WWColor(0, 122, 255) forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton addTarget:self action:@selector(dismissPickerViewAnmation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(SCREEN_WIDTH - 80, 0, 70, indicateHeight);
        [_sureButton setTitle:@"完成" forState:UIControlStateNormal];
        [_sureButton setTitleColor:WWColor(0, 122, 255) forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureButton addTarget:self action:@selector(respondsToSureButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

@end
