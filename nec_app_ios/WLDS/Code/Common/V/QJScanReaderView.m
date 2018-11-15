//
//  QJScanReaderView.m
//  CALayerCreate
//
//  Created by  zhiyundaohe on 17/12/17.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import "QJScanReaderView.h"
#import <AVFoundation/AVFoundation.h>


#define contentTitleColorStr @"666666" //正文颜色较深

//顶部视图高度预置
#define KUP_H kFitW(100.00)

@interface QJScanReaderView ()<AVCaptureMetadataOutputObjectsDelegate>{
    
    AVCaptureSession * session;
    
    NSTimer * countTime;
}

@property (nonatomic, strong) CAShapeLayer *overlay;

//开关灯按钮按钮
@property (nonatomic,strong) UIButton *button;

//动画完成时间
@property (nonatomic,strong) NSString *end;

@property (nonatomic,strong) NSDate *date;

@end


@implementation QJScanReaderView

/* * * * * * * * * *
 *
 * @ 懒加载开关按钮
 *
 * * * * * * * * * */
- (UIButton *)button{
    
    if (!_button) {
        
        //开关灯button
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [UIColor clearColor];
        _button.titleLabel.font = kFontSize(kFitW(15));
        _button.backgroundColor = kMainColor;
        [_button setTitle:@"开 灯" forState:(UIControlStateNormal)];
        [_button setTitleColor:kOrangeColor forState:(UIControlStateNormal)];
        _button.frame = CGRectMake(0, 0,kFitW(40), kFitW(40));
        [_button addTarget:self action:@selector(turnBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

/* * * * * * * * * *
 *
 * @ 懒加载批次编号
 *
 * * * * * * * * * */
- (UILabel *)batchNumber{
    
    if (!_batchNumber) {
        
        //批次编号
        _batchNumber = [[UILabel alloc] init];
        [_upView addSubview:_batchNumber];
        _batchNumber.textColor = [UIColor whiteColor];
        _batchNumber.backgroundColor = kBlueColor;
    }
    
    return _batchNumber;
}

- (id)initWithFrame:(CGRect)frame{
    
    if ((self = [super initWithFrame:frame])) {
        
        //默认时间1.5s
        self.end = @"";
        
        [self instanceDeviceHeight:frame.size.height];
    }
    
    return self;
}


- (void)instanceDeviceHeight:(CGFloat)height{
    
    //扫描区域
    UIImageView * scanZomeBack=[[UIImageView alloc] init];
    scanZomeBack.backgroundColor = [UIColor clearColor];
    scanZomeBack.layer.borderColor = [UIColor whiteColor].CGColor;
    scanZomeBack.layer.borderWidth = 2.5;
    scanZomeBack.image = [UIImage imageNamed:@"scanscanBg"];
    //添加一个背景图片
    CGRect mImagerect = CGRectMake(kFitW(60),KUP_H,kFitW(200), kFitW(200));
    [scanZomeBack setFrame:mImagerect];
    CGRect scanCrop=[self getScanCrop:mImagerect readerViewBounds:self.frame];
    [self addSubview:scanZomeBack];
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    output.rectOfInterest = scanCrop;
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        
        [session addInput:input];
    }
    
    if (output) {
        
        [session addOutput:output];
        
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes=a;
    }
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.layer.bounds;
    [self.layer insertSublayer:layer atIndex:0];
    
    [self setOverlayPickerView:self height:height];
    
    //开始捕获
    [session startRunning];
}

-(void)loopDrawLine{
    
    //判断是否存在时间
    if (self.end.length > 0) {
        
        //判断前后差值
        double cha = [NSDate timeInterval:[NSDate getCurrentTimeWithFormat:@"YYYY-MM-dd HH:mm:ss"] other:self.end];
        
        if (cha < 2) {
            
            return;
        }
    }
    
    _is_AnmotionFinished = NO;
    
    CGRect rect = CGRectMake(kFitW(60),KUP_H, kFitW(200), 2);
    
    if (_readLineView) {
        
        _readLineView.alpha = 1;
        
        _readLineView.frame = rect;
        
    }else{
        
        _readLineView = [[UIImageView alloc] initWithFrame:rect];
        
        [_readLineView setImage:[UIImage imageNamed:@"scanLine"]];
        
        [self addSubview:_readLineView];
    }
    
    WEAKSELF
    [UIView animateWithDuration:2.0 animations:^{
        
        //修改fream的代码写在这里
        _readLineView.frame =CGRectMake(kFitW(60),KUP_H + kFitW(200),kFitW(200), 2);
        
    } completion:^(BOOL finished) {
        
        if (!_is_Anmotion) {
            
            [self loopDrawLine];
            
            weakSelf.date = [NSDate date];
            //记录当前时间为结束时间
            weakSelf.end = [NSDate getCurrentTimeWithFormat:@"YYYY-MM-dd HH:mm:ss"];
        }
        
        _is_AnmotionFinished = YES;
    }];
}

//-(void)loopDrawLine{
//
//    //判断是否存在时间
//    if (self.end.length > 0) {
//
//        //判断前后差值
//        double cha = [NSDate timeInterval:[NSDate getCurrentTimeWithFormat:@"YYYY-MM-dd HH:mm:ss"] other:self.end];
//
//        if (cha < 2) {
//
//            return;
//        }
//    }
//
//    _is_AnmotionFinished = NO;
//
//    CGRect rect = CGRectMake(kFitW(60),KUP_H, kFitW(200), 2);
//
//    if (_readLineView) {
//
//        _readLineView.alpha = 1;
//
//        _readLineView.frame = rect;
//
//    }else{
//
//        _readLineView = [[UIImageView alloc] initWithFrame:rect];
//
//        [_readLineView setImage:[UIImage imageNamed:@"scanLine"]];
//
//        [self addSubview:_readLineView];
//    }
//
//    WEAKSELF
//    [UIView animateWithDuration:2.0 animations:^{
//
//        //修改fream的代码写在这里
//        _readLineView.frame =CGRectMake(kFitW(60),KUP_H + kFitW(200),kFitW(200), 2);
//
//    } completion:^(BOOL finished) {
//
//        if (!_is_Anmotion) {
//
//            [self loopDrawLine];
//
//        }
//        //记录当前时间为结束时间
//        weakSelf.end = [NSDate getCurrentTimeWithFormat:@"YYYY-MM-dd HH:mm:ss"];
//        _is_AnmotionFinished = YES;
//    }];
//}

- (void)setOverlayPickerView:(QJScanReaderView *)reader height:(CGFloat)height{
    
    CGFloat wid = kFitW(60);
    
    //最上部view
    CGFloat alpha = 0.6;
    _upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,KUP_H)];
    _upView.alpha = alpha;
    _upView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
    [reader addSubview:_upView];
    
    
    //左侧的view
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, _upView.v, wid,kFitW(200))];
    _leftView.alpha = alpha;
    _leftView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
    [reader addSubview:_leftView];
    
    
    //右侧的view
    _rightView = [[UIView alloc] initWithFrame:CGRectMake(kWidth - wid,_leftView.y, wid,_leftView.h)];
    _rightView.alpha = alpha;
    _rightView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
    [reader addSubview:_rightView];
    
    
    //底部view
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0,_rightView.v, kWidth, height - _leftView.v)];
    _downView.alpha = alpha;
    _downView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
    [reader addSubview:_downView];
    
}

#pragma mark ========   按钮点击事件   ========
- (void)turnBtnEvent:(UIButton *)button{
    
    button.selected = !button.selected;
    
    if (button.selected) {
        
        [self turnTorchOn:YES];
        
    }else{
        
        [self turnTorchOn:NO];
    }
    
}

#pragma mark ========   开关灯   ========
- (void)turnTorchOn:(BOOL)on{
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    
    if (captureDeviceClass != nil) {
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            
            if (on) {
                
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds{
    
    CGFloat x,y,width,height;
    
    //    width = (CGFloat)(rect.size.height+10)/readerViewBounds.size.height;
    //
    //    height = (CGFloat)(rect.size.width-50)/readerViewBounds.size.width;
    //
    //    x = (1-width)/2;
    //    y = (1-height)/2;
    
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    
    return CGRectMake(x, y, width, height);
    
}

- (void)start{
    
    [session startRunning];
}

- (void)stop{
    
    [session stopRunning];
}

#pragma mark - 扫描结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects && metadataObjects.count>0) {
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        //输出扫描字符串
        if (_delegate && [_delegate respondsToSelector:@selector(readerScanResult:)]) {
            
            [_delegate readerScanResult:metadataObject.stringValue];
        }
    }
}

#pragma mark - 颜色
//获取颜色
- (UIColor *)colorFromHexRGB:(NSString *)inColorString{
    
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString){
        
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    
    return result;
}





/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

