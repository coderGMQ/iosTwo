//
//  QJCustomViwew.h
//  XHLEBusiness
//
//  Created by  zhiyundaohe on 17/12/16.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QJCustomView : UIView

typedef NS_ENUM(NSUInteger, QJCustomViewStyle) {
    
    QJCustomViewStyleNoImage,//没有图片
    QJCustomViewStyleImageOnTheRight,//图片居右
    QJCustomViewStyleImageOnTheTop,//图片居上
    QJCustomViewStyleImageOnTheLeft,//图片居左
    QJCustomViewStyleImageOnTheBottom,//图片居下
    QJCustomViewStyleCustomSegmented//自定义增减
};

@property (nonatomic) BOOL isSelected;

@property (nonatomic,strong) UIImageView *qJImageVIew;

@property (nonatomic,strong) UILabel *qJLabel;

@property (nonatomic,strong) UIColor *selectedColor;

@property (nonatomic,strong) UIColor *endSelectedColor;

// 传进来的对象
@property (nonatomic,retain) id target;
// 触发的方法
@property (nonatomic,assign) SEL action;

- (instancetype)initWithFrame:(CGRect)frame taget:(id)taget action:(SEL)action withQJCustonViewStyle:(QJCustomViewStyle)QJCustomViewStyle;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
//@property (nonatomic,strong) UITextField *countTF;





@end
