//
//  CustomViewController.h
//  BNZY
//
//  Created by zhiyundaohe on 2017/12/16.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    
    VCStyleDefault = 0,//不使用该控制器自带表视图
    VCStyleNone,//无刷新及加载样式
    VCStyleRefresh,//只有刷新样式
    VCStyleLoad,//只有加载样式
    VCStyleBoth//刷新及加载样式同时存在
    
} VCStyle;

#pragma mark ========   代理书写   ========
@protocol CustomViewControllerDelegate<NSObject>

//选择执行代理方法
@optional

//刷新数据
- (void)refreshDataInCustom;

- (void)loadDataDataInCustom:(NSInteger)page;

@end


@interface CustomViewController : UIViewController

//返回上一页面
@property (nonatomic,copy) void (^ _Nullable backBlock)();

//自定义表视图
@property (nonatomic,strong) UITableView * _Nullable tableView;

//数据刷新及加载代理属性
@property (nonatomic, weak, nullable) id <CustomViewControllerDelegate> delegate;

//样式
@property (nonatomic) VCStyle style;


//接口
@property (nonatomic) NSString *url;

//分页总数
@property (nonatomic) NSInteger totle;

//单页数据量
@property (nonatomic) NSInteger limit;


//数据集合
@property (nonatomic,strong) NSMutableArray * _Nullable dataArray;

//数据字典
@property (nonatomic,strong) NSMutableDictionary *_Nullable dictData;

//请求参数字典
@property (nonatomic,strong) NSMutableDictionary *_Nullable request;

//最顶层视图（加载到导航控制器上）
@property (nonatomic,strong) UIView * _Nullable brontView;

@property (nonatomic) BOOL recycle;


@end
