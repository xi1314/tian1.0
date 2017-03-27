//
//  WWLeftImageButton.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/20.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWLeftImageButton.h"

@implementation WWLeftImageButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        [self addLayout];
    }
    return self;
}
-(UIImageView *)circle
{
    if (!_circle)
    {
        _circle =[[UIImageView alloc]init];
        _circle.translatesAutoresizingMaskIntoConstraints =NO;
    }
    return  _circle;
}
-(UILabel *)label
{
    if (!_label)
    {
        _label =[[UILabel alloc]init];
        _label.translatesAutoresizingMaskIntoConstraints =NO;
        
    }
    return _label;
}

- (UIImageView *)selectedImage{
    if (!_selectedImage) {
        _selectedImage = [[UIImageView alloc] init];
         _selectedImage.translatesAutoresizingMaskIntoConstraints =NO;
    }
    return _selectedImage;
}

-(void)addLayout
{
    [self addSubview:self.circle];
    [self.circle autoSetDimensionsToSize:CGSizeMake(kWidthChange(28), kHeightChange(28))];
//    [self.circle autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.circle autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.circle autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    
    [self addSubview:self.label];
    [self.label autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.circle];
    [self.label autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.label autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.label autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    [self addSubview:self.selectedImage];
    [self.selectedImage autoSetDimensionsToSize:CGSizeMake(kWidthChange(20), kHeightChange(20))];
    //    [self.circle autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.selectedImage autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.selectedImage autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    
}


@end
