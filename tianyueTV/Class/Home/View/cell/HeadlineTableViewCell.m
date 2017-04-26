//
//  HeadlineTableViewCell.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/25.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "HeadlineTableViewCell.h"


@interface HeadlineTableViewCell ()

// 封面
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;

// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// 作者
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

// 日期
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

// 点赞数
@property (weak, nonatomic) IBOutlet UILabel *favourLabel;

// 点赞
@property (weak, nonatomic) IBOutlet UIButton *favourButton;


@end


@implementation HeadlineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/**
 刷新cell

 @param model 数据模型
 */
- (void)configCellWithModel:(HeadNewsModel *)model {

    [self.newsImageView setImageWithURL:[NSURL URLWithString:model.faceImage]];
    self.titleLabel.text = model.title;
    self.authorLabel.text = [NSString stringWithFormat:@"作者：%@",model.author];
    self.favourLabel.text = model.praiseNum;
    self.dateLabel.text = [self intervalSinceNow:model.time_new];
}

/**
 转换时间

 @param theDate 获取新闻的日期
 @return 计算与当前日期距离
 */
- (NSString *)intervalSinceNow:(NSString *)theDate
{
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d = [date dateFromString:theDate];
    
    NSTimeInterval late = [d timeIntervalSince1970];
    NSDate *dat = [NSDate date];
    NSTimeInterval now = [dat timeIntervalSince1970];
    
    NSTimeInterval cha = now - late;
    
    NSString *timeString = @"";
    
    if (cha / 60 < 60) {
        
        timeString = [NSString stringWithFormat:@"%d分钟前", (int)(cha / 60)];
        
    }else if (cha / 60 >= 60 && cha / 60 < 24 * 60) {
        
        timeString = [NSString stringWithFormat:@"%d小时前", (int)(cha / 3600)];
        
    }else if (cha / 60 >= 24 * 60) {
        
        timeString = [NSString stringWithFormat:@"%d天前", (int)(cha / (3600 * 24))];
        
    }
    
    return timeString;
}


@end
