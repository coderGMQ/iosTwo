//
//  UIButton+Adaptive.m
//  XHLEBusiness
//
//  Created by  zhiyundaohe on 17/12/24.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import "UIButton+Adaptive.h"

@implementation UIButton (Adaptive)

//方法调用前先设置文本内容以及文本字体大小
+ (CGRect)returnWidthForButton:(UIButton *)button fromLeft:(CGFloat)left andRight:(CGFloat)right{
    
    //调整button的标题位置
    button.titleEdgeInsets = UIEdgeInsetsMake(button.titleEdgeInsets.top, left, button.titleEdgeInsets.bottom,right);
    //根据button的字体大小和长度设置button的frame
   CGRect newFrame = CGRectMake(button.frame.origin.x,button.frame.origin.y,button.titleLabel.font.pointSize *button.currentTitle.length + left + right,button.frame.size.height);
    
    return newFrame;
    
}

+ (void)imageForButton:(UIButton *)button imageViewFrame:(CGRect)imageViewFrame{
    
    button.imageEdgeInsets = UIEdgeInsetsMake(imageViewFrame.origin.y, imageViewFrame.origin.x, button.frame.size.height - imageViewFrame.origin.y - imageViewFrame.size.height,button.frame.size.width - imageViewFrame.origin.x - imageViewFrame.size.width);
        
    button.titleEdgeInsets = UIEdgeInsetsMake(0,- imageViewFrame.origin.x + 10,0,imageViewFrame.size.width);
}


//button赋值
- (void)giveTitileColor:(UIColor *)color withFont:(UIFont *)font andTitile:(NSString *)titile{
    
    [self setTitle:titile forState:(UIControlStateNormal)];
    
    [self setTitleColor:color forState:(UIControlStateNormal)];
    
    self.titleLabel.font = font;
}


- (void)cutButtonWithDenom:(NSInteger)denom andColor:(UIColor *)color{
    
    self.layer.masksToBounds = YES;
    
    self.layer.cornerRadius = self.frame.size.height/denom;
    
    if (color != nil) {
        
        self.layer.borderColor = color.CGColor;
        
        self.layer.borderWidth = kFitW(1);
    }
}


- (CGFloat)getButtonWidth{
    
    return self.titleLabel.font.pointSize * self.titleLabel.text.length;
}

//设置正常和高亮状态下的图片
- (void)setImageNormal:(UIImage *)normal highlighted:(UIImage *)highlighted{
    
    [self setImage:normal forState:(UIControlStateNormal)];
    
    [self setImage:highlighted forState:(UIControlStateHighlighted)];
}

//设置正常和高亮状态下的图片
- (void)setNormal:(UIImage *)image{
    
    [self setImage:image forState:(UIControlStateNormal)];
    
    [self setImage:image forState:(UIControlStateHighlighted)];
}

//设置正常和高亮状态下的背景图片
- (void)setBackgroundImageNormal:(UIImage *)normal highlighted:(UIImage *)highlighted{
    
    [self setBackgroundImage:normal forState:(UIControlStateNormal)];
    
    [self setBackgroundImage:highlighted forState:(UIControlStateHighlighted)];
}

//根据颜色设置正常和高亮状态下的背景图片
- (void)setBackgroundNormal:(UIColor *)normal highlighted:(UIColor *)highlighted{
    
    [self setBackgroundImage:[UIImage createImageWithColor:normal] forState:(UIControlStateNormal)];
    
    [self setBackgroundImage:[UIImage createImageWithColor:highlighted] forState:(UIControlStateHighlighted)];
}

//设置正常和高亮状态下的标题
- (void)setNormal:(UIColor *)normal highlighted:(UIColor *)highlighted title:(NSString *)title{
    
    //设置标题
    [self setTwoStateTitle:title];
    //设置高亮
    [self setHighlighted:highlighted normal:normal];
}

//设置正常和高亮状态下的标题
- (void)setTwoStateTitle:(NSString *)title{
    
    [self setTitle:title forState:(UIControlStateNormal)];
    [self setTitle:title forState:(UIControlStateHighlighted)];
}

//设置正常和高亮状态下的标题亚瑟
- (void)setHighlighted:(UIColor *)highlighted normal:(UIColor *)normal{

    [self setTitleColor:normal forState:(UIControlStateNormal)];
    [self setTitleColor:highlighted forState:(UIControlStateHighlighted)];
}


//修改选中
- (void)changeButtonStatue:(NSArray *)array view:(UIView *)view{
    
    
    //其他时间选择按钮
    if (self.selected == YES) {

        return;

    }else{

        self.selected = !self.selected;
    }

    //图片设置
    [self setImage:kSetImage(@"dianxuan_m@2x") forState:(UIControlStateNormal)];
    
    for (NSNumber *number in array) {
        
        NSInteger tag = number.integerValue;
        
        //原来按钮
        UIButton *button = (UIButton *)[view viewWithTag:tag];
        button.selected = NO;
        [button setImage:kSetImage(@"dianxuan_un@2x") forState:(UIControlStateNormal)];
    }
}


@end
