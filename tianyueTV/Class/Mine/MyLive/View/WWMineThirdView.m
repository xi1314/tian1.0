//
//  WWMineThirdView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/28.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWMineThirdView.h"
#import "MineThirdTableViewCell.h"
@interface WWMineThirdView()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSInteger btnsTag;
}
@property (nonatomic,strong) UILabel *titleRoomLabel;/* 类型 */
@property (nonatomic,strong) UILabel *typerRoomLabel;/* 分类 */
@property (nonatomic,strong) UIView *headbgView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray <UIButton *>*buttonsArray;



@end

@implementation WWMineThirdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WWColor(246, 244, 244);
//        self.backgroundColor = [UIColor lightGrayColor];
//        [self netWorkRequest];
        [self addPureLaout];
        btnsTag = 0;
    }
    return self;
}

- (void)respondsToZhankai:(UIButton *)sender{
    NSLog(@"WWMineThirdView展开");
}

#pragma mark ----UITableViewDataSource && UITableViewDelegate----
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineThirdTableViewCell"];
    if (!cell) {
       
            cell = [[MineThirdTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MineThirdTableViewCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    int a = ceil([self.dataSource[indexPath.row] count]/3.0);
//    NSLog(@"%f",[self.dataSource[indexPath.row] count]/3.0);
    int num = 0;
    for (int i = 0; i < a; i ++) {

        for (int j = 0; j < 3; j ++) {
            num ++;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kHeightChange(110) + j *  kHeightChange(204), kWidthChange(77) + i * kWidthChange(80), kWidthChange(120), kHeightChange(50))];
            btn.layer.borderWidth = kWidthChange(2);
            btn.layer.borderColor = WWColor(208, 206, 206).CGColor;
            btn.backgroundColor = WWColor(246, 244, 244);
            //            btn.backgroundColor = [UIColor greenColor];
            [btn setTitleColor:WWColor(149, 145, 145) forState:UIControlStateNormal];
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            btn.tag = btnsTag +1000;
            [btn addTarget:self action:@selector(respondsToBtnsClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            NSLog(@"%ld",(long)btnsTag);
           
           
            if (num > self.dataSource[indexPath.row].count) {
                
//                [cell addSubview:imageView];
//                btn.hidden = YES;
                break;
            }else{
                NSLog(@"%ld",(long)indexPath.section);
                
                [btn setTitle:self.dataSource[indexPath.row][num-1] forState:UIControlStateNormal];
                
                
                btnsTag ++;
                [cell addSubview:btn];
                [self.buttonsArray addObject:btn];
            }
//            [self.buttonsArray addObject:btn];
            
            
            
        }
    }
    
    
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 3;
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


        int a = ceil(self.dataSource[indexPath.row].count/3.0);
    NSLog(@"self.dataSource[indexPath.row].count%lu",(unsigned long)self.dataSource[indexPath.row].count);
    NSLog(@"qwerewqwerwqwe%d",a);
        return kHeightChange(80) * a + kHeightChange(90);

}

- (void)respondsToBtnsClicked:(UIButton *)sender{
//     sender.selected = !sender.selected;
    for (int i = 0; i < self.buttonsArray.count; i ++) {
        
        if (self.buttonsArray[i].tag == sender.tag) {
            sender.selected = YES;
            sender.layer.borderColor = WWColor(204, 102, 106).CGColor;
            [sender setTitleColor:WWColor(204, 102, 106) forState:UIControlStateNormal];
            self.typerTextFiled.text = sender.titleLabel.text;
        }else{
            self.buttonsArray[i].layer.borderColor = WWColor(208, 206, 206).CGColor;
            [self.buttonsArray[i] setTitleColor:WWColor(149, 145, 145) forState:UIControlStateNormal];

        }
    }
   
//    if (sender.selected == YES) {
//        sender.layer.borderColor = WWColor(204, 102, 106).CGColor;
//        [sender setTitleColor:WWColor(204, 102, 106) forState:UIControlStateNormal];
//    }else{
//        sender.layer.borderColor = WWColor(208, 206, 206).CGColor;
//        [sender setTitleColor:WWColor(149, 145, 145) forState:UIControlStateNormal];
//    }
}


#pragma mark -----添加约束-----

- (void)addPureLaout{
    //上面部分的背景
    [self addSubview:self.headbgView];
    [self.headbgView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(20) + 64];
    [self.headbgView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.headbgView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.headbgView autoSetDimension:ALDimensionHeight toSize:kHeightChange(180)];
    
    [self.headbgView addSubview:self.lineView];
    [self.lineView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(10)];
    [self.lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(10)];
    [self.lineView autoSetDimension:ALDimensionHeight toSize:kHeightChange(2)];
    
    [self.headbgView addSubview:self.titleRoomLabel];
    [self.titleRoomLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(15)];
    [self.titleRoomLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kWidthChange(30)];
    [self.titleRoomLabel autoSetDimensionsToSize:CGSizeMake(kWidthChange(135), kHeightChange(35))];
    
    [self.headbgView addSubview:self.typerRoomLabel];
    [self.typerRoomLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(15)];
    [self.typerRoomLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kWidthChange(30)];
    [self.typerRoomLabel autoSetDimensionsToSize:CGSizeMake(kWidthChange(135), kHeightChange(35))];
    
    [self.headbgView addSubview:self.titleTextFiled];
    [self.titleTextFiled autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kWidthChange(30)];
    [self.titleTextFiled autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.titleRoomLabel withOffset:kWidthChange(53)];
    [self.titleTextFiled autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.titleTextFiled autoSetDimension:ALDimensionHeight toSize:kHeightChange(35)];
    
    [self.headbgView addSubview:self.typerTextFiled];
    [self.typerTextFiled autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kWidthChange(30)];
    [self.typerTextFiled autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.typerRoomLabel withOffset:kWidthChange(53)];
    [self.typerTextFiled autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(100)];
    [self.typerTextFiled autoSetDimension:ALDimensionHeight toSize:kHeightChange(35)];
    
    [self addSubview:self.rightButton];
    [self.rightButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(10)];
    [self.rightButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(30)];
    [self.rightButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(50), kWidthChange(50))];
    
    //分类按钮
    [self addSubview:self.tableView];
    [self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.headbgView];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom];

}


#pragma mark ----Getters----
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        NSArray *array1 = [[NSArray alloc] initWithObjects:@"陶器",@"木工",@"竹艺",@"铁艺",@"皮具",@"陶器",@"木工",@"竹艺",@"铁艺",@"皮具", nil];
        NSArray *array2 = [[NSArray alloc] initWithObjects:@"陶器",@"木工",@"竹艺",@"铁艺",@"当代艺术",@"创意书画",@"素描彩铅", nil];
        NSArray *array3 = [[NSArray alloc] initWithObjects:@"陶器",@"木工",@"竹艺",@"铁艺",@"当代艺术",@"创意书画",@"素描彩铅",@"木工",@"竹艺",@"铁艺",@"当代艺术",@"创意书画", nil];
        _dataSource = [[NSMutableArray alloc] initWithObjects:array1,array2,array3, nil];
    }
    return _dataSource;
}

- (NSMutableArray<UIButton *> *)buttonsArray{
    if (!_buttonsArray) {
        _buttonsArray  = [[NSMutableArray alloc] init];
    }
    return _buttonsArray;
}

//taibelview
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[MineThirdTableViewCell class] forCellReuseIdentifier:@"MineThirdTableViewCell"];
        
    }
    return _tableView;
}

//右侧展开按钮
- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(respondsToZhankai:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

//两个输入框
- (UITextField *)typerTextFiled{
    if (!_typerTextFiled) {
        _typerTextFiled = [[UITextField alloc] init];
        
        _typerTextFiled.enabled = NO;
        _typerTextFiled.layer.borderWidth = 0;
    }
    return _typerTextFiled;
}

- (UITextField *)titleTextFiled{
    if (!_titleTextFiled) {
        _titleTextFiled = [[UITextField alloc] init];
        _titleTextFiled.placeholder = @"最大不超过12个字";
        _titleTextFiled.layer.borderWidth = 0;
        _titleTextFiled.backgroundColor = [UIColor whiteColor];
        _titleTextFiled.delegate = self;
    }
    return _titleTextFiled;
}

- (UILabel *)titleRoomLabel{
    if (!_titleRoomLabel) {
        _titleRoomLabel = [[UILabel alloc] init];
        _titleRoomLabel.text = @"房间标题";
        _titleRoomLabel.textColor = [UIColor blackColor];
        _titleRoomLabel.font = [UIFont systemFontOfSize:kWidthChange(30)];
        
    }
    return _titleRoomLabel;
}

- (UILabel *)typerRoomLabel{
    if (!_typerRoomLabel) {
        _typerRoomLabel = [[UILabel alloc] init];
        _typerRoomLabel.text = @"所属分类";
//        _typerRoomLabel.enabled = NO;
        _typerRoomLabel.textColor = [UIColor blackColor];
        _typerRoomLabel.font = [UIFont systemFontOfSize:kWidthChange(28)];
        
    }
    return _typerRoomLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = WWColor(246, 244, 244);
    }
    return _lineView;
}

- (UIView *)headbgView{
    if (!_headbgView) {
        _headbgView = [[UIView alloc] init];
        _headbgView.backgroundColor = [UIColor whiteColor];
        
    }
    return _headbgView;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.titleTextFiled) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.titleTextFiled.text.length >= 12) {
            self.titleTextFiled.text = [textField.text substringToIndex:12];
            return NO;
        }
    }
    return YES;
}

- (void)netWorkRequest{
//    NSString *url = @"http://www.tianyue.tv/Classifiedcataloguemobile";
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"Classifiedcataloguemobile" paraments:nil finish:^(id responseObject, NSError *error) {
        NSLog(@"%@,!!!!!!!!!!!!!!!%@",responseObject,error);
        NSLog(@"%@",responseObject[@"bctype"][0][@"typeName"]);
        NSArray *arr1 = [[NSArray alloc] initWithObjects:responseObject[@"bctype"][0][@"typeName"],responseObject[@"bctype1"][0][@"typeName"],responseObject[@"bctype2"][0][@"typeName"],responseObject[@"bctype3"][0][@"typeName"], nil];
        
        NSMutableArray *arr2 = [[NSMutableArray alloc] init];
        NSMutableArray *arr3 = [[NSMutableArray alloc] init];
        NSMutableArray *arr4 = [[NSMutableArray alloc] init];
        NSMutableArray *arr5 = [[NSMutableArray alloc] init];
        
        
        for (NSDictionary *dic in responseObject[@"bctypeList"]) {
            [arr2 addObject:dic[@"typeName"]];
        }
        for (NSDictionary *dic in responseObject[@"bctypeList1"]) {
            [arr3 addObject:dic[@"typeName"]];
        }
        for (NSDictionary *dic in responseObject[@"bctypeList2"]) {
            [arr4 addObject:dic[@"typeName"]];
        }
        for (NSDictionary *dic in responseObject[@"bctypeList3"]) {
            [arr5 addObject:dic[@"typeName"]];
        }
        NSLog(@"qqqqqqqq%@",responseObject[@"bctypeList3"]);
        NSMutableArray *arra = [[NSMutableArray alloc] initWithObjects:arr2,arr3,arr4,arr5, nil];
        self.dataSource = arra;
        NSLog(@"%@",self.dataSource);
        [self.tableView reloadData];
        
      
    }];
}

@end
