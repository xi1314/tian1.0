//
//  DeliveryView.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/22.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeliveryBlock)(NSInteger tag);
@interface DeliveryView : UIView

@property (copy ,nonatomic) DeliveryBlock buttonBlock;
@property (weak, nonatomic) IBOutlet UIButton *companySelect;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UITextField *deliveryNumber;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
+(instancetype)shareDeliveryInstanetype;
@end
