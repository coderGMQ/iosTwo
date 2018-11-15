//
//  WebViewController.m
//  Mariner
//
//  Created by zhiyundaohe on 2018/8/28.
//  Copyright © 2018年 QJJ. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *wenView;

@end

@implementation WebViewController

#pragma mark ========   视图加载完成   ========
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationController.navigationBar.translucent = NO;
    
    if (self.title.length > 0) {
        [self setFont:kTitFont color:kWhiteColor title:self.title];
    }    
    //创建导航栏
    [self createNavInWebView];
    
    //背景视图
    self.wenView.backgroundColor = kWhiteColor;
    
    //判断路径
    if (self.url.length > 0) {
        
        //判断是否以http开头
        if ([self.url hasPrefix:@"http"] == NO) {
            
            if ([self.url hasPrefix:@"/"]) {
                
                self.url = [kPictureUrlIp stringByAppendingString:self.url];
                
            }else{
                self.url = [serverUrl stringByAppendingString:self.url];
            }
        }
        
        NSLog(@"===url==路径====%@",_url);
        
        [self.wenView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
}

//创建导航栏
- (void)createNavInWebView{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInWebView)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}
//左侧返回按钮点击事件
- (void)backInWebView{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ========   UIWebViewDelegate   ========
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"==加载完成===");
    
//    /**接受完传值之后，oc给js传入函数值，带参数的*/
//    NSString * func = [NSString stringWithFormat:@"requestFullScreen();"];
//    [webView stringByEvaluatingJavaScriptFromString:func];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    NSLog(@"==加载错误===%@",error);
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
