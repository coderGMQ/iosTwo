
//  QJScanViewController.m
//  CALayerCreate
//
//  Created by  zhiyundaohe on 17/12/17.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import "QJScanViewController.h"
#import "QJScanReaderView.h"


#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>



#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define widthRate DeviceMaxWidth/320
#define IOS8 ([[UIDevice currentDevice].systemVersion intValue] >= 8 ? YES : NO)


@interface QJScanViewController ()<QJScanReaderViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>{
    
    QJScanReaderView * readview;//二维码扫描对象
    
    BOOL isFirst;//第一次进入该页面
    
    BOOL isPush;//跳转到下一级页面
}

@property (strong, nonatomic) CIDetector *detector;

//是否已经开灯
@property (nonatomic) BOOL open;


@end

@implementation QJScanViewController


#pragma mark ========      ========
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    [self setFont:kTitFont color:kWhiteColor title:self.title];
    
    isFirst = YES;
    isPush = NO;
    
    //初始化扫一扫对象
    [self InitScan];
    
    //样式布局
    [self createSubView];
    
}

//样式布局
- (void)createSubView{
    
    //提示文本
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = kFontSize(kFitW(14));
    label.textColor = kWhiteColor;
    label.text = @"将条码/二维码放入框内,即可自动扫描";
    label.frame = CGRectMake(0, readview.upView.h - kFitW(40), readview.downView.w, kFitW(30));
    //放置底部
    [readview.upView addSubview:label];


    CGFloat width = 120;
    
    CGFloat spacing = (kWidth - width) / 2;
    
    if ([self.title isEqualToString:@"扫一扫"]) {
        
        //点击视图图
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(spacing, (readview.downView.h - width) / 2, width, width)];
        [readview.downView addSubview:view];
        view.tag = 101;
        //视图添加手势
        [view clickWithDelegate:nil target:self action:@selector(clickViewInQJScan:)];
        //图片
        UIImageView *IV = [[UIImageView alloc] initWithFrame:CGRectMake((width - 40) / 2,0, 40, 40)];
        [view addSubview:IV];
        IV.contentMode = UIViewContentModeScaleAspectFit;
        IV.tag = 201;
        
        //文本信息
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,IV.v,width,30)];
        label.textColor = kWhiteColor;
        label.font = kFontSize(15);
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        //设置frame
        view.frame = CGRectMake(spacing, (readview.downView.h - label.v) / 2, width, label.v);
        
        label.text = @"点击照亮";
        IV.image = kSetImage(@"lightNormal");
        
        return;
    }else{
        
        CGFloat width = 120;
        
        CGFloat spacing = 50;
        
        for (int i = 0; i < 2; i++) {
            
            //点击视图图
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(spacing + i * (width + kWidth - (width + spacing) * 2), (readview.downView.h - width) / 2, width, width)];
            [readview.downView addSubview:view];
            view.tag = 100 + i;
            //视图添加手势
            [view clickWithDelegate:nil target:self action:@selector(clickViewInQJScan:)];
            //图片
            UIImageView *IV = [[UIImageView alloc] initWithFrame:CGRectMake((width - 40) / 2,0, 40, 40)];
            [view addSubview:IV];
            IV.contentMode = UIViewContentModeScaleAspectFit;
            IV.tag = 200 + i;
            
            
            //文本信息
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,IV.v,width,30)];
            label.textColor = kWhiteColor;
            label.font = kFontSize(15);
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            
            //设置frame
            view.frame = CGRectMake(spacing + i * (width + kWidth - (width + spacing) * 2), (readview.downView.h - label.v) / 2, width, label.v);
            
            if (0 == i) {
                
                IV.image = kSetImage(@"jianpan@2x");
                label.text = @"输入单号";
                
            }else{
                
                label.text = @"点击照亮";
                IV.image = kSetImage(@"lightNormal");
            }
        }
    }
 
}

#pragma mark ========    手势  ========
- (void)clickViewInQJScan:(UITapGestureRecognizer *)tap{
    
    switch (tap.view.tag) {
        case 100:{
            //输入单号
            SearchOrderViewController *vc = [[SearchOrderViewController alloc] init];
            vc.undoPage = self.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 101:{
            //开关灯
            
            self.open = !self.open;
            
            [self turnTorchOnScan:self.open];
            
            UIImageView *IV = (UIImageView *)[self.view viewWithTag:201];
            
            if (self.open) {
                
                IV.image = kSetImage(@"lightSelect");
            }else{
                IV.image = kSetImage(@"lightNormal");
            }
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark ========   开关灯   ========
- (void)openLightInQJScan:(UIButton *)button{
    
    button.selected = !button.selected;
    
    if (button.selected) {
        
        [self turnTorchOnScan:YES];
        
    }else{
        
        [self turnTorchOnScan:NO];
    }
}

#pragma mark ========   开关灯   ========
- (void)turnTorchOnScan:(bool)on{
    
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


#pragma mark - 返回
- (void)backInQJScan{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 初始化扫描
- (void)InitScan{

    if (readview) {
        [readview removeFromSuperview];
        readview = nil;
    }

    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInQJScan)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
    readview = [[QJScanReaderView alloc]initWithFrame:CGRectMake(0,0, DeviceMaxWidth, kHeight - NAV_HEIGHT)];
    readview.is_AnmotionFinished = YES;
    readview.backgroundColor = [UIColor clearColor];
    readview.delegate = self;
    readview.alpha = 0;
    
    //添加视图
    [self.view addSubview:readview];
    
    [UIView animateWithDuration:0.5 animations:^{
        readview.alpha = 1;
    }completion:^(BOOL finished) {
        
    }];

}

#pragma mark -QRCodeReaderViewDelegate
- (void)readerScanResult:(NSString *)result{
    
    
    [readview stop];

    readview.is_Anmotion = YES;
    
    //播放扫描二维码的声音
//    SystemSoundID soundID;
//
//    NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
//
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
//
//    AudioServicesPlaySystemSound(soundID);
    
    [self accordingQcode:result animated:YES scan:YES];
}

#pragma mark ========   扫描结果处理   ========
- (void)accordingQcode:(NSString *)code animated:(BOOL)animated scan:(BOOL)scan{
//
//    
//    if ([self.title isEqualToString:@"代收"]) {
//
//        //查询
//        [self checkReceipt:code];
//        
//    }else
    if ([self.title isEqualToString:@"扫一扫"]) {
        
        //判断是否执行回调block
        if (self.backCodeBlock) {
            
            self.backCodeBlock(code);
            //返回
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        
        WEAKSELF
        [NetRequestManger POST:@"lxzy/order/findOrderByOrderCode" params:@{@"orderCode":code} success:^(id response) {
            
            //数据转换
            NSDictionary *dictionary = (NSDictionary *)response;
            
            //数据请求值
            BOOL success = [dictionary[@"success"] boolValue];
            
            //判断是否请求成功
            if (success == YES) {
                
                MessageDetailsController *vc = [[MessageDetailsController alloc] init];
                vc.title = @"订单详情";

                vc.orderCode = code;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
            }else{
                
                if (readview) {
                    
                    [weakSelf reStartScan];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if (readview) {
                
                [weakSelf reStartScan];
            }
        }];
        
    }
}

//0 未登录   1 手机号匹配（收货）   2 手机号不匹配（代收）
#pragma mark ========   查看收货手机号   ========
- (void)checkReceipt:(NSString *)code{
    
    
    WEAKSELF
    [NetRequestManger POST:@"lxzy/order/checkReceipt" params:@{@"orderCode":code} success:^(id response) {
        
        //数据转换
        NSDictionary *dictionary = (NSDictionary *)response;
        
        NSString *data = [dictionary stringWithKey:@"data"];
        
        if ([data isEqualToString:@"2"]) {
            //可以代收
            MessageDetailsController *vc = [[MessageDetailsController alloc] init];
            vc.title = @"订单详情";
            vc.orderCode = code;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([data isEqualToString:@"1"]){
            
            
        }else if ([data isEqualToString:@"0"]){
            
            [weakSelf waringShow:@"用户未登录" over:^(BOOL response) {
                
                //跳转至登录页面
                [weakSelf toLogin:^(BOOL response) {
                    
                    //再次查询
                    [weakSelf checkReceipt:code];
                    
                } cancel:^(BOOL response) {
                    
                    [weakSelf reStartScan];
                }];
            }];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark ========   重新扫描   ========
- (void)reStartScan{
    
    readview.is_Anmotion = NO;
    
    if (readview.is_AnmotionFinished == YES) {
        
        [readview loopDrawLine];
    }
    
    [readview start];
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //隐藏操作
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (isFirst || isPush) {
        
        if (readview) {
            
            [self reStartScan];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (readview) {
        isFirst = NO;
        isPush = YES;
        [readview stop];
        
        readview.is_Anmotion = YES;
    }
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

    if (isFirst) {
        isFirst = NO;
    }
}


//返回数据
- (void)backWithDataArray{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ========   内存警告   ========
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] == YES && !self.view.window) {
        
        self.view = nil; // 清理滞空
        
    }else{
        
        
    }
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
