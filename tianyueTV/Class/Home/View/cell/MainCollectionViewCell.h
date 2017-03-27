//
//  MainCollectionViewCell.h
//  tianyueTV
//
//  Created by wwwwwwww on 2016/12/9.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCollectionViewCell : UICollectionViewCell

//图片
@property(nonatomic,strong)UIImageView *picImage;
//在线人数
@property(nonatomic,strong)UILabel *onlineLabel;
//主播名字
@property(nonatomic,strong)UILabel *nameLabel;
//房间名字
@property(nonatomic,strong)UILabel *titleLab;

@end
