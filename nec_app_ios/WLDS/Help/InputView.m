
//
//  InputView.m
//  BNZY
//
//  Created by zhiyundaohe on 2018/1/6.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "InputView.h"


@interface InputView ()<UITextViewDelegate>

//占位文本
@property (nonatomic,strong) UILabel *placeholderLB;

@property (nonatomic,strong) UILabel *label;



@end

@implementation InputView

- (void)setPreinstall:(NSString *)preinstall{
    
    if (_preinstall != preinstall) {
        
        _preinstall = preinstall;
        
        if (preinstall.length > 0) {
            
            self.placeholderLB.text = @"";
            self.textView.text = preinstall;
        }
    }
}

- (void)setTitle:(NSString *)title{
    if (_title != title) {
        _title = title;
        self.label.text = title;
    }
}
//占位文本赋值
- (void)setText:(NSString *)text{
    
    if (_text != text) {
        
        _text = text;
        self.placeholderLB.text = text;
        [UILabel adjustThePositionForLabel:self.placeholderLB withLineSpacing:5];
    }
}

/* * * * * * * * * *
 *
 * @ 标题文本懒加载
 *
 * * * * * * * * * */
- (UILabel *)label{
    
    if (!_label) {
        
        //文本信息
        _label = [[UILabel alloc] init];
        _label.textColor = KTEXT_COLOR;
        _label.font = kFontSize(kFitW(15));
        _label.text = @"备注:";
        [self addSubview:_label];
    }
    return _label;
}

/* * * * * * * * * *
 *
 * @ 懒加载输入框
 *
 * * * * * * * * * */
- (UITextView *)textView{
    
    if (!_textView) {
        
        //输入框
        _textView = [[UITextView alloc] init];
        [self addSubview:_textView];
        _textView.backgroundColor = kLikeColor;
        //文字边距设设置
        _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 10);//设置页边距
        
        _textView.alpha = 1.0; // 设置透明度
        _textView.textAlignment = NSTextAlignmentNatural; // 设置字体对其方式
        _textView.font = [UIFont systemFontOfSize:16]; // 设置字体大小
        _textView.textColor = kBlackColor; // 设置文字颜色
        [_textView setEditable:YES]; // 设置时候可以编辑
        _textView.dataDetectorTypes = UIDataDetectorTypeAll; // 显示数据类型的连接模式（如电话号码、网址、地址等）
        _textView.keyboardType = UIKeyboardTypeDefault; // 设置弹出键盘的类型
        _textView.returnKeyType = UIReturnKeyDone; // 设置键盘上returen键的类型
        _textView.scrollEnabled = YES; // 当文字宽度超过UITextView的宽度时，是否允许滑动
        
    }
    return _textView;
}

/* * * * * * * * * *
 *
 * @ 懒加载占位文本
 *
 * * * * * * * * * */
- (UILabel *)placeholderLB{
    
    if (!_placeholderLB) {
        
        //其次在UITextView上面覆盖个UILable,UILable设置为全局变量。
        _placeholderLB = [[UILabel alloc] init];
        _placeholderLB.numberOfLines = 0;
        _placeholderLB.text = @"";
        _placeholderLB.font = _textView.font;
        _placeholderLB.enabled = NO;//lable必须设置为不可用
        _placeholderLB.backgroundColor = [UIColor clearColor];
        [self addSubview:_placeholderLB];
    }
    return _placeholderLB;
}

- (instancetype)init{
    self = [super init];
    
    if (self) {
        
        //默认500字
        self.count = 500;
        self.value = @"";
        self.backgroundColor = kWhiteColor;
        
    }
    return self;
}

//初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //默认500字
        self.count = 500;
        self.value = @"";
        self.backgroundColor = kWhiteColor;
        
        self.label.frame = CGRectMake(kFitW(15), 0, frame.size.width - kFitW(15 * 2), kFitW(40));
        self.textView.frame = CGRectMake(self.label.x, self.label.v, self.label.w, frame.size.height - self.label.v - 8);
        
        self.textView.delegate = self;
        self.textView.layer.masksToBounds = YES;
        self.textView.layer.cornerRadius = 5;
        self.textView.layer.borderWidth = 1;
        self.textView.layer.borderColor = kLikeColor.CGColor;
        
        self.placeholderLB.frame =CGRectMake(self.textView.frame.origin.x + 12, self.textView.frame.origin.y + 10, self.textView.frame.size.width - 24, self.textView.frame.size.height - 20);
    }
    
    return self;
}

- (void)setDelegate:(id<InputViewDelegate>)delegate{
    
    if (_delegate != delegate) {
        
        _delegate = delegate;
        
        //注册键盘弹出通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowInputView:) name:UIKeyboardWillShowNotification object:nil];
        
        //注册键盘回收通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiddenIInputView:) name:UIKeyboardWillHideNotification object:nil];
    }
}

//键盘弹出
- (void)keyboardWillShowInputView:(NSNotification *)notification{
    
    //获取键盘的位置大小信息frame
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //获取视图在当前窗口的位置
    CGRect viewFrame = self.textView.locationInWindow;
    
    //键盘的y坐标 - 当前视图所在当前窗口的位置
    CGFloat dValue = frame.origin.y - (viewFrame.origin.y + viewFrame.size.height);
    
    //执行传值
    if (_delegate && [_delegate respondsToSelector:@selector(keyboardShow:)]) {
    
        [_delegate keyboardShow:dValue];
    }
}
//键盘回收
- (void)keyboardWillHiddenIInputView:(NSNotification *)notification{
    
    //执行传值
    if (_delegate && [_delegate respondsToSelector:@selector(keyboardHidden:)]) {
        
        [_delegate keyboardHidden:0];
    }
}

#pragma mark == UITextView Delegate ==
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    kKeyBoardHiden;
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    //记录编辑完成后的值
    self.value = textView.text;
}

//变化文本信息
-(void)textViewDidChange:(UITextView *)textView{
    
    //判断是否存在占位文本信息
    if (self.text.length > 0) {
        
        if (textView.text.length == 0) {
            
            self.placeholderLB.hidden = NO;
            
        }else{
            self.placeholderLB.hidden = YES;
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (range.location >= self.count) {
        //控制输入文本的长度
        return  NO;
    }
    
    if ([text isEqualToString:@"\n"]) {
        //禁止输入换行
        kKeyBoardHiden;
        return NO;
        
    } else {
        
        return YES;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
