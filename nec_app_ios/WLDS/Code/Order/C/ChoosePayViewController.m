//
//  ChoosePayViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/16.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "ChoosePayViewController.h"

@interface ChoosePayViewController ()

@property (nonatomic) NSInteger type;

@end

@implementation ChoosePayViewController

//手势点击
- (IBAction)tapInChoosePay:(UITapGestureRecognizer *)sender {
    
    //获取位置信息
    NSInteger index = sender.view.tag - 100;
    
    if (self.type == index) {
        
        return;
    }
    
    //判断位置
    if (index == 0) {
        
        //选中
        UIImageView *IV = (UIImageView *)[self.view viewWithTag:200];
        IV.image = kSetImage(@"dianxuan_m@2x");
        //未选中
        UIImageView *otIV = (UIImageView *)[self.view viewWithTag:201];
        otIV.image = kSetImage(@"dianxuan_un@2x");
        
    }else{
        
        //选中
        UIImageView *IV = (UIImageView *)[self.view viewWithTag:201];
        IV.image = kSetImage(@"dianxuan_m@2x");
        //未选中
        UIImageView *otIV = (UIImageView *)[self.view viewWithTag:200];
        otIV.image = kSetImage(@"dianxuan_un@2x");
    }
    
    //记录位置
    self.type = index;
}

#pragma mark ========   去支付   ========
- (IBAction)goPay:(UIButton *)sender {
    
    if (self.type == 0) {
        
        //微信支付
        [NetRequestManger POST:@"weixinpay/pay" params:@{@"orderCode":self.orderCode} success:^(id response) {

            NSDictionary *dictionary = (NSDictionary *)response;

            //结果状态码
            NSNumber *success = [dictionary objectForKey:@"success"];

            if (1 == [success integerValue]) {

                //绑定观察者
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResult:) name:@"WXPay" object:nil];

                //获取微信支付返回参数
                NSDictionary *resultObj = [NSMutableDictionary nullDic:dictionary[@"data"]];
                //调起微信支付
                PayReq* req      = [[PayReq alloc] init];
                //商户ID
                req.partnerId     = [resultObj objectForKey:@"partnerid"];
                req.package     = @"Sign=WXPay";
                req.prepayId     = [resultObj objectForKey:@"prepayid"];
                req.nonceStr      = [resultObj objectForKey:@"noncestr"];
                req.timeStamp  = [kDictString(resultObj, @"timestamp") intValue];
                req.sign                = [resultObj objectForKey:@"sign"];
                [WXApi sendReq:req];
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        }];
        
    }else if (self.type == 1){
        
        //调用接口
        [NetRequestManger POST:@"pay/getOrderInfo" params:@{@"orderCode":self.orderCode} success:^(id response) {
            
            //数据转换
            NSDictionary *dictionary = (NSDictionary *)response;
            
            //数据请求值
            BOOL success = [dictionary[@"success"] boolValue];
            
            //判断是否请求成功
            if (success == YES) {
                
                //调用集合
                NSString *objStr = [dictionary objectForKey:@"data"];
                
                //支付宝支付绑定通知
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResult:) name:@"alipay" object:nil];
                
                [[AlipaySDK defaultService] payOrder:objStr fromScheme:@"WLDSAliay" callback:^(NSDictionary *resultDic) {
                    
                    //支付宝支付结果通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"alipay" object:resultDic];
                }];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
}


#pragma mark ========   支付结果通知   ========
- (void)payResult:(NSNotification *)info{
    
    //支付是否成功
    BOOL success = NO;
    
    //判断支付方式是否为微信支付回调结果通知
    if ([info.name isEqualToString:@"WXPay"]) {
        
        //获取微信支付结果返回对象
        NSString *result = (NSString *)info.object;
        
        //判断是否成功支付
        if ([result isEqualToString:@"success"]) {
            
            success = YES;
        }
    }else{
        
        //支付宝支付返回结果
        NSDictionary *result = (NSDictionary *)info.object;
        
        NSString *resultStatus = kDictString(result, @"resultStatus");
        
        //9000 支付成功的状态码
        if ([resultStatus isEqualToString:@"9000"]) {
            
            success = YES;
        }
    }
    
    //判断是否支付成功
    if (success == YES) {
        
        BLOCK_EXEC(self.updatePayBlock,YES);
        //返回根视图页面
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //默认支付方式
    self.type = 0;
    
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"选择支付方式"];
    
    self.view.backgroundColor = kLikeColor;
    
    [self createNavInChoosePay];
}


//创建导航栏
- (void)createNavInChoosePay{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInChoosePay)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}

//左侧返回按钮点击事件
- (void)backInChoosePay{
    
    [self.navigationController popViewControllerAnimated:YES];
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

