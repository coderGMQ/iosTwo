//
//  UITableView+category.h
//  BQBusiness
//
//  Created by 新货郎 on 16/7/25.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UITableView (category)

//我要添加一个实例也可以访问的变量所以就写在这里了
@property (nonatomic, strong) NSString *str;

@property(nonatomic, strong) UIView *firstView;

@property (nonatomic) CGFloat  scale;



#pragma mark  ===  创建上拉加载及下拉刷新  ====
- (void)createHeaderAction:(SEL)hAction footerAction:(SEL)fAction target:(id)target;

#pragma mark  ===  创建下拉刷新  ====
//*********************************
- (void)createRefreshWithTarget:(id)target action:(SEL)action;

////结束刷新或者加载
//- (void)endWithType:(int)type;

//结束刷新或者加载,是否刷新
- (void)endRefreshing:(BOOL)end reload:(BOOL)reload;

- (void)endRefreshing:(BOOL)end;

#pragma mark  ===  创建上拉加载  ====
//*********************************
- (void)createLoadingWithTarget:(id)target action:(SEL)action;

#pragma mark  ===  移除下拉刷新  ====
- (void)removeRefresh;

#pragma mark  ===  移除上拉加载  ====
- (void)removeLoading;

#pragma mark  ===  移除上拉加载 下拉刷新  ====
- (void)removeHeaderAndFooter;

//根据总数以及单页数量，计算所需分页总数
- (NSInteger)allPagesWithTotal:(NSInteger)total  count:( NSInteger)count;

//回到顶部
- (void)backToTopAnimated:(BOOL)animated;



@end
