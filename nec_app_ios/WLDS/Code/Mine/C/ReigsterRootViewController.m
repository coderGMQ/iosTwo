//
//  ReigsterRootViewController.m
//  WLDS
//
//  Created by han chen on 2018/3/6.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "ReigsterRootViewController.h"
#import "BusinessRegisterViewController.h"
#import "PersonalregisterViewController.h"


@interface ReigsterRootViewController ()
@property (weak, nonatomic) IBOutlet UIButton *personRegisterBtn;
@property (weak, nonatomic) IBOutlet UIButton *companyRegisterBtn;

@end

@implementation ReigsterRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"注册";

    [self createNavInMessageDetails];

    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

    //创建导航栏
- (void)createNavInMessageDetails{

        //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInMessageDetails)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
}

    //左侧返回按钮点击事件
- (void)backInMessageDetails{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI{

    //个人
    self.personRegisterBtn.layer.cornerRadius = 4;

    self.personRegisterBtn.layer.masksToBounds=YES;

self.personRegisterBtn.layer.borderColor=[[UIColor colorWithRed:0.08 green:0.51 blue:0.86 alpha:1] CGColor];

    self.personRegisterBtn.layer.borderWidth= 1;

//    [self.personRegisterBtn addTarget:self action:@selector(personRegisterBtn) forControlEvents:UIControlEventTouchUpInside];

    //企业
    self.companyRegisterBtn.layer.cornerRadius = 4;

    self.companyRegisterBtn.layer.masksToBounds=YES;

    self.companyRegisterBtn.layer.borderColor=[[UIColor colorWithRed:0.08 green:0.51 blue:0.86 alpha:1] CGColor];

    self.companyRegisterBtn.layer.borderWidth= 1;

//    [self.companyRegisterBtn addTarget:self action:@selector(pushToBusinessRebister) forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)pusToPersonalRegister{
    PersonalregisterViewController *pushPage = [[PersonalregisterViewController alloc] init];

    [self.navigationController pushViewController:pushPage animated:YES];
}

- (IBAction)pushToBusinessRebister{
    BusinessRegisterViewController *pushPage = [[BusinessRegisterViewController alloc] init];

    [self.navigationController pushViewController:pushPage animated:YES];
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
