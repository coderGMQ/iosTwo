//
//  TopView.h
//  BNZY
//
//  Created by zhiyundaohe on 2017/9/12.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopViewDelegate <NSObject>

//选择性执行方法
@optional

- (void)clickRightView:(UIButton *)right;

- (void)clickLeftView:(UIButton *)left;


@end


@interface TopView : UIView


//顶部视图标题
@property (nonatomic,strong) NSString *title;

//标题颜色
@property(nonatomic,copy) UIColor *color;

//右侧标题
@property (nonatomic,strong) NSString *right;

//右侧图片
@property (nonatomic,strong) UIImage *rIM;


//按钮字体渲染颜色
@property(nonatomic,copy) UIColor *tintColor;

//左侧标题
@property (nonatomic,strong) NSString *left;

//左侧侧图片
@property (nonatomic,strong) UIImage *leIM;


//声明代理属性
@property (nonatomic,assign) id <TopViewDelegate> delegate;


@end
