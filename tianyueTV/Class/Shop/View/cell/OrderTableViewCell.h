//
//  OrderTableViewCell.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/9.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *orderCellIdentifier = @"kOrderCell";
static NSString *expressCellIdentifier = @"kExpressCell";
static NSString *infoCellIndentifier = @"kInfoCell";

@interface OrderTableViewCell : UITableViewCell
// ------kOrderCell----
// 图片
@property (weak, nonatomic) IBOutlet UIImageView *goodImg;

// 名称
@property (weak, nonatomic) IBOutlet UILabel *goodTitle;

// 规格
@property (weak, nonatomic) IBOutlet UILabel *goodSize;

// 颜色
@property (weak, nonatomic) IBOutlet UILabel *goodColor;

// 单价
@property (weak, nonatomic) IBOutlet UILabel *price;

// 数量
@property (weak, nonatomic) IBOutlet UILabel *count;

// data
@property (strong, nonatomic) NSDictionary *dataDic;

//------kExpressCell---
// 快递公司
@property (weak, nonatomic) IBOutlet UILabel *expressType;

// 快递价格
@property (weak, nonatomic) IBOutlet UILabel *expressPrice;


//-----kInfoCell-----
// 信息名
@property (weak, nonatomic) IBOutlet UILabel *infoType;

// 信息值
@property (weak, nonatomic) IBOutlet UILabel *infoValue;

@end
