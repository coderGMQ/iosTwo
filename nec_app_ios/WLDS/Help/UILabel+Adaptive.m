
//
//  UILabel+Adaptive.m
//  XHLEBusiness
//
//  Created by  zhiyundaohe on 17/12/24.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import "UILabel+Adaptive.h"
#import <objc/runtime.h>

static void *myAllPropertiesDicKey = &myAllPropertiesDicKey;

@implementation UILabel (Adaptive)

-(void)setData:(NSDictionary *)data{
    objc_setAssociatedObject(self, &myAllPropertiesDicKey, data, OBJC_ASSOCIATION_COPY);
}

-(NSDictionary *)data{
    
    return objc_getAssociatedObject(self, &myAllPropertiesDicKey);
}

//改变字符创颜色
- (void)changeLabelTextColor:(UIColor *)color string:(NSString *)string other:(NSString *)other{
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[string stringByAppendingString:other]];
    
    [attString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(string.length,other.length)];
    
    self.attributedText = attString;
}

+ (void)adjustThePositionForLabel:(UILabel *)label withLineSpacing:(CGFloat)spacing{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:spacing];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

- (CGFloat)changeWidthForLabelWithFont:(UIFont *)font andText:(NSString *)text
{
    self.font = font;
    
    self.text = text;
    
    return text.length * font.pointSize;
}

//获取label文本的字体大小
- (CGFloat)fontSize{
    
    return self.font.pointSize;
}


//自适应Label的文本宽度并设置frame
- (void)fitWidthWithX:(CGFloat)x Y:(CGFloat)y font:(UIFont *)font Text: (NSString *)text{
    
    CGRect frame = [text boundingRectWithSize:CGSizeMake(100000, 100000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    
    self.font = font;
    
    self.text = text;
    
    self.frame = CGRectMake(x, y, frame.size.width, frame.size.height);
}

//自适应Label的文本宽度并设置frame
- (void)fitWidthWithText:(NSString *)text{
    
    CGRect frame = [text boundingRectWithSize:CGSizeMake(100000, 100000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName] context:nil];
    
    self.text = text;
    
    self.frame = CGRectMake(self.x,self.y, frame.size.width,self.h);
}

//自适应Label的文本高度并设置frame
- (void)fitHeightWithText:(NSString *)text{
  
    CGRect frame = [text boundingRectWithSize:CGSizeMake(self.w, 10000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName] context:nil];
    
    self.numberOfLines = 0;
    
    self.text = text;
    
    self.frame = CGRectMake(self.x,self.y,self.w, frame.size.height);
    
}
//自适应Label的文本高度并设置frame
- (void)fitHeightWithX:(CGFloat)x Y:(CGFloat)y width:(CGFloat)width font:(UIFont *)font Text: (NSString *)text{
    
    CGRect frame = [text boundingRectWithSize:CGSizeMake(width, 10000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    
    self.numberOfLines = 0;
    
    self.font = font;
    
    self.text = text;
    
    self.frame = CGRectMake(x, y, width, frame.size.height);
}

//获取该文本的宽度
- (CGFloat)gainWidthByText:(NSString *)text;{
    
    CGRect frame = [text boundingRectWithSize:CGSizeMake(100000, 100000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName] context:nil];
    
    self.text = text;
    
    return frame.size.width;
}

////在字符串中间画划线
//- (NSMutableAttributedString *)setLineForString:(NSString *)string fromLocation:(NSInteger)startLocation toLenth:(NSInteger)lenth
//{
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
//    
//    [attString addAttribute:NSForegroundColorAttributeName value:kLightGrayColor range:NSMakeRange(startLocation, lenth)];
//    
//    [attString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(startLocation, lenth)];
//    
//    return  attString;
//}

//在字符串中间画划线
- (void)setLineForString:(NSString *)string other:(NSString *)other
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[other stringByAppendingString:string]];
    
    [attString addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(other.length, string.length)];
    
    [attString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(other.length, string.length)];
    
    //赋值操作
    self.attributedText = attString;

}

//根据颜色，字体大小华删除线
- (void)setLineForString:(NSString *)string other:(NSString *)other color:(UIColor *)color font:(UIFont *)font
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[other stringByAppendingString:string]];
    
    [attString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(other.length, string.length)];
    
    [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(other.length, string.length)];
    
    [attString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(other.length, string.length)];
    
    //赋值操作
    self.attributedText = attString;
}

//修改中间字符创的颜色颜色
- (void)changeColor:(UIColor *)color prep:(NSString *)prep middle:(NSString *)middle last:(NSString *)last
{

    NSString *string =  [NSString stringWithFormat:@"%@%@%@",prep,middle,last];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];

    [attString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(prep.length, middle.length)];

    self.attributedText = attString;
}

//设置文本颜色、字体、文本
- (void)setTitleColor:(UIColor *)color font:(UIFont *)fon title:(NSString *)title
{
    self.text = title;
    
    self.font = fon;
    
    if (color != nil) {
        
        self.textColor = color;
    }
    
}

//运单状态颜色赋值
- (void)waybillStatueColor{
    
    NSString *title = self.text;
    
    if ([title isEqualToString:@"未提货"]) {
        
        self.textColor = kGreenColor;
        
    }else if ([title isEqualToString:@"提货中"]) {
            
        self.textColor = kHexColor(0x272727);
        
    }else if ([title isEqualToString:@"提货入库"]) {
        
        self.textColor = kHexColor(0x600000);
        
    }else if ([title isEqualToString:@"转交中"]) {
        
        self.textColor = kHexColor(0x9F0050);
        
    }else if ([title isEqualToString:@"配载中"]) {
        
        self.textColor = kHexColor(0xFF00FF);
        
    }else if ([title isEqualToString:@"在途中"]) {
        
        self.textColor = kHexColor(0x9F35FF);
        
    }else if ([title isEqualToString:@"到站入库"]) {
        
        self.textColor = kHexColor(0x0000C6);
        
    }else if ([title isEqualToString:@"送货中"]) {
        
        self.textColor = kHexColor(0x00AEAE);
        
    }else if ([title isEqualToString:@"送货完成"]) {
        
        self.textColor = kHexColor(0x01B468);
        
    }else if ([title isEqualToString:@"已签收"]) {
        
        self.textColor = kHexColor(0x00EC00);
        
    }else if ([title isEqualToString:@"转入待接受"]) {
        
        self.textColor = kHexColor(0x82D900);
        
    }else if ([title isEqualToString:@"转交完成"]) {
        
        self.textColor = kHexColor(0x737300);
        
    }else if ([title isEqualToString:@"回单完成"]) {
        
        self.textColor = kHexColor(0x977C00);
        
    }else if ([title isEqualToString:@"转出待接受"]) {
        
        self.textColor = kHexColor(0xD26900);
        
    }else if ([title isEqualToString:@"计费完成"]) {
        
        self.textColor = kHexColor(0xF75000);
        
    }else{
        
        self.textColor = kOrangeColor;
    }
    
//    else if ([title isEqualToString:@""]) {
//
//        self.textColor = kHexColor(0x);
//
//    }else if ([title isEqualToString:@""]) {
//
//        self.textColor = kHexColor(0x);
//
//    }else if ([title isEqualToString:@""]) {
//
//        self.textColor = kHexColor(0x);
//
//    }else if ([title isEqualToString:@""]) {
//
//        self.textColor = kHexColor(0x);
//
//    }else if ([title isEqualToString:@""]) {
//
//        self.textColor = kHexColor(0x);
//
//    }else if ([title isEqualToString:@""]) {
//
//        self.textColor = kHexColor(0x);
//
//    }
}


-(void)distinguishPhoneNum:(NSString *)string filtrate:(BOOL)filtrate{
    
    //获取字符串中的电话号码
    NSString *regulaStr = @"\\d{3,4}[- ]?\\d{7,8}";
    
    NSRange stringRange = NSMakeRange(0, string.length);
    //正则匹配
    NSError *error;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:regulaStr options:0 error:&error];
    
    if (!error && regexps != nil) {
        
        self.data = @{};
        [regexps enumerateMatchesInString:string options:0 range:stringRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            
            //符合结果数据
            NSRange phoneRange = result.range;
            
            NSString *tiaojian = @"";
            
            if (phoneRange.location > 5){
                
                NSRange range = NSMakeRange(phoneRange.location - 5, 5);
                
                tiaojian = [string substringWithRange:range];//截取范围内的字符串
                
            }else{
                
                tiaojian = [string substringToIndex:phoneRange.location];//截取掉下标5之前的字符串
            }
                        
            if (filtrate == YES) {
                
                //不符合条件
                if (!([tiaojian isContainString:@"电话"] || [tiaojian isContainString:@"联系方式"])) {
                    
                    //符合操作
                    self.text = [str string];
                    
                    return;
                }
            }
            
            
            NSAttributedString *phoneNumber = [str attributedSubstringFromRange:phoneRange];
            //记录数据和位置信息
            //添加下划线
            NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            
            [str addAttributes:attribtDic range:phoneRange];
            //设置文本中的电话号码显示为黄色
            [str addAttribute:NSForegroundColorAttributeName value:kMainColor range:phoneRange];
            //改变后的字符串
            self.attributedText = str;
            //打开交互
            self.userInteractionEnabled = YES;
            
            //存储筛选出来的电话号码
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:self.data];
            [dict setObject:phoneNumber.string forKey:phoneNumber.string];
            self.data = dict;
            
            //            [self boundingRectNumber:phoneNumber range:result.range];
            
            
            //添加手势，可以点击号码拨打电话
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
            [self addGestureRecognizer:tap];
            
        }];
    }
}

//实现拨打电话的方法
-(void)tapGesture:(UITapGestureRecognizer *)sender{
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]){
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不能打电话" delegate:nil cancelButtonTitle:@"好的,知道了" otherButtonTitles:nil,nil];
        
        [alert show];
        
    }else{
        
        //取得所点击的点的坐标
        //        CGPoint point = [sender locationInView:self];
        
        NSArray *array = self.data.allKeys;
        
        if (array.count == 1) {
            
            NSString* str = [NSString stringWithFormat:@"telprompt://%@",array.firstObject];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        }else if (array.count > 1){
            
            ShowView *showView = [[ShowView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
            
            
            __weak typeof(showView) afterCell = showView;
            
            showView.afterHiden = ^{
                
                __strong typeof(afterCell) stongify = afterCell;
                
                //移除视图
                [stongify removeFromSuperview];
            };
            UIView *view = [[UIView alloc] init];
            [showView addSubview:view];
            view.backgroundColor = kWhiteColor;
            
            //文本信息
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth - kFitW(30), kFitW(40))];
            label.textColor = kWhiteColor;
            label.font = kFontSize(kFitW(15));
            label.backgroundColor = kMainColor;
            label.text = @"请选择拨打的电话号码";
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            
            
            CGFloat y = label.v;
            
            for (int i = 0; i < array.count; i++) {
                
                //按钮创建
                UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
                button.titleLabel.font = kFontSize(kFitW(15));
                [view addSubview:button];
                button.frame = CGRectMake(0,y, label.w, kFitW(40));
                
                [button setTitle:[array objectAtIndex:i] forState:(UIControlStateNormal)];
                [button setTitleColor:KTEXT_COLOR forState:(UIControlStateNormal)];
                //添加监听事件
                [button addTarget:self action:@selector(clickPhoneButton:) forControlEvents:(UIControlEventTouchUpInside)];
                
                if (i == array.count - 1) {
                    
                    y = button.v;
                    
                }else{
                    
                    //底部细线
                    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,button.v, label.w, 1.0)];
                    [view addSubview:line];
                    line.backgroundColor = kLikeColor;
                    
                    y = line.v;
                }
            }
            
            //设置frame
            view.frame = CGRectMake((kWidth - label.w) / 2, (kHeight - y) / 2, label.w,y);
            [view cropLayer: 5];
        }
    }
}

- (void)clickPhoneButton:(UIButton *)button{
    
    NSString *title = button.titleLabel.text;
    
    NSString* str = [NSString stringWithFormat:@"telprompt://%@",title];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

//本身文本作为电话号码进行拨打电话
- (void)phoneOwnText{
    
    //拨打号码
    if (self.text.length > 0) {
        
        //打开交互
        self.userInteractionEnabled = YES;
        
        //存储筛选出来的电话号码
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:self.data];
        [dict setObject:self.text forKey:self.text];
        self.data = dict;
        
        //添加手势，可以点击号码拨打电话
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tap];
        
    }
}

//本身文本作为电话号码进行拨打电话
- (void)phoneOwnTextFiltrate:(BOOL)filtrate{
    
    //拨打号码
    if (self.text.length > 0) {
        
        
        if (filtrate == NO) {
            
            //打开交互
            self.userInteractionEnabled = YES;
            
            //存储筛选出来的电话号码
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:self.data];
            [dict setObject:self.text forKey:self.text];
            self.data = dict;
            
            //添加手势，可以点击号码拨打电话
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
            [self addGestureRecognizer:tap];
            
        }else{
            
            //过滤信息
            [self distinguishPhoneNum:self.text filtrate:NO];
        }
    }
}


@end
