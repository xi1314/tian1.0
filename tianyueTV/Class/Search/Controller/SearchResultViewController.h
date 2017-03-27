//
//  SearchResultViewController.h
//  tianyueTV
//
//  Created by wwwwwwww on 2016/12/27.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultViewController : UIViewController

@property(nonatomic,strong)NSMutableArray *results;
@property(nonatomic,strong)UICollectionView *collcetionView;
@property(nonatomic,strong)NSString *titl;

@end
