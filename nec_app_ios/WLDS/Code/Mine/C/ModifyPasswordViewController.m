//
//  ModifyPasswordViewController.m
//  WLDS
//
//  Created by han chen on 2018/3/13.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "HttpDataRequest.h"
#import "RegisterCell.h"


@interface ModifyPasswordViewController ()
{
    NSArray *titleAry;

    NSArray *textPromptAry;
}
@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNavInMessageDetails];

    titleAry = @[@"旧密码",@"新密码",@"确认新密码"];

    textPromptAry = @[@"请输入旧密码",@"请输入您的新密码",@"请再次输入您的密码"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 网络数据请求
- (void)networkRequest:(NSMutableDictionary *)requestData{

    
    //开loading
    [SVProgressHUD show];

    
    //    WEAKSELF
    [HttpDataRequest askListByPage:requestData pageTitle:self.title
                       requestData:^(BOOL isSuccess, NSDictionary *dic) {
                           
                           [SVProgressHUD dismiss];

                           [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
                               //展示风火轮时，禁止其他操作
                           [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
                           [SVProgressHUD setBackgroundColor:kLikeColor];
                           [SVProgressHUD setForegroundColor:KTEXT_COLOR];
                           [SVProgressHUD dismissWithDelay:1.0];

                           if (isSuccess) {
                               if ([dic[@"success"] boolValue]) {
                                   NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                                   [userDefault setObject:requestData[@"password"] forKey:@"password"];

                                   [userDefault synchronize];

                                   [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dic[@"msg"]];

                                       //观察状态
                                   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backSVPInLogin) name:@"SVProgressHUDDidDisappearNotification" object:nil];
                               }else{
                                   
                                    [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dic[@"jsonVo"][@"errors"][@"oldPassword"]];
                               }
                           }
                           
                       }];
}

#pragma mark ========   成功   ========
- (void)backSVPInLogin{

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return titleAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 120.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *n_pBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 120)];

        //登录按钮
    n_pBackView.backgroundColor = [UIColor clearColor];

    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    loginBtn.frame = CGRectMake(20, 50, kWidth - 40, 50);

    [loginBtn setTitle:@"确认" forState:UIControlStateNormal];

    [loginBtn addTarget:self action:@selector(sureCommitMsg) forControlEvents:UIControlEventTouchUpInside];

    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [loginBtn setBackgroundColor:kMainColor];

    loginBtn.layer.cornerRadius = 5;

    loginBtn.layer.masksToBounds=YES;

    loginBtn.layer.borderColor=[[UIColor colorWithRed:0.08 green:0.51 blue:0.86 alpha:1] CGColor];

    loginBtn.layer.borderWidth= 1;

    [n_pBackView addSubview:loginBtn];

    return n_pBackView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegisterCell"];

    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RegisterCell" owner:self options:nil] objectAtIndex:0];
    }

    cell.titleLab.text = titleAry[indexPath.row];

    cell.contentText.placeholder = textPromptAry[indexPath.row];

    if (indexPath.row != 0){
        cell.contentText.secureTextEntry = YES;
    }
    //设置标签
    cell.contentText.tag = indexPath.row + 8765460;

        // Configure the cell...

    return cell;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];

    return YES;
}

- (void)sureCommitMsg{

    //字典
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    for (int i = 0; i < 3; i++) {

        UITextField *tf = (UITextField *)[self.view viewWithTag:8765460+i];

        if (tf.text.length == 0) {
            [self waringShow:tf.placeholder];
            return;
        }else{

            if (0 == i) {
                //赋值操作
                [dict setObject:tf.text forKey:@"oldPassword"];
            }else if (1 == i){
                //赋值操作
                [dict setObject:tf.text forKey:@"onePassword"];
            }else{
                //赋值操作
                [dict setObject:tf.text forKey:@"password"];
            }

        }
    }
    
    //判断是否输入一直
    if ([[dict stringWithKey:@"password"] isEqualToString:[dict stringWithKey:@"onePassword"]] == NO) {
        [self waringShow:@"两次密码输入不一致"];
        return;
    }

    [dict setObject:@"1" forKey:@"type"];
    
    [self networkRequest:dict];
}


@end
