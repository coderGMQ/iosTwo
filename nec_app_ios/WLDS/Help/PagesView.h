//
//  PagesView.h
//  BNZY
//
//  Created by zhiyundaohe on 2017/9/18.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagesView : UIView

//是否允许滚动
@property (nonatomic) BOOL drag;

//记录位置
@property (nonatomic) NSInteger location;

//标签集合
@property (nonatomic,strong) NSArray *items;

//滚动视图
@property (nonatomic,strong) UIScrollView *scroll;

//标签视图点击实现
@property (nonatomic,copy) void (^clickSegBlock) (NSInteger index);

//设置表视图代理
- (void)setTabelViewDelagate:(id)delegate tag:(NSInteger)tag type:(int)type middle:(UIView *)view;

//设置表视图代理
- (void)setTabelViewDelagate:(id)delegate tag:(NSInteger)tag type:(int)type;

//根据位置获取表视图
- (UITableView *)gainTableView:(NSInteger)location;

//刷新数据
- (void)reloadData;


@end
