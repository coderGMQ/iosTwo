//
//  InputView.h
//  BNZY
//
//  Created by zhiyundaohe on 2018/1/6.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputViewDelegate<NSObject>

@optional
- (void)keyboardShow:(CGFloat)value;

- (void)keyboardHidden:(CGFloat)value;

@end

//多行输入
@interface InputView : UIView

@property (nonatomic,strong) UITextView *textView;

//占位文本信息
@property (nonatomic,strong) NSString *text;

@property (nonatomic,strong) NSString *title;

//输入文本值
@property (nonatomic,strong) NSString *value;

//预设值
@property (nonatomic,strong) NSString *preinstall;

//数据刷新及加载代理属性
@property (nonatomic, weak, nullable) id <InputViewDelegate> delegate;

//占位文本
//@property (nonatomic,strong) UILabel *placeholderLB;
//
//@property (nonatomic,strong) UILabel *label;
//
//@property (nonatomic,strong) UITextView *textView;

//字数限制
@property (nonatomic) NSInteger count;

@end
