

//
//  QJCustomViwew.m
//  XHLEBusiness
//
//  Created by  zhiyundaohe on 17/12/16.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//
#import "QJCustomView.h"




@implementation QJCustomView
//默认初始化选择第一种View布局
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    [self setSubViewsWithCustomViewStyle:QJCustomViewStyleNoImage];
    }
    return self;
}
//可多选的cell布局方法
- (instancetype)initWithFrame:(CGRect)frame taget:(id)taget action:(SEL)action withQJCustonViewStyle:(QJCustomViewStyle)QJCustomViewStyle
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setSubViewsWithCustomViewStyle:QJCustomViewStyle];
        self.target = taget;
        self.action = action;
    }
    return self;
}

- (void)setSubViewsWithCustomViewStyle:(QJCustomViewStyle)customViewStyle
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    if (0 != customViewStyle) {
        //WithFrame:CGRectMake(width/2 + 15, (height - 15)/2, 15, 15)
        _qJImageVIew = [[UIImageView alloc] init];
       
        [self addSubview:_qJImageVIew];
    }
    
    //  创建label
    _qJLabel = [[UILabel alloc] init];
   
    [self addSubview:_qJLabel];
    //  创建图片
    switch (customViewStyle) {
      //无图  右 上 左 下
        case 0:
            _qJLabel.frame = CGRectMake(0, 0, width, height);
            _qJLabel.textAlignment = NSTextAlignmentCenter;
            
            break;
        case 1:
            _qJLabel.frame = CGRectMake(0, 0, width/2 + 10, height);
            _qJImageVIew.frame = CGRectMake(_qJLabel.frame.size.width + _qJLabel.frame.origin.x +2, (height - 15)/2, 15, 15);
            _qJLabel.textAlignment = NSTextAlignmentRight;
       
            
            break;
        case 2:
            _qJImageVIew.frame = CGRectMake((width - 15)/2, 5, 15, 15);
            _qJLabel.frame = CGRectMake(0, _qJImageVIew.frame.size.height + _qJImageVIew.frame.origin.y, width, height - _qJImageVIew.frame.size.height - _qJImageVIew.frame.origin.y);
            _qJLabel.textAlignment = NSTextAlignmentCenter;
            
            break;
        case 3:
            
            _qJImageVIew.frame = CGRectMake(width/2 - 32, (height - 15)/2, 15, 15);
            _qJLabel.frame = CGRectMake(_qJImageVIew.frame.size.width + _qJImageVIew.frame.origin.x, 0, width/2 + 20, height);
            
            _qJLabel.textAlignment = NSTextAlignmentLeft;
            
            
            break;
        case 4:
            
            _qJLabel.frame = CGRectMake(0, 5, width, height - 25);
            _qJLabel.textAlignment = NSTextAlignmentCenter;
            
            _qJImageVIew.frame = CGRectMake((width - 15)/2, _qJLabel.frame.size.height + _qJLabel.frame.origin.y, 15, 15);
            
            break;
            
        default:
            break;
    }
   
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.backgroundColor = self.selectedColor;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

  [self.target performSelector:self.action withObject:self];
    
    self.backgroundColor = self.endSelectedColor;
    
}


- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    _action = action;
    _target = target;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
