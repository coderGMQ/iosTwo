//
//  JQWarningView.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/14.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "JQWarningView.h"

@interface JQWarningView ()

//是都隐藏，不隐藏则直接删除
@property (nonatomic) BOOL isHiden;

@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) UILabel *message;


@end

@implementation JQWarningView

#pragma mark ========   按钮点击事件   ========
- (void)clickButton:(UIButton *)sender{

    BLOCK_EXEC(self.buttonBlock,sender.titleLabel.text);

    //移除视图
    [self removeFromSuperview];
}


- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = kWindowColor;
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenMenuView)];
//        [self addGestureRecognizer:tap];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        
        
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = kLikeColor;
        [self addSubview:_backView];

        CGFloat width = kWidth - kFitW(30 * 2);
        
        //文本信息
        _message = [[UILabel alloc] initWithFrame:CGRectMake(kFitW(10), kFitW(5), width - kFitW(10 * 2),kFitW(60))];
        _message.textColor = kGrayColor;
        _message.numberOfLines = 0;
        _message.font = kFontSize(kFitW(15));
        _message.textAlignment = NSTextAlignmentCenter;
        [_backView addSubview:_message];

        
        CGFloat space = (width - kFitW(80 * 2)) / 3;
        
        for (int i = 0; i < 2; i++) {
            
            //按钮创建
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.titleLabel.font = kFontSize(16);
            [_backView addSubview:button];
            button.frame = CGRectMake(space + (space + kFitW(80)) * i,_message.v + kFitW(15),kFitW(80),40);
            [button cropLayer:3];
            
            
            [button setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
            //添加监听事件
            [button addTarget:self action:@selector(clickButton:) forControlEvents:(UIControlEventTouchUpInside)];
            
            if (i == 0) {
                
                button.backgroundColor = kMainColor;
                
                [button setTitle:@"确定" forState:(UIControlStateNormal)];
            }else{
                
                button.backgroundColor = kLightGrayColor;
                
                [button setTitle:@"取消" forState:(UIControlStateNormal)];
                _backView.frame = CGRectMake((kWidth - width) / 2, (kHeight - button.v + kFitW(15)) / 2, width, button.v + kFitW(15));
                _backView.layer.cornerRadius = 5;
            }
        }

    }
    
    return self;
}

//赋值操作
- (void)setTitle:(NSString *)title{
    
    if (_title != title) {
        _title = title;
        self.message.text = title;
    }
}

//- (instancetype)initWithFrame:(CGRect)frame{
//
//    self = [super initWithFrame:frame];
//
//    if (self) {
//
//        self.backgroundColor = kWindowColor;
////        self = [[NSBundle mainBundle] loadNibNamed:@"JQWarningView" owner:self options:nil].lastObject;
//
////        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
//    }
//
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
