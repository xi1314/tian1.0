//
//  WWMineFiveViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/13.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWMineFiveViewController.h"
#import "WWMineFiveTableViewCell.h"
#import "WWMineFiveModel.h"
#import "ViewController.h"
#import <ImSDK/ImSDK.h>

@interface WWMineFiveViewController ()
<UITableViewDataSource,
UITableViewDelegate>

{
    WWMineFiveModel *model;
}

- (void)initializeUserInterface;


@property (nonatomic,strong) UITableView *tableViewSet;


@property (nonatomic,strong) UIButton *quietButton;

@end

@implementation WWMineFiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = WWColor(240, 240, 240);
    
    NSArray *arr1 = [NSArray arrayWithObjects:@"非WIFI环境提醒", @"清除缓存",  nil];
    NSArray *arr2 = [[NSArray alloc] init];
    NSArray *arr = [NSArray arrayWithObjects:arr1,arr2, nil];
    model = [[WWMineFiveModel alloc] initWithArr:arr];
    [self initializeUserInterface];
}


#pragma mark - 添加约束
- (void)initializeUserInterface{
    [self.view addSubview:self.tableViewSet];
    [self.tableViewSet autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.tableViewSet autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.tableViewSet autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.tableViewSet autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    [self.view addSubview:self.quietButton];
    [self.quietButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(35)];
    [self.quietButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(35)];
    [self.quietButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(202)];
    [self.quietButton autoSetDimension:ALDimensionHeight toSize:kHeightChange(80)];
}

#pragma mark - 懒加载
- (UITableView *)tableViewSet{
    if (!_tableViewSet) {
        _tableViewSet = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableViewSet.dataSource = self;
        _tableViewSet.delegate = self;
        _tableViewSet.rowHeight = kHeightChange(85);
         [_tableViewSet registerClass:[WWMineFiveTableViewCell class] forCellReuseIdentifier:@"WWMineFiveTableViewCell"];
    }
    return _tableViewSet;
}

- (UIButton *)quietButton{
    if (!_quietButton) {
        _quietButton = [[UIButton alloc] init];
//        [_quietButton setBackgroundColor:WWColor(193, 52, 50)];
        
        [_quietButton setBackgroundImage:[UIImage imageNamed:@"redCornerJuxing"] forState:UIControlStateNormal];
        [_quietButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [_quietButton addTarget:self action:@selector(respondsGetOut:) forControlEvents:UIControlEventTouchUpInside];
        _quietButton.layer.cornerRadius = kWidthChange(10);
        _quietButton.layer.masksToBounds = YES;
    }
    return _quietButton;
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;//section头部高度
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//可选方法:返回 组个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    //组个数
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WWMineFiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWMineFiveTableViewCell"];
    if (!cell) {
        cell = [[WWMineFiveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WWMineFiveTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.rightLabel.hidden = YES;
    cell.mySwitch.tag = indexPath.row;
    if (indexPath.row > 2 || indexPath.section > 0) {
        cell.mySwitch.hidden = YES;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        cell.rightLabel.hidden = NO;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.rightLabel.hidden = NO;
        NSString *str =[NSString stringWithFormat:@"%.2f",[self filePath]];
        cell.mySwitch.hidden = YES;
        cell.rightLabel.text =[str stringByAppendingString:@"M"];
    }
    cell.wwtitleLbael.text = model.arr[indexPath.section][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tile = model.arr[indexPath.section][indexPath.row];
    
   
    if ([tile isEqualToString:@"清除缓存"]) {
        [self btnActionForUserSetting:self];
       
    }

}

#pragma mark ----Actions----
- (void)respondsGetOut:(UIButton *)sender{
    NSLog(@"退出");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定要退出吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *queding = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.tabBarController.tabBar removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"baudit"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cookies"]; // 取消自动登录
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_id"]; // 删除user_id
//        [NSUserDefaults standardUserDefaults]objectForKey:@"cookies"]
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"WIFIwarning"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"headUrl"];
        ViewController *login = [[ViewController alloc] init];
        login.navigationController.navigationBarHidden = NO;
        [self presentViewController:login animated:YES completion:nil];
//        [self.navigationController popToViewController:login animated:YES];
        [USER_Defaults removeObjectForKey:@"nickName"];
        [USER_Defaults setBool:NO forKey:@"IM_Login"]; 
        //退出腾讯sdk
        [[TIMManager sharedInstance] logout:^() {
            NSLog(@"logout succ");
        } fail:^(int code, NSString * err) {
            NSLog(@"logout fail: code=%d err=%@", code, err);
        }];
    }];
    UIAlertAction *quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:queding];
    [alert addAction:quxiao];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)backItemClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----版本更新-----
- (void)VersionButton{
    //获得发布版本的Version
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:@""] encoding:NSUTF8StringEncoding error:nil];
    if (string != nil && [string length] > 0 && [string rangeOfString:@"version"].length == 7) {
        [self checkAppUpdate:string];
    }
}

//与当前版本做比较并更新
- (void)checkAppUpdate:(NSString *)appInfo{
    // 获取当前版本
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *appInfo1 = [appInfo substringFromIndex:[appInfo rangeOfString:@"\"version\":"].location + 10];
    appInfo1 = [[appInfo1 substringToIndex:[appInfo1 rangeOfString:@","].location] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    /**
     *  判断，如果当前版本与发布的版本不相同，则进入更新。如果相等就是当前最高版本。
     */
    if (![appInfo1 isEqualToString:version]) {
        NSLog(@"新版本:%@,当前版本%@",appInfo1,version);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"新版本 %@ 已发布!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *update = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // app链接  options:<#(nonnull NSDictionary<NSString *,id> *)#> 传参数
            NSString *string = @"";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string] options:@{} completionHandler:^(BOOL success) {
                //链接打开成功
            }];
            
        }];
        [alert addAction:cancel];
        [alert addAction:update];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"" message:@"当前已是最新版本" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *know = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        [alert1 addAction:know];
        [self presentViewController:alert1 animated:YES completion:nil];
    }
}


#pragma mark ----处理cell的点击---
// 清楚缓存
- (void)btnActionForUserSetting:(id) sender {
    [self clearFile];
    NSIndexPath *indexPath = [self.tableViewSet indexPathForSelectedRow];
    WWMineFiveTableViewCell *cell = [self.tableViewSet cellForRowAtIndexPath:indexPath];
    NSString *str =[NSString stringWithFormat:@"%.2f",[self filePath]];
    cell.rightLabel.text =[str stringByAppendingString:@"M"];
}

#pragma mark ----清除缓存----
// 显示缓存大小

-( float )filePath
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    return [ self folderSizeAtPath :cachPath];
}

//1:首先我们计算一下 单个文件的大小
- ( long long ) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    return 0 ;
}

//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}

// 清理缓存
- (void)clearFile
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    NSLog ( @"cachpath = %@" , cachPath);
    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];

}

-(void)clearCachSuccess
{
    NSLog ( @" 清理成功 " );
    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0];//刷新
    [self.tableViewSet reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
}




@end
