
//  ShowView.m
//  BNZY
//
//  Created by zhiyundaohe on 2017/10/23.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import "ShowView.h"

@interface ShowView ()<UIScrollViewDelegate>

//滚动视图
@property (nonatomic,strong) UIScrollView *scrollView;

//标签
@property (nonatomic,strong) UIPageControl *control;

//记录数量
@property (nonatomic) NSInteger count;


//标记位置
@property (nonatomic) NSInteger index;

//图片
@property (nonatomic,strong) UIImageView *picIV;


@end

@implementation ShowView

/* * * * * * * * * *
 *
 * @ 懒加载图片
 *
 * * * * * * * * * */
- (UIImageView *)picIV{
    
    if (!_picIV) {
        
        _picIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _picIV.contentMode = UIViewContentModeScaleAspectFit;;
        [self addSubview:_picIV];
    }
    return _picIV;
}

//展示图片视图
- (void)showImage:(UIImage *)image{
    
    self.hidden = NO;
    
    //图片赋值
    self.picIV.image = image;
}

/* * * * * * * * * *
 *
 * @ 懒加载滚动视图
 *
 * * * * * * * * * */
- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        //一级轮播图
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.w,self.h)];
        // 设置一些属性
        // 设置滑动内容的区域 显示范围
        _scrollView.contentSize = CGSizeMake(kWidth * 1,_scrollView.frame.size.height);
        // 边界回弹的属性  默认是 YES
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        // 设置代理
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    
    return _scrollView;
}

/* * * * * * * * * *
 *
 * @ 懒加载标签
 *
 * * * * * * * * * */
- (UIPageControl *)control{
    
    if (!_control) {
        
        //一级标签
        _control = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.scrollView.v - 20,kWidth, 10)];
        _control.currentPageIndicatorTintColor = kMainColor;
        _control.pageIndicatorTintColor = kRGBA(0, 0, 0, 0.5);
        [self addSubview:_control];
        
    }
    return _control;
}


#pragma mark ========   创建轮播   ========
- (void)createCarouselWithArray:(NSArray *)array{
    
    self.hidden = NO;
    
    //记录一级轮播数量
    self.count = array.count;

    //一级轮播分页控件的位置
    self.index = 0;
    
    //标签数量
    self.control.numberOfPages = array.count;
    
    //初始位置
    self.control.currentPage = 0;
    
    //移除所有的子视图
    for (UIImageView *imageView in [self.scrollView subviews]) {
        
        [imageView removeFromSuperview];
    }
    
    //数量判断
    NSInteger count = 1;
    
    if (self.count > 1) {
        
        count = self.count + 2;
        
        self.scrollView.contentOffset = CGPointMake(kWidth * 1, 0);
        
    }else{
        
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    
    self.scrollView.contentSize = CGSizeMake(kWidth * count , 0);
    
    
    //循环创建
    for (int i = 0; i < count; i++) {
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i *kWidth , 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        //展示
        imgView.contentMode = UIViewContentModeScaleAspectFit;

        //获取图片名称
        NSString *name = @"";
        
        if (i == 0) {

            name = [array lastObject];
            
        }else if (i == array.count + 1) {

            name = [array firstObject];
            
        }else{

            name = [array objectAtIndex:i - 1];
        }
        
//        //设置图片
//        [imgView sd_setImageWithURL:kIVUrl(name) placeholderImage:kSetImage(@"placeholder_2.17@2x")];
        
        [self.scrollView addSubview:imgView];
    }
}

#pragma mark ========   UIScrollViewDelegate   ========
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //第一级轮播视图
    if (scrollView == self.scrollView) {
        
        //获取当前轮播图片位置
        NSInteger index = scrollView.contentOffset.x/kWidth;
        
        if (0 == index) {
            //改变一级轮播视图偏移量
            scrollView.contentOffset = CGPointMake(kWidth * self.count, 0);
            //修改一级轮播标签位置
            self.control.currentPage = self.count - 1;
            
        }else if (index == self.count + 1)  {
            
            //改变一级轮播视图偏移量
            scrollView.contentOffset = CGPointMake(kWidth, 0);
            //修改一级轮播标签位置
            self.control.currentPage = 0;
            
        }else   {
            //修改一级轮播标签位置
            self.control.currentPage = index - 1;
        }
        //从新记录一级轮播图片位置
        self.index = self.scrollView.contentOffset.x /kWidth;
    }
    
};

//自定义初始话方法
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = kWindowColor;
        
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenView)];
        tap.delegate = delegate;
        [self addGestureRecognizer:tap];
        
        //获取窗口
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //视图添加到当前窗口
        [window addSubview:self];
    }
    
    return self;
}

//默认初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = kWindowColor;
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenView)];
        [self addGestureRecognizer:tap];
        
        //获取窗口
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.frame = window.bounds;
        //视图添加到当前窗口
        [window addSubview:self];
    }
    
    return self;
}
#pragma mark ========   隐藏视图   ========
- (void)hidenView{
    
    //执行block
    BLOCK_EXEC(self.afterHiden);
    
    if (self.disTap == NO) {
        
        self.hidden = YES;
    }    
}

#pragma mark ========   展示视图   ========
- (void)showView{
    
    self.hidden = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
