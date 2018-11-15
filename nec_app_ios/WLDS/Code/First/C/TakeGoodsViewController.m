

//
//  TakeGoodsViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/12.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "TakeGoodsViewController.h"
#import "MyDispatchViewController.h"

@interface TakeGoodsViewController ()

@end

@implementation TakeGoodsViewController

//按钮点击
- (IBAction)clickButtonImTakeGoods:(UIButton *)sender {
    
    //判断是否邓丽
    if ([HelperSingle shareSingle].isLogin == NO) {
        
        WEAKSELF
        [self toLogin:^(BOOL response) {
            
            //跳转页面
            [weakSelf loginAfter:sender.tag];
        }];
        
    }else{
        //跳转页面
        [self loginAfter:sender.tag];
    }
}

#pragma mark ========   登录之后跳转   ========
- (void)loginAfter:(NSInteger)tag{
    
    if (tag == 100) {
        //查看我的收货单
        MyDispatchViewController *pushPage = [[MyDispatchViewController alloc] init];
        pushPage.title = @"我的收货单";
        [self.navigationController pushViewController:pushPage animated:YES];
    }else if (tag == 101){
        //我要代收
        QJScanViewController *vc = [[QJScanViewController alloc] init];
        vc.title = @"收货";
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (tag == 102){
        //查看我的代收货单
        SearchOrderViewController *vc = [[SearchOrderViewController alloc] init];
        vc.undoPage = vc.title = @"我的代收货单";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark ========   视图加载   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
    
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"我要收货"];
    [self createNavInTakeGoods];

}

//创建导航栏
- (void)createNavInTakeGoods{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInTakeGoods)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}
//左侧返回按钮点击事件
- (void)backInTakeGoods{
    
    [self.navigationController popViewControllerAnimated:NO];
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
