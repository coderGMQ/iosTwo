//
//  ShowView.h
//  BNZY
//
//  Created by zhiyundaohe on 2017/10/23.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowView : UIView

//禁止手势方法
@property (nonatomic) BOOL disTap;

//隐藏之后的操作
@property (nonatomic,copy) void (^afterHiden)();

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;
//[self.view insertSubView:subview atIndex:0];

//查看大图片
- (void)createCarouselWithArray:(NSArray *)array;

//展示图片视图
- (void)showImage:(UIImage *)image;

    //默认初始化方法
- (instancetype)initWithFrame:(CGRect)frame;





@end
