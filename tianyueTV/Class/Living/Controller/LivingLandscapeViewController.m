//
//  LivingLandscapeViewController.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/5/5.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "LivingLandscapeViewController.h"

@interface LivingLandscapeViewController ()

@property (weak, nonatomic) IBOutlet UIView *view_top;

@property (weak, nonatomic) IBOutlet UIView *view_bottom;

@property (weak, nonatomic) IBOutlet UITextField *textF_input;

@end

@implementation LivingLandscapeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
    self.view_top.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    self.view_bottom.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    self.textF_input.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f];
    [self.textF_input setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"]; // 修改placeholder颜色

}

- (IBAction)btn_back:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.view_top.alpha == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view_top.alpha = 0;
            self.view_bottom.alpha = 0;
        }];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            self.view_top.alpha = 1;
            self.view_bottom.alpha = 1;
        }];
    }
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
