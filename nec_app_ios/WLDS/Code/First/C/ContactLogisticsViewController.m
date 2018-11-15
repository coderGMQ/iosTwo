//
//  ContactLogisticsViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/23.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "ContactLogisticsViewController.h"

@interface ContactLogisticsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;

@end

@implementation ContactLogisticsViewController

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

//联系物流公司打电话
- (IBAction)tapInContactLogistics:(UITapGestureRecognizer *)sender {
    
    //获取文本信息
    NSString *phone = self.phone.text;

    //判断是否为手机号
    BOOL call = [NSString isMobilePhone:phone];
    
    if (call == NO) {
        
        call = [NSString isAllNumber:[phone deleteSpecial:@"-"] type:0];
    }
    
    if (call == YES) {

        NSString* str = [NSString stringWithFormat:@"telprompt://%@",phone];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark ========   视图加载完成   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationController.navigationBar.translucent = NO;
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"联系物流公司"];
    [self createNavInContactLogistics];
    
    //名称
    self.name.text = [self.obj stringWithKey:@"orgName"];
    
    //名称
    self.phone.text = [self.obj stringWithKey:@"orgPhone"];
}

//创建导航栏
- (void)createNavInContactLogistics{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInContactLogistics)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}

//左侧返回按钮点击事件
- (void)backInContactLogistics{
    
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
