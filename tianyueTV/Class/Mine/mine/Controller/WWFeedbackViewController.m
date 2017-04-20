//
//  WWFeedbackViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/1/20.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "WWFeedbackViewController.h"
#import "MBProgressHUD+MJ.h"
#import "MineViewController.h"
@class MineViewController;
@interface WWFeedbackViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UITextView *feedbackView;
@property (nonatomic,strong) UIButton *quedingButton;


@end

@implementation WWFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.feedbackView];
    /*
    [self.feedbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(kHeightChange(150)+64);
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kWidthChange(500), kHeightChange(300)));
    }];
     */
    [self.view addSubview:self.quedingButton];
    /*
    [self.quedingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(kHeightChange(-400));
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
    }];
     */
//    [self.quedingButton sizeToFit];
    
}


- (void)respondsToqueding:(UIButton *)sender{
    if ([self.feedbackView.text isEqualToString:@"请输入反馈信息"] || self.feedbackView.text.length == 0) {
        [MBProgressHUD showError:@"请输入反馈信息"];
    }else{
        [MBProgressHUD showMessage:nil];
//        NSString *URLString = @"http://192.168.0.88:8080/app_feedback";
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        param[@"userId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        param[@"feedback_canten"] = self.feedbackView.text;
        param[@"ios_or_anzuo"] = @"2";
        [[NetWorkTool sharedTool] requestMethod:POST URL:@"app_feedback" paraments:param finish:^(id responseObject, NSError *error) {
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"感谢您的反馈"];
            
        }];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"请输入反馈信息"]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请输入反馈信息";
    }
}

#pragma mark --- Getters---
- (UIButton *)quedingButton{
    if (!_quedingButton) {
        _quedingButton = [[UIButton alloc] init];
        _quedingButton.frame = CGRectMake(0, SCREEN_HEIGHT - kHeightChange(400) - 40, 40 * 900 / 110, 40);
        _quedingButton.center = CGPointMake(SCREEN_WIDTH/2.0f, _quedingButton.centerY);
    
        [_quedingButton setTitle:@"确定" forState:UIControlStateNormal];
        _quedingButton.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(38)];
        [_quedingButton setBackgroundImage:[UIImage imageNamed:@"redCornerJuxing"] forState:UIControlStateNormal];
        [_quedingButton addTarget:self action:@selector(respondsToqueding:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quedingButton;
}

-(UITextView *)feedbackView{
    if (!_feedbackView) {
        _feedbackView = [[UITextView alloc] initWithFrame:CGRectMake(0, kHeightChange(150)+64, kWidthChange(500), kHeightChange(300))];
        _feedbackView.center = CGPointMake(SCREEN_WIDTH/2.0f, _feedbackView.centerY);
        _feedbackView.delegate = self;
        _feedbackView.text = @"请输入反馈信息";
        _feedbackView.backgroundColor = [UIColor lightGrayColor];
        _feedbackView.textColor = [UIColor whiteColor];
        _feedbackView.font = [UIFont systemFontOfSize:kWidthChange(30)];
        _feedbackView.allowsEditingTextAttributes = YES;
        

        
    }
    return _feedbackView;
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
