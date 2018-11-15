//
//  ClaimViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/20.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "ClaimViewController.h"

#import "AccuseViewController.h"

#import "ClaimResultViewController.h"

@interface ClaimViewController ()

@end

@implementation ClaimViewController

- (IBAction)tapToNext:(UITapGestureRecognizer *)sender {
    
    switch (sender.view.tag) {
        case 100:{
            AccuseViewController *vc = [[AccuseViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];           
        }
            break;
        case 101:{
            
            ClaimResultViewController *vc = [[ClaimResultViewController alloc] init];
            if ([HelperSingle shareSingle].isLogin == YES) {
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                
                WEAKSELF
                [self toLogin:^(BOOL response) {
                    
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }];
            }
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
    self.view.backgroundColor = kLikeColor;
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"投诉/理赔"];
    [self createNavInClaim];
    //键盘回收
    [self.view recycleKeyBoardWithDelegate:self];
}

//创建导航栏
- (void)createNavInClaim{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInClaim)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}

//左侧返回按钮点击事件
- (void)backInClaim{
    
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
