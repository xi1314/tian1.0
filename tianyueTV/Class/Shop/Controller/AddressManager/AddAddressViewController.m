//
//  AddAddressViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/15.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "AddAddressViewController.h"
#import "ShopHandle.h"

// picker的高度
static CGFloat pickerHeight = 200;

// 指示view高度
static CGFloat indicateHeight = 40;

@interface AddAddressViewController ()
<UIPickerViewDelegate,
UIPickerViewDataSource>

// 名字
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

// 电话
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

// 详细地址
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

// 选择地区
@property (weak, nonatomic) IBOutlet UIButton *cityButton;

// 地区选择区
@property (strong, nonatomic) UIPickerView *pickerView;

// picker 操作栏
@property (strong, nonatomic) UIView *indicateView;

// 取消
@property (strong, nonatomic) UIButton *cancelButton;

// 确认
@property (strong, nonatomic) UIButton *sureButton;


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
    }
}

- (void)initilizeUserInterface {
    self.title = @"添加地址";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"向左(5)"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToBackItem:)];
    self.navigationItem.leftBarButtonItem = backItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(respondsToRightItem:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [self.indicateView addSubview:self.cancelButton];
    [self.indicateView addSubview:self.sureButton];
    
    [self.cityButton addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -- Button method
//返回
- (void)respondsToBackItem:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//确认
- (void)respondsToRightItem:(UIBarButtonItem *)sender {
    [MBProgressHUD showMessage:nil];
    @weakify(self);
    if (self.dataModel) { // 编辑信息
        [ShopHandle requestForEditAddressWithUser:USER_ID addressID:self.dataModel.ID name:self.nameTextField.text phone:self.phoneTextField.text province:@"重庆市" city:@"九龙坡区" address:self.addressTextView.text zipcode:@"40000" completeBlock:^(id respondsObject, NSError *error) {
            @strongify(self);
            [MBProgressHUD hideHUD];
            if (respondsObject) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [MBProgressHUD showError:@"编辑失败"];
            }
        }];
    } else { // 新增信息
        [ShopHandle requestForAddNewAddressWithUser:USER_ID name:self.nameTextField.text phone:self.phoneTextField.text province:@"重庆市" city:@"九龙坡区" address:self.addressTextView.text zipcode:@"400030" completeBlock:^(id respondsObject, NSError *error) {
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

- (void)selectCity:(UITextField *)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.baseMaskView];
//    [self.baseMaskView ]
    [self.baseMaskView addSubview:self.pickerView];
    [self.baseMaskView addSubview:self.indicateView];
    [UIView animateWithDuration:0.3 animations:^{
        self.indicateView.frame = CGRectMake(0, SCREEN_HEIGHT-indicateHeight-pickerHeight, SCREEN_WIDTH, indicateHeight);
        self.pickerView.frame = CGRectMake(0, CGRectGetMaxY(self.indicateView.frame), SCREEN_WIDTH, pickerHeight);
    }];
}


#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
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
    }
    return _sureButton;
}

@end
