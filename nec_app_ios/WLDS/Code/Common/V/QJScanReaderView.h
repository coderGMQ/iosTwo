//
//  QJScanReaderView.h
//  CALayerCreate
//
//  Created by  zhiyundaohe on 17/12/17.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QJScanReaderViewDelegate <NSObject>
- (void)readerScanResult:(NSString *)result;
@end


@interface QJScanReaderView : UIView

//顶部视图
@property (nonatomic,strong) UIView* upView;

//底部视图
@property (nonatomic,strong) UIView * downView;

//左侧视图
@property (nonatomic,strong) UIView* leftView;

//右侧视图
@property (nonatomic,strong) UIView * rightView;


@property (nonatomic, weak) id<QJScanReaderViewDelegate> delegate;

@property (nonatomic,copy)UIImageView * readLineView;

@property (nonatomic,assign)BOOL is_Anmotion;

@property (nonatomic,assign)BOOL is_AnmotionFinished;

//批次号
@property (nonatomic,strong) UILabel *batchNumber;

//开启关闭扫描
- (void)start;

- (void)stop;

- (void)loopDrawLine;//初始化扫描线

//开关灯操作
- (void)turnTorchOn:(BOOL)on;


@end
