//
//  QRCodeViewController.m
//  BNZY
//
//  Created by zhiyundaohe on 2017/12/22.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import "QRCodeViewController.h"

#import <Photos/PHPhotoLibrary.h>

#import <Photos/PHAssetChangeRequest.h>

@interface QRCodeViewController ()

@property (nonatomic,strong) UIImageView *qRIV;

@end

@implementation QRCodeViewController

#pragma mark ========   视图懒加载   ========
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"扫扫二维码";
    
    //创建视图
    [self createSubViewInQRCode];
    
    if (self.back == YES) {
        
        WEAKSELF
        self.backBlock = ^{
            
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
    }
}

/**
 *
 * @
 *
 **/
- (void)createSubViewInQRCode{

    if (self.data.length == 0) {
        
        self.data = @"未传递数据";
        
        [self waringShow:@"二维码生成失败"];
        
        return;
    }

    //预置宽度
    CGFloat width = kWidth - kFitW(40);
    
    //二维码图片
    _qRIV = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth - width) / 2.0, (kHeight - NAV_HEIGHT - width) / 2 - kFitW(45), width, width)];
    [self.view addSubview:_qRIV];
    _qRIV.userInteractionEnabled = YES;
    _qRIV.image = [self createQRCode];
    
    //初始化一个长按手势
//    UILongPressGestureRecognizer *longPressGest = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressView:)];
//    [_qRIV addGestureRecognizer:longPressGest];
    
    //文本信息
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,_qRIV.v, kWidth,kFitW(60))];
//    label.text = [NSString stringWithFormat:@"请扫一扫上放二维码，数据:%@",self.data];
    label.text = @"请扫一扫上方二维码";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = kFontSize(kFitW(16));
    label.textColor = KTEXT_COLOR;
    [self.view addSubview:label];
//    label.backgroundColor = kMainColor;
}

- (void)loadImageFinished:(UIImage *)image
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        
    }];
}

//作者：杰嗒嗒的阿杰
//链接：https://www.jianshu.com/p/bf20733ba19b
//來源：简书
//著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
#pragma mark ========   长按手势   ========
- (void)longPressView:(UILongPressGestureRecognizer *)tap{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存二维码" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    WEAKSELF
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"保存" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {

        [weakSelf loadImageFinished:weakSelf.qRIV.image];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDestructive) handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//生成二维码
- (UIImage *)createQRCode{
    
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    //    NSString *dataString = @"http://www.zhuyundaohe.com/data/BNZY170830.apk";
    
//    NSString *dataString = @"http://www.baidu.com";
    
    NSData *data = [self.data dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5.将CIImage转换成UIImage，并放大显示
    return  [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size{
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
