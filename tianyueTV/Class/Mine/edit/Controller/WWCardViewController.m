//
//  WWCardViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/28.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWCardViewController.h"
#import "WWFilishedViewController.h"
//#import "UpYun.h"
#import "MBProgressHUD+MJ.h"
#import "WWCustomPressView.h"
//#import "UPMutUploaderManager.h"
#import "AVFile+UploadMoreFile.h"

#import "MBProgressHUD+MJ.h"
@interface WWCardViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    BOOL _choiceImage;
    BOOL _isSecondImage;
}
- (void)initializeUserInterface; /**< 初始化用户界面 */
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIView *namebgView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UIView *IDCardbgView;
@property (nonatomic,strong) UILabel *IDCardLabel;
@property (nonatomic,strong) UITextField *IDCardTextField;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *addIDimageView;//身份证正面
@property (nonatomic,strong) UIImageView *exampleImageView;//身份证正面样式图
@property (nonatomic,strong) UIImageView *addSecondImageView;//身份证背面
@property (nonatomic,strong) UIImageView *secondExampleImageView;//身份证背面样式图
@property (nonatomic,strong) UILabel *slLabel1;//示例图片
@property (nonatomic,strong) UILabel *slLabel2;//示例图片

@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) UILabel *label2;
@property (nonatomic,strong) UILabel *label3;
@property (nonatomic,strong) UILabel *label4;
@property (nonatomic,strong) UILabel *label5;

@property (nonatomic,strong) UIButton *nextButton;
@property (nonatomic,strong) WWCustomPressView *customPressView;



@end

@implementation WWCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人身份信息";
    self.view.backgroundColor = [UIColor whiteColor];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(backItemClicked1)];
//    leftItem.image = [UIImage imageNamed:@"back_black"];
//    leftItem.tintColor = [UIColor blackColor];
//    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.hidesBackButton = YES;
    [self initializeUserInterface];
    _choiceImage = NO;
    
}


- (void)respondsToNextButton:(UIButton *)sender{
    NSLog(@"下一步");
//    WWFilishedViewController *filis = [[WWFilishedViewController alloc] init];
//    [self.navigationController pushViewController:filis animated:YES];
    [self networkRequest];
//    [self.backButton removeFromSuperview];
    }

- (void)backItemClicked1{
    [self.navigationController popViewControllerAnimated:YES];
    self.backButton.hidden = YES;
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    self.backButton.hidden = NO;
}

- (void)networkRequest{

    
    if (self.nameTextField.text.length == 0 || self.IDCardTextField.text.length == 0) {
        [MBProgressHUD showError:@"名字或身份证不能为空"];
    }else if (_choiceImage == NO ){
        [MBProgressHUD showError:@"请选择图片"];
    }else if (self.IDCardTextField.text.length < 15){
        [MBProgressHUD showError:@"请输入正确的身份证"];
    }else{
        self.nextButton.userInteractionEnabled = NO;
         self.nextButton.backgroundColor = [UIColor lightGrayColor];
        self.nextButton.backgroundColor = WWColor(113, 11, 17);
        [self.view addSubview:self.customPressView];
        self.customPressView.center = self.view.center;
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = @"zswl-images";
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = @"28LU61t4/anqeXKM6sJwzx1toL4=";
//    [UPYUNConfig sharedInstance].DEFAULT_EXPIRES_IN = 1800;
        UIImage * image = self.addIDimageView.image;
        UIImage *image2 = self.addSecondImageView.image;
       

    
        
      
    __block UpYun *uy = [[UpYun alloc] init];
//        uy.uploadMethod = UPMutUPload;
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
        
        
        NSLog(@"response body %@", responseData);
        [arr addObject:responseData[@"url"]];
        if (arr.count == 2) {
//            NSString *url = @"http://www.tianyue.tv/identifyAjaxapp";
                    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                    params[@"userName"] = self.nameTextField.text;
                    params[@"identityCard"] = self.IDCardTextField.text;
                    params[@"brandType"] = @"0";
                    params[@"cardImage"] = arr[0];//backImage
                    params[@"backImage"] = arr[1];
                    params[@"user_id"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
                    NSLog(@"%@",params);
            
                    [self.customPressView removeFromSuperview];
                        [[NetWorkTool sharedTool] requestMethod:POST URL:@"identifyAjaxapp" paraments:params finish:^(id responseObject, NSError *error) {
                            NSLog(@"实名认证%@_________-----%@",responseObject,error);
                            if ([responseObject[@"ret"] isEqualToString:@"alreadyError"]) {
                                [MBProgressHUD hideHUD];
            //                    [MBProgressHUD showSuccess:@"已提交"];
                                self.nextButton.userInteractionEnabled = YES;
                                self.nextButton.backgroundColor = WWColor(211, 5, 26);
                                self.backButton.hidden = YES;
                               
                                WWFilishedViewController *filis = [[WWFilishedViewController alloc] init];
                                [self.navigationController pushViewController:filis animated:YES];
            
                            }else{
                                self.nextButton.userInteractionEnabled = YES;
                                self.nextButton.backgroundColor = WWColor(211, 5, 26);
                                
                            }
                        }];

        }
    };
    uy.failBlocker = ^(NSError * error) {
//        NSString *message = error.description;
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"message" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
        self.nextButton.userInteractionEnabled = YES;
        self.nextButton.backgroundColor = WWColor(211, 5, 26);
        [MBProgressHUD showError:@"上传失败"];
        NSLog(@"error %@", error);
    };
    uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
//        [self.customPressView setPercent:percent];
    };

 
//    [uy uploadImage:image savekey:[self getSaveKeyWith:@"png"]];
        [MBProgressHUD showMessage:@"正在上传..."];
        [uy uploadFile:image saveKey:[self getSaveKeyWith:@"png"]];
        [uy uploadFile:image2 saveKey:[self getSaveKeyWith:@"png"]];
        

    }
    
}

- (NSString * )getSaveKeyWith:(NSString *)suffix {
    /**
     *	@brief	方式1 由开发者生成saveKey
     */
    return [NSString stringWithFormat:@"/%@.%@", [self getDateString], suffix];
    /**
     *	@brief	方式2 由服务器生成saveKey
     */
//        return [NSString stringWithFormat:@"/{year}/{mon}/{filename}{.suffix}"];
    /**
     *	@brief	更多方式 参阅 http://docs.upyun.com/api/form_api/#_4
     */
}
- (NSString *)getDateString {
    NSDate *curDate = [NSDate date];//获取当前日期
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy/MM/dd"];//这里去掉 具体时间 保留日期
    NSString * curTime = [formater stringFromDate:curDate];
    curTime = [NSString stringWithFormat:@"%@/%.0f", curTime, [curDate timeIntervalSince1970]];
    return curTime;
}


#pragma mark ----initializeUserInterface---
- (void)initializeUserInterface{
    //返回按钮
    [self.navigationController.view addSubview:self.backButton];
    [self.backButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(20)+ 20];
    [self.backButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(30)];
    
    //姓名
    [self.view addSubview:self.namebgView];
    [self.namebgView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(50)+64];
    [self.namebgView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kHeightChange(20)];
    [self.namebgView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kHeightChange(20)];
    [self.namebgView autoSetDimension:ALDimensionHeight toSize:kHeightChange(70)];
    
    [self.namebgView addSubview:self.nameLabel];
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(15)];
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(15)];
    [self.nameLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(140)];
    
    [self.namebgView addSubview:self.nameTextField];
    [self.nameTextField autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.nameTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(20)];
    [self.nameTextField autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(20)];
    [self.nameTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.nameLabel];
    
    //身份证
    [self.view addSubview:self.IDCardbgView];
    [self.IDCardbgView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.namebgView withOffset:kHeightChange(22)];
    [self.IDCardbgView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kHeightChange(20)];
    [self.IDCardbgView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kHeightChange(20)];
    [self.IDCardbgView autoSetDimension:ALDimensionHeight toSize:kHeightChange(70)];
    
    [self.IDCardbgView addSubview:self.IDCardLabel];
    [self.IDCardLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.IDCardLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(15)];
    [self.IDCardLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(15)];
    [self.IDCardLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(140)];
    
    [self.IDCardbgView addSubview:self.IDCardTextField];
    [self.IDCardTextField autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.IDCardTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(20)];
    [self.IDCardTextField autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(20)];
    [self.IDCardTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.nameLabel];
    
    //证件照片
    [self.view addSubview:self.titleLabel];
    [self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.IDCardbgView withOffset:kHeightChange(28)];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    
    [self.view addSubview:self.addIDimageView];
    [self.addIDimageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.addIDimageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:kHeightChange(10)];
    [self.addIDimageView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH*0.5-kWidthChange(30), kHeightChange(260))];
    
    [self.view addSubview:self.exampleImageView];
    [self.exampleImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    [self.exampleImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:kHeightChange(10)];
    [self.exampleImageView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH*0.5-kWidthChange(30), kHeightChange(260))];
    
    //背面照片
    
    [self.view addSubview:self.addSecondImageView];
    [self.addSecondImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.addSecondImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.addIDimageView withOffset:kHeightChange(45)];
    [self.addSecondImageView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH*0.5-kWidthChange(30), kHeightChange(260))];
    
    [self.view addSubview:self.secondExampleImageView];
    [self.secondExampleImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    [self.secondExampleImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.addIDimageView withOffset:kHeightChange(45)];
    [self.secondExampleImageView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH*0.5-kWidthChange(30), kHeightChange(260))];
    
    //示例图片文字
    [self.view addSubview:self.slLabel1];
    [self.slLabel1 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.exampleImageView];
    [self.slLabel1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.exampleImageView withOffset:kHeightChange(10)];
    [self.view addSubview:self.slLabel2];
    [self.slLabel2 autoAlignAxis:ALAxisVertical toSameAxisOfView:self.secondExampleImageView];
    [self.slLabel2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.secondExampleImageView withOffset:kHeightChange(10)];
    
    //下边文字
    [self.view addSubview:self.label1];
    [self.label1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.label1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.addSecondImageView withOffset:kHeightChange(65)];
    
    [self.view addSubview:self.label5];
    [self.label5 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(30)];
    [self.label5 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.label1 withOffset:kHeightChange(35)];
//    UIView *yuan1 = [[UIView alloc] init];
//    yuan1.backgroundColor = [UIColor redColor];
//    yuan1.layer.cornerRadius = kWidthChange(4);
//    yuan1.layer.masksToBounds = YES;
//    [self.view addSubview:yuan1];
//    [yuan1 autoSetDimensionsToSize:CGSizeMake(kWidthChange(8), kWidthChange(8))];
//    [yuan1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
//    [yuan1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.label1  withOffset:kHeightChange(45)];

    
    [self.view addSubview:self.label3];
    [self.label3 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:SCREEN_WIDTH *0.5 + kWidthChange(40)];
    [self.label3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.label1 withOffset:kHeightChange(35)];
//    UIView *yuan2 = [[UIView alloc] init];
//    yuan2.backgroundColor = [UIColor redColor];
//    yuan2.layer.cornerRadius = kWidthChange(4);
//    yuan2.layer.masksToBounds = YES;
//    [self.view addSubview:yuan2];
//    [yuan2 autoSetDimensionsToSize:CGSizeMake(kWidthChange(8), kWidthChange(8))];
//    [yuan2 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
//    [yuan2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.label5  withOffset:kHeightChange(20)];
    
    [self.view addSubview:self.label2];
    [self.label2 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(30)];
    [self.label2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.label3 withOffset:kHeightChange(10)];
    
//    UIView *yuan3 = [[UIView alloc] init];
//    yuan3.backgroundColor = [UIColor redColor];
//    yuan3.layer.cornerRadius = kWidthChange(4);
//    yuan3.layer.masksToBounds = YES;
//    [self.view addSubview:yuan3];
//    [yuan3 autoSetDimensionsToSize:CGSizeMake(kWidthChange(8), kWidthChange(8))];
//    [yuan3 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
//    [yuan3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.label3  withOffset:kHeightChange(20)];
 

    [self.view addSubview:self.label4];
    [self.label4 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:SCREEN_WIDTH *0.5 + kWidthChange(40)];
    [self.label4 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.label3 withOffset:kHeightChange(10)];
    
    //下一步按钮
    [self.view addSubview:self.nextButton];
    [self.nextButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(20)];
    [self.nextButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(35)];
    [self.nextButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(35)];
    [self.nextButton autoSetDimension:ALDimensionHeight toSize:kHeightChange(80)];
    
    
    
    
}

#pragma mark ----Getters----
- (UILabel *)slLabel2{
    if (!_slLabel2) {
        _slLabel2 = [[UILabel alloc] init];
        _slLabel2.text = @"示例图片";
        _slLabel2.font = [UIFont systemFontOfSize:kWidthChange(26)];
        
    }
    return _slLabel2;
}

- (UILabel *)slLabel1{
    if (!_slLabel1) {
        _slLabel1 = [[UILabel alloc] init];
        _slLabel1.text = @"示例图片";
        _slLabel1.font = [UIFont systemFontOfSize:kWidthChange(26)];
        
    }
    return _slLabel1;
}

- (WWCustomPressView *)customPressView{
    if (!_customPressView) {
        _customPressView = [[WWCustomPressView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH *0.5, SCREEN_HEIGHT *0.5, kHeightChange(100), kWidthChange(300))];
        _customPressView.arcFinishColor = [UIColor blueColor];
        
        _customPressView.arcUnfinishColor = [UIColor blackColor];
        
        _customPressView.arcBackColor = [UIColor lightGrayColor];
        
        _customPressView.percent = 0;
    }
    return _customPressView;
}

//返回按钮
- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backItemClicked1) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

//下一步
- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] init];
        
        
//        [_nextButton setBackgroundImage:[UIImage imageNamed:@"redCornerJuxing"] forState:UIControlStateNormal];
        [_nextButton setBackgroundColor:WWColor(211, 5, 26)];
        _nextButton.layer.cornerRadius = kWidthChange(8);
        _nextButton.layer.masksToBounds = YES;
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(respondsToNextButton:) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.titleLabel.textColor = [UIColor whiteColor];
        _nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:kWidthChange(34)];
        
    }
    return _nextButton;
}

//下边文字
- (UILabel *)label1{
    if (!_label1) {
        _label1 = [[UILabel alloc] init];
        _label1.text = @"身份证照将进行人工审核";
        _label1.font = [UIFont systemFontOfSize:kWidthChange(28)];
        _label1.textColor = [UIColor blackColor];
    }
    return _label1;
}

- (UILabel *)label2{
    if (!_label2) {
        _label2 = [[UILabel alloc] init];
        _label2.text = @"完整：您的手肘应在画面内";
        _label2.textColor = WWColor(118, 118, 118);
        _label2.font = [UIFont systemFontOfSize:kWidthChange(24)];
    }
    return _label2;
}
- (UILabel *)label3{
    if (!_label3) {
        _label3 = [[UILabel alloc] init];
        _label3.text = @"真实：照片没有经过PS";
        _label3.textColor = WWColor(118, 118, 118);
        _label3.font = [UIFont systemFontOfSize:kWidthChange(24)];
    }
    return _label3;
}
- (UILabel *)label4{
    if (!_label4) {
        _label4 = [[UILabel alloc] init];
        _label4.text = @"如果有上诉不符，申请将被驳回";
        _label4.textColor = WWColor(118, 118, 118);
        _label4.font = [UIFont systemFontOfSize:kWidthChange(24)];
    }
    return _label4;
}
- (UILabel *)label5{
    if (!_label5) {
        _label5 = [[UILabel alloc] init];
        _label5.text = @"清晰：头像及身份证照片清晰可见";
        _label5.textColor = WWColor(118, 118, 118);
        _label5.font = [UIFont systemFontOfSize:kWidthChange(24)];
    }
    return _label5;
}

//证件照片
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"证件照片";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:kWidthChange(34)];
    }
    return _titleLabel;
}

- (UIImageView *)addIDimageView{
    if (!_addIDimageView) {
        _addIDimageView = [[UIImageView alloc] init];
        _addIDimageView.image = [UIImage imageNamed:@"加-1"];
        _addIDimageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToIDimageView)];
        [_addIDimageView addGestureRecognizer:gester];

    }
    return _addIDimageView;
}

- (UIImageView *)addSecondImageView{
    if (!_addSecondImageView) {
        _addSecondImageView = [[UIImageView alloc] init];
        _addSecondImageView.image = [UIImage imageNamed:@"加-1"];
        _addSecondImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToSecondImageView)];
        [_addSecondImageView addGestureRecognizer:gester];
        
    }
    return _addSecondImageView;
}


- (UIImageView *)secondExampleImageView{
    if (!_secondExampleImageView) {
        _secondExampleImageView = [[UIImageView alloc] init];
        _secondExampleImageView.image = [UIImage imageNamed:@"身份证背面"];
    }
    return _secondExampleImageView;
}

- (UIImageView *)exampleImageView{
    if (!_exampleImageView) {
        _exampleImageView = [[UIImageView alloc] init];
        _exampleImageView.image = [UIImage imageNamed:@"QQ截图20160328171759"];
    }
    return _exampleImageView;
}

//名字
- (UIView *)namebgView{
    if (!_namebgView) {
        _namebgView = [[UIView alloc] init];
        _namebgView.backgroundColor = [UIColor whiteColor];
        _namebgView.layer.borderWidth = 1.0f;
        _namebgView.layer.borderColor = WWColor(237, 237, 237).CGColor;
    }
    return _namebgView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"姓名";
        _nameLabel.font = [UIFont boldSystemFontOfSize:kWidthChange(30)];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

- (UITextField *)nameTextField{
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.placeholder = @"请在此填写你的真实姓名";
//        [_passwordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
         [_nameTextField setValue:[UIFont systemFontOfSize:kWidthChange(26)] forKeyPath:@"_placeholderLabel.font"];
        _nameTextField.layer.borderWidth = 0;
    }
    return _nameTextField;
}

//身份证
- (UIView *)IDCardbgView{
    if (!_IDCardbgView) {
        _IDCardbgView = [[UIView alloc] init];
        _IDCardbgView.backgroundColor = [UIColor whiteColor];
        _IDCardbgView.layer.borderWidth = 1.0f;
        _IDCardbgView.layer.borderColor = WWColor(237, 237, 237).CGColor;
    }
    return _IDCardbgView;
}
-(UILabel *)IDCardLabel{
    if (!_IDCardLabel) {
        _IDCardLabel = [[UILabel alloc] init];
        _IDCardLabel.text = @"身份证";
        _IDCardLabel.font = [UIFont boldSystemFontOfSize:kWidthChange(30)];
        _IDCardLabel.textColor = [UIColor blackColor];
    }
    return _IDCardLabel;
}

- (UITextField *)IDCardTextField{
    if (!_IDCardTextField) {
        _IDCardTextField = [[UITextField alloc] init];
        _IDCardTextField.placeholder = @"请输入19位身份证号码";
        _IDCardTextField.delegate = self;
        //        [_passwordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        [_IDCardTextField setValue:[UIFont systemFontOfSize:kWidthChange(26)] forKeyPath:@"_placeholderLabel.font"];
        _IDCardTextField.layer.borderWidth = 0;
    }
    return _IDCardTextField;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.IDCardTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.IDCardTextField.text.length >= 19) {
            self.IDCardTextField.text = [textField.text substringToIndex:19];
            return NO;
        }
    }
    return YES;
}

#pragma mark ----图片选择器----
- (void)respondsToSecondImageView{
    _isSecondImage = YES;
    [self chiceImage];
}



- (void)respondsToIDimageView{
    _isSecondImage =  NO;
    [self chiceImage];
}


- (void)chiceImage{
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
    if (_isSecondImage == YES) {
        self.addSecondImageView.image = image;
    }else{
        self.addIDimageView.image = image;
    }
    
    //    self.headBackImage.alpha = 1.0f;
    _choiceImage = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    _choiceImage = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}




@end
