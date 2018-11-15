//
//  AccuseTypeViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/23.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "AccuseTypeViewController.h"
//联系物流公司
#import "ContactLogisticsViewController.h"
//平台协商
#import "NegotiateViewController.h"

@interface AccuseTypeViewController ()

@end

@implementation AccuseTypeViewController

/* * * * * * * * * *
 *
 * @ 懒加载数据
 *
 * * * * * * * * * */
- (NSMutableDictionary *)obj{
    
    if (!_obj) {
        _obj = [[NSMutableDictionary alloc] init];
    }
    return _obj;
}

//手势点击事件
- (IBAction)tapInAccuseType:(UITapGestureRecognizer *)sender {
 
    
//    "orgName" : "南京智运道合网络科技有限公司",
//    "orgPhone" : "333",
//    "declaredValue" : 3
    
    switch (sender.view.tag) {
        case 100:{
            //直接联系物流公司
            ContactLogisticsViewController *vc = [[ContactLogisticsViewController alloc] init];
            vc.obj = self.obj;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 101:{
            //购买了货物险
            double declaredValue = [[self.obj stringWithKey:@"declaredValue"] doubleValue];
            if (declaredValue > 0) {
                //跳转至理赔流程
                
            }else{
                [self waringShow:@"改订单未投保"];
            }
        }
            break;
        case 102:{
            //与平台协商
            NegotiateViewController *vc = [[NegotiateViewController alloc] init];
            vc.obj = self.obj;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
            
        default:
            break;
    }
}


#pragma mark ========   视图加载完成   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationController.navigationBar.translucent = NO;
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"破损缺少遗失"];
    [self createNavInAccuseType];
}

//创建导航栏
- (void)createNavInAccuseType{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInAccuseType)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}

//左侧返回按钮点击事件
- (void)backInAccuseType{
    
    //执行
    for (UIViewController *temp in self.navigationController.viewControllers) {
        
        //判断是否
        if ([temp isKindOfClass:[ClaimViewController class]]||[temp isKindOfClass:[MessageDetailsController class]]) {
            
            [self.navigationController popToViewController:temp animated:YES];
            
            break;
        }
    }
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
