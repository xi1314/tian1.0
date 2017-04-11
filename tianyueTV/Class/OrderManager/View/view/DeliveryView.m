//
//  DeliveryView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/22.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "DeliveryView.h"

@interface DeliveryView()
<UITableViewDelegate,
UITableViewDataSource>

// 数据源
@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation DeliveryView

+ (instancetype)shareDeliveryInstanetype {
    return [[[NSBundle mainBundle] loadNibNamed:@"DeliveryView" owner:self options:nil] objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 8;
    self.companySelect.layer.borderWidth = 1;
    self.companySelect.layer.borderColor = LINE_COLOR.CGColor;
    self.downButton.layer.borderWidth = 1;
    self.downButton.layer.borderColor = LINE_COLOR.CGColor;
    self.deliveryNumber.layer.borderWidth = 1;
    self.deliveryNumber.layer.borderColor = LINE_COLOR.CGColor;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _dataSource = @[@"顺丰", @"申通", @"圆通", @"韵达", @"中通", @"天天", @"EMS"];
}


#pragma mark - Button method
- (IBAction)deliveryButtons_action:(UIButton *)sender {
    //选择物流公司，展开tableview
    if (sender.tag == 260 || sender.tag == 261) {
        if (sender.selected) {
            self.tableView.hidden = YES;
        } else {
            self.tableView.hidden = NO;
        }
        sender.selected = !sender.selected;
    } else {
        if (self.buttonBlock) {
            self.buttonBlock(sender.tag - 260);
        }
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kDeliveryCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kDeliveryCell"];
        cell.textLabel.textColor = WWColor(69, 69, 69);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.companySelect setTitle:[NSString stringWithFormat:@"%@", _dataSource[indexPath.row]] forState:UIControlStateNormal];
    self.tableView.hidden = YES;
    self.companySelect.selected = NO;
    self.downButton.selected = NO;
}

@end
