//
//  RequestModel.h
//  BNZY
//
//  Created by zhiyundaohe on 2017/10/9.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import <Foundation/Foundation.h>


//通用请求数据对象构建
@interface RequestModel : NSObject

//展示标题
@property (nonatomic,strong) NSString *title;

//占位文本
@property (nonatomic,strong) NSString *placeholder;

//请求字段
@property (nonatomic,strong) NSString *field;

//展示输入文本
@property (nonatomic,strong) NSString *text;

//数据实体
@property (nonatomic,strong) NSString *data;

//是否选中
@property (nonatomic) BOOL selected;

//是否隐藏
@property (nonatomic) BOOL hiden;

//是否为可输入文本
@property (nonatomic) BOOL enabled;

//是否禁止输入
@property (nonatomic) BOOL ban;

//子标题
@property (nonatomic,strong) NSString *sub;
//图片文本
@property (nonatomic,strong) NSString *picture;

//是否为必填字段
@property (nonatomic) BOOL must;

//类型数据（自定义作为判断标准，区分cell使用类型等）
@property (nonatomic) int type;

//UIKeyboardTypeDefault：(0);UIKeyboardTypeNumberPad：(4);UIKeyboardTypeDecimalPad：(8)
//键盘类型
@property (nonatomic) int keyboardType;

//文本位置样式0，1，2
@property (nonatomic) int textAlignment;




@end
