//
//  SecondTableViewCell.h
//  tianyueTV
//
//  Created by wwwwwwww on 2016/12/7.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MoreBtn.h"
@interface SecondTableViewCell : UITableViewCell
//标题
@property(nonatomic,strong)UILabel *typeLabel;
//更多
@property(nonatomic,strong)MoreBtn *moreBtn;

@property(nonatomic,strong)UICollectionView *SecondCollectionView;
//灰线
@property(nonatomic,strong)UIImageView *grayLine;

@end
