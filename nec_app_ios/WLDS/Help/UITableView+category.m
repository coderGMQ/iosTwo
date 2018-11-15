
//
//  UITableView+category.m
//  BQBusiness
//
//  Created by 新货郎 on 16/7/25.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import "UITableView+category.h"

#import <objc/runtime.h>
//enum {
//    OBJC_ASSOCIATION_ASSIGN = 0, //关联对象的属性是弱引用
//
//    OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1, //关联对象的属性是强引用并且关联对象不使用原子性
//
//    OBJC_ASSOCIATION_COPY_NONATOMIC = 3, //关联对象的属性是copy并且关联对象不使用原子性
//
//    OBJC_ASSOCIATION_RETAIN = 01401, //关联对象的属性是copy并且关联对象使用原子性
//
//    OBJC_ASSOCIATION_COPY = 01403 //关联对象的属性是copy并且关联对象使用原子性
//};
//

////利用静态变量地址唯一不变的特性
//1、static void *strKey = &strKey;
//
//2、static NSString *strKey = @"strKey";
//
//3、static char strKey;

static void *strKey = &strKey;

@implementation UITableView (category)


NSString * const _recognizerScale = @"_recognizerScale";
//基本数据类型通过NSNumber转换
- (void)setScale:(CGFloat)scale {
    
    objc_setAssociatedObject(self, (__bridge const void *)(_recognizerScale), @(scale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    self.transform = CGAffineTransformMakeScale(scale, scale);
    
}

- (CGFloat)scale {
    
    NSNumber *scaleValue = objc_getAssociatedObject(self, (__bridge const void *)(_recognizerScale));
    
    return scaleValue.floatValue;
}


//类目属性赋值操作
-(void)setFirstView:(UIView *)firstView{
    
    objc_setAssociatedObject(self, @selector(firstView), firstView, OBJC_ASSOCIATION_RETAIN);
}

-(UIView *)firstView{
    
    return objc_getAssociatedObject(self, @selector(firstView));
}

-(void)setStr:(NSString *)str{
    
    objc_setAssociatedObject(self, &strKey, str, OBJC_ASSOCIATION_COPY);
}

-(NSString *)str{
    
    return objc_getAssociatedObject(self, &strKey);
}

//作者：碧霄问鼎
//链接：http://www.jianshu.com/p/3cbab68fb856
//來源：简书
//著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

/*
 
 //结束刷新状态
 [weakSelf.tableView footerEndRefreshing];
 
 */
#pragma mark  ===  建立上拉加载 下拉刷新  ====
- (void)createHeaderAction:(SEL)hAction footerAction:(SEL)fAction target:(id)target
{
 
    [self addHeaderWithTarget:target action:hAction];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self addFooterWithTarget:target action:fAction];
    
     //设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.headerPullToRefreshText = @"刷新数据";
    self.headerReleaseToRefreshText = @"准备刷新";
    self.headerRefreshingText = @"正在刷新";
    //
    self.footerPullToRefreshText = @"加载数据";
    
    self.footerReleaseToRefreshText = @"准备加载数据";
    
    self.footerRefreshingText = @"正在加载数据";

}

#pragma mark  ===  建立上拉加载 下拉刷新  ====
//*********************************
- (void)createRefreshWithTarget:(id)target action:(SEL)action{
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
   [self addHeaderWithTarget:target action:action];
    
//     设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.headerPullToRefreshText = @"刷新数据";
    self.headerReleaseToRefreshText = @"准备刷新";
    self.headerRefreshingText = @"正在刷新";
    
}

#pragma mark  ===  建立上拉加载 下拉刷新  ====
//*********************************
- (void)createLoadingWithTarget:(id)target action:(SEL)action
{
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self addFooterWithTarget:target action:action];

    self.footerPullToRefreshText = @"加载数据";
    
    self.footerReleaseToRefreshText = @"准备加载数据";
    
    self.footerRefreshingText = @"正在加载数据";
}

#pragma mark  ===  移除下拉刷新  ====
- (void)removeRefresh
{
    [self removeHeader];
}

#pragma mark  ===  移除上拉加载  ====
- (void)removeLoading
{
    [self removeFooter];
}

#pragma mark  ===  移除上拉加载 下拉刷新  ====
- (void)removeHeaderAndFooter
{
    [self removeHeader];
    
    [self removeFooter];
}


//根据总数以及单页数量，计算所需分页总数
- (NSInteger)allPagesWithTotal:(NSInteger)total  count:( NSInteger)count{
    
    
   NSInteger pages = total / count;
    
    NSInteger remain = total % count;

    if (remain != 0) {
        
        pages = pages + 1;
    }

    return pages;
}

//回到顶部
- (void)backToTopAnimated:(BOOL)animated
{
    //滚动到顶部
    [self setContentOffset:CGPointMake(0, 0) animated:animated];
}


//结束刷新或者加载
- (void)endRefreshing:(BOOL)end{
    
    WEAKSELF
    
    if (end == YES) {
        
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //结束刷新状态
            [weakSelf headerEndRefreshing];
            
        });
        
    }else{
        
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //结束加载状态
            [weakSelf footerEndRefreshing];
            
            if ([weakSelf.footerRefreshingText isContainString:@"无"]) {
                
                weakSelf.footerRefreshingText = @"正在加载数据";
            }
        });
    }
}

//结束刷新或者加载
- (void)endRefreshing:(BOOL)end reload:(BOOL)reload{
    
    WEAKSELF
    
    if (end == YES) {
        
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (reload == YES) {
                
                //刷新页面
                [weakSelf reloadData];
            }
            //结束刷新状态
            [weakSelf headerEndRefreshing];
            
        });
        
    }else{
        
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //刷新页面
            if (reload == YES) {
                
                //刷新页面
                [weakSelf reloadData];
            }
            
            //结束加载状态
            [weakSelf footerEndRefreshing];
            
            if ([weakSelf.footerRefreshingText isContainString:@"无"]) {
                
                weakSelf.footerRefreshingText = @"正在加载数据";
            }
        });
    }
}

////结束刷新或者加载
//- (void)endRefreshing:(BOOL)end finsh:(void (^)(BOOL success))finsh{
//
//    WEAKSELF
//
//    if (end == YES) {
//
//        // 2.2秒后刷新表格UI
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            //结束刷新状态
//            [weakSelf headerEndRefreshing];
//
//            //结束回调
//            BLOCK_EXEC(finsh,YES);
//
//        });
//
//    }else{
//
//        // 2.2秒后刷新表格UI
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            //结束回调
//            BLOCK_EXEC(finsh,YES);
//
//            //结束加载状态
//            [weakSelf footerEndRefreshing];
//
//            if ([weakSelf.footerRefreshingText isContainString:@"无"]) {
//
//                weakSelf.footerRefreshingText = @"正在加载数据";
//            }
//        });
//    }
//}

@end
