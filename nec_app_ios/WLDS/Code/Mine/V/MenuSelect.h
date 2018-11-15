//
//  MenuSelect.h
//  WLDS
//
//  Created by han chen on 2018/3/19.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MenuBlock) (NSInteger index);


@interface MenuSelect : UIView


    //表视图
@property (nonatomic,strong) UITableView *tableView;


@property (nonatomic,copy) MenuBlock block;

/*
 * @ frame 菜单视图相对于整个window的位置及大小 height的设置对菜单视图无任何影响
 * @ items 菜单按钮的选项内容数组
 * @ (void (^)(NSInteger index))action 执行点击菜单选项的方法 index表示选中的菜单位置
 *
 **/
- (instancetype)initWithFrame:(CGRect)frame menuItems:(NSArray *)items;
/*
 * 展示菜单页面
 *
 **/
- (void)hidenMenuView;

/*
 * 隐藏菜单页面
 *
 **/
- (void)showMenuView;

/*
 * 设置菜单背景颜色
 *
 **/
- (void)setMenuColor:(UIColor *)color;

    //======================== 表视图的选择 ========================
    //回传信息
@property (nonatomic,copy) void (^chooseMenuSelect) (NSInteger index,NSDictionary *message);
    //自定义初始化方法
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;

    //展示视图
- (void)showTableViewByView:(UIView *)view offset:(CGFloat)offset again:(BOOL)again;

    //======================== 警示框 ========================

    //警示框标题
@property (nonatomic,strong) UILabel *title;

    //警示框信息
@property (nonatomic,strong) UILabel *message;

    //自定义初始化方法
- (instancetype)initWarningItems:(NSArray *)items;


@end
