//
//  QJCircleView.h
//  JKCircleViewDemo
//
//  Created by 新货郎 on 16/11/2.
//  Copyright © 2016年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QJCircleView : UIView

// set min and max range for dial
// default values are 0 to 100

@property int minNum;

@property int maxNum;

@property NSString *units;

@property(nonatomic,strong) NSString *iconName;

//标题
@property (nonatomic,strong) NSString *title;

//进度 [0...1]
@property(nonatomic,assign) CGFloat progress;

//是否可以手动调节进度
@property (nonatomic, assign)CGFloat enableCustom;

@property int flag;

//渲染颜色
@property(nonatomic,copy)   UIColor *tintColor;

//未渲染部分颜色
@property(nonatomic,copy)   UIColor *maximumTrackTintColor;

//中间颜色
@property(nonatomic,copy)   UIColor *color;

@property (nonatomic,copy) void (^progressChange)(NSString *result,int flag);

@end
