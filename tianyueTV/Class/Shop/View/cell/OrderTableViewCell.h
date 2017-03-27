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
//------kOrderCell----
@property (weak, nonatomic) IBOutlet UIImageView *goodImg;      //图片
@property (weak, nonatomic) IBOutlet UILabel *goodTitle;        //名称
@property (weak, nonatomic) IBOutlet UILabel *goodSize;         //规格
@property (weak, nonatomic) IBOutlet UILabel *goodColor;        //颜色
@property (weak, nonatomic) IBOutlet UILabel *price;            //单价
@property (weak, nonatomic) IBOutlet UILabel *count;            //数量
@property (strong, nonatomic) NSDictionary *dataDic;            //data

//------kExpressCell---
@property (weak, nonatomic) IBOutlet UILabel *expressType;      //快递公司
@property (weak, nonatomic) IBOutlet UILabel *expressPrice;     //快递价格


//-----kInfoCell-----
@property (weak, nonatomic) IBOutlet UILabel *infoType;         //信息名
@property (weak, nonatomic) IBOutlet UILabel *infoValue;        //信息值

@end
