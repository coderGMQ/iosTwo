//
//  MessageDetailsController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/6.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "MessageDetailsController.h"

#import "OrderRemarkViewController.h"

#import "MessageDetailsTableViewCell.h"

#import "ChoosePayViewController.h"

#import "AccuseViewController.h"

@interface MessageDetailsController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic)  UIView *footerView;

//订单
@property (weak, nonatomic) IBOutlet UILabel *order;
//运单
@property (weak, nonatomic) IBOutlet UILabel *number;
//类型
@property (weak, nonatomic) IBOutlet UILabel *type;

@property (weak, nonatomic) IBOutlet UILabel *statue;
@property (weak, nonatomic) IBOutlet UIImageView *nextIM;

//展示视图
@property (nonatomic,strong) UIView *showView;

//输入验证码
@property (nonatomic,strong) UITextField *tf;

//数据集合
@property (nonatomic,strong) NSMutableDictionary *data;

//验证短信的key值
@property (nonatomic,strong) NSString *key;

@end

@implementation MessageDetailsController
//点击按钮
- (IBAction)tapOrderCode:(UITapGestureRecognizer *)sender {
    
    //运单编号
    NSString *code = [self.data stringWithKey:@"orderCode"];
    
    if (code.length > 0) {
        
        WebViewController *web = [[WebViewController alloc] init];
        web.url = [@"pages/locate.html?" stringByAppendingString:code];
        web.title = @"订单跟踪";
        [self.navigationController pushViewController:web animated:YES];
    }
}

//去投诉
- (IBAction)goToComplain:(UITapGestureRecognizer *)sender {
    
    
    //运单编号
    NSString *code = [self.data stringWithKey:@"waybillCode"];
    
    if (code.length > 0) {
        AccuseViewController *vc = [[AccuseViewController alloc] init];
        vc.code = code;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



/* * * * * * * * * *
 *
 * @ 展示窗口视图
 *
 * * * * * * * * * */
- (UIView *)showView{
    
    if (!_showView) {
        
        _showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _showView.backgroundColor = kWindowColor;
        //获取窗口
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //视图添加到当前窗口
        [window addSubview:_showView];
        
        //主显视图
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = kWhiteColor;
        [_showView addSubview:backView];
        
        //文本信息
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, kWidth - kFitW(40), kFitW(50))];
        label.textColor = kWhiteColor;
        label.font = kFontSize(kFitW(15));
        label.backgroundColor = kMainColor;
        label.text = @"请输入短信验证码";
        label.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:label];
        
        _tf = [[UITextField alloc] initWithFrame:CGRectMake(label.x + kFitW(20), label.v + kFitW(10), label.w - kFitW(15*2), kFitW(30))];
        [backView addSubview:_tf];
        _tf.font = kFontSize(kFitW(14));
        _tf.textAlignment = NSTextAlignmentCenter;
        _tf.keyboardType = UIKeyboardTypeNumberPad;
        
        
        //底部细线
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(_tf.x, _tf.v - 1.0, _tf.w, 1.0)];
        [backView addSubview:line];
        line.backgroundColor = kLikeColor;
        
        
        //按钮宽度
        CGFloat width = line.v + kFitW(70);
        
        //设置frame
        backView.frame = CGRectMake((kWidth - label.w) / 2,(kHeight - width) / 2 - kFitW(50) , label.w, width);
        
        //按钮宽度
        width = (label.w - kFitW(25 * 2 + 30)) / 2;
        
        //循环创建
        for (int i = 0; i < 2; i++) {
            
            //按钮创建
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.titleLabel.font = kFontSize(16);
            [backView addSubview:button];
            button.frame = CGRectMake(kFitW(25) + (width + kFitW(30)) * i,line.v + kFitW(15), width,40);
            [button cropLayer:5];
            [button setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
            
            //添加监听事件
            [button addTarget:self action:@selector(clickSureButton:) forControlEvents:(UIControlEventTouchUpInside)];
            
            if (0 == i) {
                
                button.backgroundColor = kLightGrayColor;
                [button setTitle:@"取消" forState:(UIControlStateNormal)];
                
            }else{
                
                button.backgroundColor = kOrangeColor;
                [button setTitle:@"确认" forState:(UIControlStateNormal)];
            }
        }
    }
    return _showView;
}

//窗口视图展示
- (void)clickSureButton:(UIButton *)button{
    
    kKeyBoardHiden;
    
    if ([button.titleLabel.text isEqualToString:@"确认"]) {
        
        //判断是否输入文本
        if (self.tf.text.length > 0) {
            
            //收货接口
            [self receiptGoods];
            
        }else{
            
            [self waringShow:@"请输入验证码"];
        }
    }
    
    //隐藏视图
    self.showView.hidden = YES;
}
/* * * * * * * * * *
 *
 * @
 *
 * * * * * * * * * */
- (NSMutableDictionary *)data{
    
    if (!_data) {
        _data = [[NSMutableDictionary alloc] init];
    }
    return _data;
}

/* * * * * * * * * *
 *
 * @ 懒加载底部视图
 *
 * * * * * * * * * */
- (UIView *)footerView{
    
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = kLikeColor;
    }
    return _footerView;
}

#pragma mark ========   根据底部视图进行布局   ========
- (void)layoutFooterView{
    
    //遍历子视图
    for (UIView *view in self.footerView.subviews) {
        
        //移除视图
        [view removeFromSuperview];
    }
    
    //位置
    CGFloat y = 5;
    
    //回单数量
    
    
    //回单状态
    NSString *receiptStatus = [self.data stringWithKey:@"receiptStatus"];
    
    //背景图
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,y, kWidth,45)];
    [self.footerView addSubview:backView];
    backView.backgroundColor = kWhiteColor;
    
    //底部细线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, backView.h - 1.0, kWidth, 1.0)];
    [backView addSubview:line];
    line.backgroundColor = kLikeColor;
    //文本信息
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,180,line.v)];
    label.textColor = KTEXT_COLOR;
    label.font = kFontSize(14);
    
    //回单类型
    NSString *type = [self.data stringWithKey:@"receiptType"];
    
    if ([type isEqualToString:@"0"]) {
        
        type = @"厂单";
    }else if ([type isEqualToString:@"1"]){
        
        type = @"回执";
    }else if ([type isEqualToString:@"2"]){
        
        type = @"面单";
    }else if ([type isEqualToString:@"3"]){
        
        type = @"收条";
    }
    //回单数量
    NSString *receipt = [self.data stringWithKey:@"receipt"];
    [label changeColor:kRedColor prep:@"回单份数: " middle:[NSString stringWithFormat:@"%@ 份 ",receipt] last:type];
    //        label.text = [NSString stringWithFormat:@"回单份数: %@ 份 %@",receipt,type];
    [backView addSubview:label];
    
    //按钮创建
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.titleLabel.font = label.font;
    [backView addSubview:button];
    button.frame = CGRectMake(backView.w - 80,backView.h * 0.2,70,backView.h * 0.6);
    
    [button setTitleColor:kMainColor forState:(UIControlStateNormal)];
    
    if ([receiptStatus isEqualToString:@"0"]) {
        
        [button setTitle:@"完成" forState:(UIControlStateNormal)];
    }else{
        [button setTitle:@"已完成" forState:(UIControlStateNormal)];
    }
    //添加监听事件
    [button addTarget:self action:@selector(clickButtonInFooterView:) forControlEvents:(UIControlEventTouchUpInside)];
    
    //记录坐标
    y = backView.v;

//    NSString *receipt = [self.data stringWithKey:@"receipt"];
    
//    if (receipt.integerValue > 0) {
//
//        //回单状态
//        NSString *receiptStatus = [self.data stringWithKey:@"receiptStatus"];
//
//        //背景图
//        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,y, kWidth,45)];
//        [self.footerView addSubview:backView];
//        backView.backgroundColor = kWhiteColor;
//
//        //底部细线
//        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, backView.h - 1.0, kWidth, 1.0)];
//        [backView addSubview:line];
//        line.backgroundColor = kLikeColor;
//        //文本信息
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,180,line.v)];
//        label.textColor = KTEXT_COLOR;
//        label.font = kFontSize(14);
//
//        //回单类型
//        NSString *type = [self.data stringWithKey:@"receiptType"];
//
//        if ([type isEqualToString:@"0"]) {
//
//            type = @"厂单";
//        }else if ([type isEqualToString:@"1"]){
//
//            type = @"回执";
//        }else if ([type isEqualToString:@"2"]){
//
//            type = @"面单";
//        }else if ([type isEqualToString:@"3"]){
//
//            type = @"收条";
//        }
//
//        [label changeColor:kRedColor prep:@"回单份数: " middle:[NSString stringWithFormat:@"%@ 份 ",receipt] last:type];
////        label.text = [NSString stringWithFormat:@"回单份数: %@ 份 %@",receipt,type];
//        [backView addSubview:label];
//
//        //按钮创建
//        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        button.titleLabel.font = label.font;
//        [backView addSubview:button];
//        button.frame = CGRectMake(backView.w - 80,backView.h * 0.2,70,backView.h * 0.6);
//
//        [button setTitleColor:kMainColor forState:(UIControlStateNormal)];
//
//        if ([receiptStatus isEqualToString:@"0"]) {
//
//            [button setTitle:@"完成" forState:(UIControlStateNormal)];
//        }else{
//            [button setTitle:@"已完成" forState:(UIControlStateNormal)];
//        }
//        //添加监听事件
//        [button addTarget:self action:@selector(clickButtonInFooterView:) forControlEvents:(UIControlEventTouchUpInside)];
//
//        //记录坐标
//        y = backView.v;
//    }
    
    
    //运单状态为"0"，订单状态非“已取消”状态  ,可撤销运单
    NSString *waybillStatus = [self.data stringWithKey:@"waybillStatus"];
    
    //订单状态
    NSString *orderStatus = [self.data stringWithKey:@"orderStatus"];

    if ([waybillStatus isEqualToString:@"0"] && ![orderStatus isEqualToString:@"已取消"]) {
        
        //按钮创建
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.titleLabel.font = kFontSize(14);
        [self.footerView addSubview:button];
        button.frame = CGRectMake(0,y, kWidth,40);
        
        button.backgroundColor = kGrayColor;
        [button setTitle:@"撤销订单" forState:(UIControlStateNormal)];
        [button setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
        
        //添加监听事件
        [button addTarget:self action:@selector(clickButtonInFooterView:) forControlEvents:(UIControlEventTouchUpInside)];
        
        //记录坐标
        y = button.v;
    }
    //接收状态
    NSString *isAccept = [self.data stringWithKey:@"isAccept"];
    
    if ([isAccept isEqualToString:@"有异常"]) {
        
        //按钮创建
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.titleLabel.font = kFontSize(14);
        [self.footerView addSubview:button];
        button.frame = CGRectMake(0,y + 10, kWidth,40);
        
        button.backgroundColor = kGrayColor;
        [button setTitle:@"再次下单" forState:(UIControlStateNormal)];
        [button setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
        
        //添加监听事件
        [button addTarget:self action:@selector(clickButtonInFooterView:) forControlEvents:(UIControlEventTouchUpInside)];
        
        //记录坐标
        y = button.v;
    }
    
    //payBelong  1 需要支付    2 不需要支付
    NSString *payBelong = [self.data stringWithKey:@"payBelong"];
    if ([payBelong isEqualToString:@"1"]) {
        
        //文本信息
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,y, kWidth,40)];
        label.textColor = kMainColor;
        label.font = kFontSize(14);
        label.backgroundColor = kWhiteColor;
        label.text = [NSString stringWithFormat:@"支付金额:￥%.2f",[self.data[@"cast"] doubleValue]];
        label.textAlignment = NSTextAlignmentCenter;
        [self.footerView addSubview:label];
        
        
        //按钮创建
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.titleLabel.font = kFontSize(16);
        [self.footerView addSubview:button];
        button.frame = CGRectMake(0,label.v, kWidth,40);
        
        button.backgroundColor = kMainColor;
        [button setTitle:@"支付" forState:(UIControlStateNormal)];
        [button setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
        
        //记录位置
        y = button.v;
        //添加监听事件
        [button addTarget:self action:@selector(clickButtonInFooterView:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    //receiveBelong  1 可收货    2 不可收货
    NSString *receiveBelong = [self.data stringWithKey:@"receiveBelong"];
    if ([receiveBelong isEqualToString:@"1"]) {
        
        //底部细线
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, y, kWidth, 10.0)];
        [self.footerView addSubview:line];
        line.backgroundColor = kLikeColor;
        
        //按钮创建
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.titleLabel.font = kFontSize(16);
        [self.footerView addSubview:button];
        //设置标签
        button.tag = 7688760;
        button.frame = CGRectMake(0,line.v, kWidth,40);
        
        button.backgroundColor = kOrangeColor;
//        orderBelong 2 收货单 3 代收货单
        NSString *orderBelong = [self.data stringWithKey:@"orderBelong"];
        
        if ([orderBelong isEqualToString:@"2"]) {
            
            [button setTitle:@"收货" forState:(UIControlStateNormal)];
            
        }else if ([orderBelong isEqualToString:@"3"]) {
            
            [button setTitle:@"代收" forState:(UIControlStateNormal)];
        }
        
        [button setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
        
        //添加监听事件
        [button addTarget:self action:@selector(clickButtonInFooterView:) forControlEvents:(UIControlEventTouchUpInside)];
        //记录位置
        y = button.v;
    }
    
    //判断是否存在高度
    if (y > 5) {
        
        //底部细线
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,y, kWidth, 15.0)];
        [self.footerView addSubview:line];
        line.backgroundColor = kWhiteColor;
        //frame设置
        self.footerView.frame = CGRectMake(0, 0, kWidth,line.v);
        
        self.tableView.tableFooterView = self.footerView;
    }
}

#pragma mark ========   底部视图按钮操作   ========
- (void)clickButtonInFooterView:(UIButton *)button{
    
    //获取按钮名称
    NSString *title = button.titleLabel.text;
    
    if ([title isEqualToString:@"支付"]) {
        
        ChoosePayViewController *vc = [[ChoosePayViewController alloc] init];
        vc.orderCode = [self.data stringWithKey:@"orderCode"];
        
        WEAKSELF
        vc.updatePayBlock = ^(BOOL success) {
            
            if (success == YES) {
                //获取数据
                [weakSelf gainDataInMessageDetails];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"是否确认%@?",title] preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDestructive) handler:nil]];
        
        WEAKSELF
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            if ([title isEqualToString:@"完成"]) {
                
                //订单完成按钮（原来回单回收）
                [NetRequestManger POST:@"lxzy/order/recycleReceipt" params:@{@"orderCode":weakSelf.orderCode} success:^(id response) {
                    
                    //数据转换
                    NSDictionary *dictionary = (NSDictionary *)response;
                    
                    //数据请求值
                    BOOL success = [dictionary[@"success"] boolValue];
                    
                    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
                    //展示风火轮时，禁止其他操作
                    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
                    [SVProgressHUD setBackgroundColor:kLikeColor];
                    [SVProgressHUD setForegroundColor:KTEXT_COLOR];
                    [SVProgressHUD dismissWithDelay:1.0];
 
                    //判断是否请求成功
                    if (success == YES) {

                        [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dictionary[@"msg"]];
                        
                        //观察状态
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successBack) name:@"SVProgressHUDDidDisappearNotification" object:nil];
                    }else{
                        
                        [SVProgressHUD showImage:kSetImage(@"fail@2x") status:dictionary[@"msg"]];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                
            }else if ([title isEqualToString:@"撤销订单"]) {
                
                [NetRequestManger POST:@"lxzy/order/cancelOrder" params:@{@"orderCode":weakSelf.orderCode} success:^(id response) {
                    
                    //数据转换
                    NSDictionary *dictionary = (NSDictionary *)response;
                    
                    //数据请求值
                    BOOL success = [dictionary[@"success"] boolValue];
                    
                    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
                    //展示风火轮时，禁止其他操作
                    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
                    [SVProgressHUD setBackgroundColor:kLikeColor];
                    [SVProgressHUD setForegroundColor:KTEXT_COLOR];
                    [SVProgressHUD dismissWithDelay:1.0];
                    
                    //判断是否请求成功
                    if (success == YES) {
                        
                        [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dictionary[@"msg"]];
                        
                        //观察状态
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successBack) name:@"SVProgressHUDDidDisappearNotification" object:nil];
                    }else{
                        
                        [SVProgressHUD showImage:kSetImage(@"fail@2x") status:dictionary[@"msg"]];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                
            }else if ([title isEqualToString:@"再次下单"]) {
                
                [NetRequestManger POST:@"biz/waybill/verifyOrder" params:@{@"orderCode":weakSelf.orderCode} success:^(id response) {
                    
                    //数据转换
                    NSDictionary *dictionary = (NSDictionary *)response;
                    
                    //数据请求值
                    BOOL success = [dictionary[@"success"] boolValue];
                    
                    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
                    //展示风火轮时，禁止其他操作
                    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
                    [SVProgressHUD setBackgroundColor:kLikeColor];
                    [SVProgressHUD setForegroundColor:KTEXT_COLOR];
                    [SVProgressHUD dismissWithDelay:1.0];
                    
                    //判断是否请求成功
                    if (success == YES) {

                        [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dictionary[@"msg"]];
                        
                        //观察状态
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successBack) name:@"SVProgressHUDDidDisappearNotification" object:nil];
                    }else{
                        
                        [SVProgressHUD showImage:kSetImage(@"fail@2x") status:dictionary[@"msg"]];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                
            }else if ([title isEqualToString:@"收货"]) {
                
                //收货接口
                [weakSelf receiptGoods];
                
            }else if ([title isEqualToString:@"代收"]) {
                
                //代收需要短信验证
                [NetRequestManger POST:@"lxzy/order/getCheckNum" params:@{@"orderCode":weakSelf.orderCode} success:^(id response) {
                    
                    //数据转换
                    NSDictionary *dictionary = (NSDictionary *)response;
                    
                    //数据请求值
                    BOOL success = [dictionary[@"success"] boolValue];
                    
                    //判断是否请求成功
                    if (success == YES) {
                        
                        NSDictionary *data = dictionary[@"data"];
                        
                        //验证key
                        weakSelf.key = [data stringWithKey:@"key"];
                        
                        //展示视图
                        weakSelf.showView.hidden = NO;
                        [weakSelf.tf becomeFirstResponder];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
  
}

#pragma mark ========   操作成功返回   ========
- (void)successBack{
    
    //回调
    BLOCK_EXEC(self.backMessageBlock,YES);
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ========   收货或者代收操作   ========
- (void)receiptGoods{
    
    NSMutableDictionary *obj = [[NSMutableDictionary alloc] initWithDictionary:@{@"orderCode":self.orderCode}];
    
    if (self.key.length > 0) {
        
        //代收参数设置
        [obj setObject:self.key forKey:@"key"];
        
        [obj setObject:self.tf.text forKey:@"checkNum"];
    }

    //orderCode key checkNum
    [NetRequestManger POST:@"lxzy/order/receiptGoods" params:obj success:^(id response) {
        
        //数据转换
        NSDictionary *dictionary = (NSDictionary *)response;
        
        //数据请求值
        BOOL success = [dictionary[@"success"] boolValue];
        
        [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
        //展示风火轮时，禁止其他操作
        [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
        [SVProgressHUD setBackgroundColor:kLikeColor];
        [SVProgressHUD setForegroundColor:KTEXT_COLOR];
        [SVProgressHUD dismissWithDelay:1.0];
        
        //判断是否请求成功
        if (success == YES) {

            [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dictionary[@"msg"]];
            
            //观察状态
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successBack) name:@"SVProgressHUDDidDisappearNotification" object:nil];
        }else{
            
            [SVProgressHUD showImage:kSetImage(@"fail@2x") status:dictionary[@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark ========   视图加载完成   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //黑色素线隐藏
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:self.title];
    
    [self createNavInMessageDetails];
    
    //接口获取数据
    if (self.orderCode.length > 0) {
        //记录编码
        [HelperSingle shareSingle].code = self.orderCode;
        
        //获取数据
        [self gainDataInMessageDetails];
    }else{
        
        //判断是否存在静态数据
        if (self.data.allKeys > 0) {
            
            //布局底部视图
            [self layoutFooterView];
        }
    }
    
    //图片赋值
    self.nextIM.image = [UIImage changeImage:kSetImage(@"next@2x") color:kWhiteColor];
}

#pragma mark ========   获取数据   ========
- (void)gainDataInMessageDetails{
    
    WEAKSELF
    [NetRequestManger POST:@"lxzy/order/findOrderByOrderCode" params:@{@"orderCode":self.orderCode} success:^(id response) {
        
        //数据转换
        NSDictionary *dictionary = (NSDictionary *)response;
        
        //数据请求值
        BOOL success = [dictionary[@"success"] boolValue];
        
        //判断是否请求成功
        if (success == YES) {
            
            NSDictionary *data = [NSMutableDictionary nullDic:dictionary[@"data"]];
            [weakSelf.data setValuesForKeysWithDictionary:data];
            
            //订单编号
            weakSelf.order.text = [NSString stringWithFormat:@"订单编号: %@",[weakSelf.data stringWithKey:@"orderCode"]];
            //运单编号
            weakSelf.number.text = [NSString stringWithFormat:@"运单编号: %@",[weakSelf.data stringWithKey:@"waybillCode"]];
            //订单类型
            weakSelf.type.text = [NSString stringWithFormat:@"订单类型: %@",[weakSelf.data stringWithKey:@"orderType"]];
            //订单状态
            weakSelf.statue.text = [NSString stringWithFormat:@"订单状态: %@",[weakSelf.data stringWithKey:@"orderStatus"]];
            
            //刷新页面
            [weakSelf.tableView reloadData];
            
            //布局底部视图
            [weakSelf layoutFooterView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//创建导航栏
- (void)createNavInMessageDetails{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInMessageDetails)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
    if ([self.title isEqualToString:@"订单详情"]) {
        
        self.tableView.tableHeaderView = self.headerView;
        
        //右侧按钮
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"评价" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtoonInMessageDetails)];
        [rightBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kTitFont,NSFontAttributeName, nil] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightBar;
        rightBar.tintColor = kWhiteColor;

        //订单编号
        self.order.text = [NSString stringWithFormat:@"订单编号: %@",[self.data stringWithKey:@"orderCode"]];
        //运单编号
        self.number.text = [NSString stringWithFormat:@"运单编号: %@",[self.data stringWithKey:@"waybillCode"]];
        //订单类型
        self.type.text = [NSString stringWithFormat:@"订单类型: %@",[self.data stringWithKey:@"orderType"]];
        //订单状态
        self.statue.text = [NSString stringWithFormat:@"订单状态: %@",[self.data stringWithKey:@"orderStatus"]];
    }
    
}

#pragma mark ========   右侧按钮   ========
- (void)rightBarButtoonInMessageDetails{
    
    NSString *orderCode = [self.data stringWithKey:@"orderCode"];
    if (orderCode.length == 0) {
        return;
    }
    //commentBelong  1 可评价     2 不可评价
    NSString *commentBelong = [self.data stringWithKey:@"commentBelong"];
    if ([commentBelong isEqualToString:@"1"] == NO) {
        return;
    }
    OrderRemarkViewController *vc = [[OrderRemarkViewController alloc] init];
    vc.orderCode = orderCode;
    [self.navigationController pushViewController:vc animated:YES];

}

//左侧返回按钮点击事件
- (void)backInMessageDetails{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ========   UITableViewDataSource/UITableViewDelegate   ========
//分区数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}

//单个分区cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

//表头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}
//表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000000001;
}

//表尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 5)];
    
    return view;
}
//表尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //    @ 一高度:178 四：197 二、三、五：动态高度
    
//    if (indexPath.section == 0) {
//
//        return 212;
//
//    }else if (indexPath.section == 1) {
//
//        return 178;
//
//    }else{
//
//        return UITableViewAutomaticDimension;
//    }
    
    if (indexPath.section == 0) {
        
        return 212;
        
    }else if (indexPath.section == 1) {
        
        return 208;
        
    }else{
        
        return UITableViewAutomaticDimension;
    }
}
//预估高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
//返回cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageDetailsTableViewCell *cell = [MessageDetailsTableViewCell messageDetailsTableViewCellWith:tableView indexPath:indexPath data:self.data];
    
    return cell;
    
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
