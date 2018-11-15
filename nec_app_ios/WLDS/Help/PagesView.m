

//
//  PagesView.m
//  BNZY
//
//  Created by zhiyundaohe on 2017/9/18.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import "PagesView.h"

@interface PagesView ()<UIScrollViewDelegate>

//记录初始标签
@property (nonatomic) NSInteger preset_tag;

//细线
@property (nonatomic,strong) UILabel *line;

//标签视图
@property (nonatomic,strong) UISegmentedControl *control;


@end

@implementation PagesView


//初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
    }
    
    return self;
}

/**
 *
 * @ 懒加载集合视图
 *
 **/

- (UISegmentedControl *)control{
    
    if (!_control) {
        
        //标签值
        _control = [[UISegmentedControl alloc] initWithItems:self.items];
        _control.frame = CGRectMake(0, 0, self.frame.size.width,50);
        [self addSubview:_control];
        _control.backgroundColor = kWhiteColor;
        _control.selectedSegmentIndex = 0;
        [_control addTarget:self action:@selector(clickSeg:) forControlEvents:(UIControlEventValueChanged)];
        [_control changeSelectedColor:kMainColor unSelectedColor:KTEXT_COLOR titleFont:14];
        
        //细线
//        _line = [[UILabel alloc] initWithFrame:CGRectMake(0, _control.v - 1.0, _control.w / self.items.count, 1.0)];
        
        CGFloat width = _control.w / self.items.count;
        
        _line = [[UILabel alloc] initWithFrame:CGRectMake(width * 0.3, _control.v - 1.0,width * 0.4, 1.0)];
        _line.backgroundColor = kMainColor;
        [self addSubview:_line];
    }
    return _control;
}

#pragma mark ========   标签点击   ========
- (void)clickSeg:(UISegmentedControl *)controll{
    
    [self locationWithIndex:controll.selectedSegmentIndex scroll:NO];
}

#pragma mark ========   修改位置信息   ========
- (void)locationWithIndex:(NSInteger)index scroll:(BOOL)scroll{

    //不执行操作
    if (self.location == index) {
        
        return;
    }
    
    //记录修改标签点击位置
    self.location = index;
    
    if (self.clickSegBlock) {
        
        //传值
        self.clickSegBlock(index);
    }
    
    WEAKSELF
    
    //回收键盘
    kKeyBoardHiden;
    
    //判断执行动画
    if (scroll == NO) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            //修改中心点
            weakSelf.line.center = CGPointMake(kWidth / weakSelf.items.count / 2 + index * (kWidth / weakSelf.items.count), weakSelf.line.center.y);
            
            //移动位置
            weakSelf.scroll.contentOffset = CGPointMake(index * kWidth, 0);
        }];
        
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            
            //修改中心点
            weakSelf.line.center = CGPointMake(kWidth / weakSelf.items.count / 2 + index * (kWidth / weakSelf.items.count), weakSelf.line.center.y);
            
            //移动位置
            weakSelf.control.selectedSegmentIndex = index;
        }];
    }
}
/**
 *
 * @ 懒加载滚动视图
 *
 **/
- (UIScrollView *)scroll{
    
    if (!_scroll) {
        
        _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.control.v + 1.0, self.frame.size.width, self.frame.size.height - self.control.v - 1.0)];
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.bounces = NO;
        _scroll.pagingEnabled = YES;
        _scroll.delegate = self;
        [self addSubview:_scroll];
        
    }
    return _scroll;
}

//设置表视图代理
- (void)setTabelViewDelagate:(id)delegate tag:(NSInteger)tag type:(int)type middle:(UIView *)view{
    
    if (view != nil) {
        
        view.frame = CGRectMake(0,self.control.v + 1.0,self.frame.size.width,view.h);
        
        self.scroll.frame =CGRectMake(0, view.v, self.frame.size.width, self.frame.size.height - view.v);
        
        //添加子视图
        [self addSubview:view];
    }
    
    //执行方法
    [self setTabelViewDelagate:delegate tag:tag type:type];
}
//设置表视图代理
- (void)setTabelViewDelagate:(id)delegate tag:(NSInteger)tag type:(int)type{
    
    //记录预置标签值
    self.preset_tag = tag;
    
    //设置滚动范围
    self.scroll.contentSize = CGSizeMake(self.frame.size.width * self.items.count,self.scroll.h);
    
    for (int i = 0; i < self.items.count; i++) {
        
        //标签设置
        NSInteger index = tag + i;
        
        UITableView *tableView = (UITableView *)[self viewWithTag:index];
        
        if (tableView == nil) {
            
            if (type == 0) {
                
                //创建表视图
                tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * self.w,0, self.w, self.scroll.h) style:(UITableViewStylePlain)];
            }else{
                
                //创建表视图
                tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * self.w,0, self.w, self.scroll.h) style:(UITableViewStyleGrouped)];
                
                //iOS 11系统
                tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.1)];
                tableView.sectionHeaderHeight = 0.0;
            }
            
            [self.scroll addSubview:tableView];
            tableView.separatorStyle = 0;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.tag = index;
            tableView.backgroundColor = kClearColor;
            
            if (delegate) {
                
                tableView.dataSource = delegate;
                tableView.delegate = delegate;
            }
            
        }else{
            
            if (delegate) {
                
                tableView.dataSource = delegate;
                tableView.delegate = delegate;
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //判断滚动视图
    NSInteger index = scrollView.contentOffset.x / self.w;
    
    [self locationWithIndex:index scroll:YES];
    
}

//滚动设置值
- (void)setDrag:(BOOL)drag{
    
    self.control.userInteractionEnabled = self.scroll.scrollEnabled = drag;
  
}

//根据位置获取表视图
- (UITableView *)gainTableView:(NSInteger)location{
    
    UITableView *tableView = (UITableView *)[self viewWithTag:location + self.preset_tag];
    
    return tableView;
}

//刷新数据
- (void)reloadData{
    
    UITableView *tableView = (UITableView *)[self viewWithTag:self.location + self.preset_tag];
    [tableView reloadData];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
