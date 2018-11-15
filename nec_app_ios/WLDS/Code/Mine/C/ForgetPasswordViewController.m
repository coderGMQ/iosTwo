//
//  ForgetPasswordViewController.m
//  WLDS
//
//  Created by han chen on 2018/3/10.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "HttpDataRequest.h"
#import "RegisterCell.h"


@interface ForgetPasswordViewController ()<RegisterDelegate>
{
        //倒计时
    int m_iTimeCount;

        //获取验证码定时器
    NSTimer *m_pCodeTime;

    NSArray *titleAry;

    NSArray *textPromptAry;
}

@property (nonatomic,retain) NSMutableDictionary *forgetPasswordDic;

@end

@implementation ForgetPasswordViewController
- (NSMutableDictionary *)forgetPasswordDic{

    if (!_forgetPasswordDic) {

        _forgetPasswordDic = [[NSMutableDictionary alloc] init];
    }
    return _forgetPasswordDic;
}


- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.

    self.title = @"忘记密码";

    m_iTimeCount = 60;

    titleAry = @[@"用户名",@"手机验证码",@"新密码"];

    textPromptAry = @[@"请输入登录账号",@"请输入验证码",@"请输入新密码"];

    [self createNavInMessageDetails];
}


- (void)viewWillDisappear:(BOOL)animated{
    [self offNSTimer];

    [super viewWillDisappear:YES];
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


#pragma mark 获取验证码
/***********************************************************************
 * 方法名称： openNSTimer
 * 功能描述：打开定时器
 * 输入参数：
 * 输出参数：
 * 返 回 值：
 * 其它说明：
 ***********************************************************************/
- (void)openNSTimer
{
    if (nil == m_pCodeTime)
        {
        m_iTimeCount = 60;

        m_pCodeTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
        }
}


/***********************************************************************
 * 方法名称： offNSTimer
 * 功能描述：关闭定时器
 * 输入参数：
 * 输出参数：
 * 返 回 值：
 * 其它说明：
 ***********************************************************************/
- (void)offNSTimer
{
    if (nil != m_pCodeTime)
        {
        [m_pCodeTime invalidate];
        m_pCodeTime = nil;

        RegisterCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

        [cell.verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
}


/***********************************************************************
 * 方法名称： startAnimation
 * 功能描述： 开始动画--时间计时器
 * 输入参数：
 * 输出参数：
 * 返 回 值：
 * 其它说明：
 ***********************************************************************/
-(void)startAnimation
{
    m_iTimeCount = m_iTimeCount - 1;

    RegisterCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    [cell.verCodeBtn setTitle:[NSString stringWithFormat:@"%d%@",m_iTimeCount,@"秒"] forState:UIControlStateNormal];

    if (m_iTimeCount == 0){
        [self offNSTimer];
    }
}


- (void)getVerCode:(UIButton *)sender{

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    RegisterCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    if (STRING_ISNIL(cell.contentText.text)) {
        [self waringShow:@"请输入登录账号"];
    }
    else{

        if (m_iTimeCount == 60 || m_iTimeCount == 0) {
                //打开计时器
            [self openNSTimer];

            [self networkRequest:cell.contentText.text];
        }
    }
}

#pragma mark 获取验证码
- (void)networkRequest:(NSString *)loginName{

    
    //开loading
    [SVProgressHUD show];
    
    //    WEAKSELF
    [HttpDataRequest askListByPage:@{@"loginName":loginName} pageTitle:@"获取验证码"
                       requestData:^(BOOL isSuccess, NSDictionary *dic) {
                           
                           
                           [SVProgressHUD dismiss];
                           
                           [self.forgetPasswordDic removeAllObjects];

                           [self offNSTimer];

                           if (isSuccess) {
                               if ([dic[@"success"] boolValue]) {
                                   [self.forgetPasswordDic addEntriesFromDictionary:dic[@"data"]];

                                   RegisterCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

                                   cell2.contentText.text = self.forgetPasswordDic[@"code"];
                               }
                               else{
                                   [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dic[@"msg"]];
                               }
                           }
                       }];
}


#pragma mark 确认提交
- (void)sureCommitMsg{
    RegisterCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];

    RegisterCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    RegisterCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    if (STRING_ISNIL(cell1.contentText.text)) {
        [self waringShow:@"请输入登录账号"];
    }
    else if (STRING_ISNIL(cell2.contentText.text)) {
        [self waringShow:@"请输入验证码"];
    }
    else if (STRING_ISNIL(cell.contentText.text)) {
        [self waringShow:@"请输入新密码"];
    }
    else{
        //校验验证码
        [self checkCodeRequest];
    }
}


#pragma mark 校验密码
- (void)checkCodeRequest{
        //开loading
        [SVProgressHUD show];

        //    WEAKSELF
    [HttpDataRequest askListByPage:@{@"checkNum":self.forgetPasswordDic[@"code"],@"key":self.forgetPasswordDic[@"key"]} pageTitle:@"检验验证码"
                       requestData:^(BOOL isSuccess, NSDictionary *dic) {
                           if (isSuccess) {
                               if ([dic[@"success"] boolValue]) {

                                   //修改密码
                                   [self changeCodeRequest:dic[@"data"][@"returnKey"]];
                               }else{
                                   
                                   [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dic[@"msg"]];

                                   [SVProgressHUD dismiss];
                               }
                               
                           }else {
                               
                               [SVProgressHUD dismiss];
                               
                           }
                       }];
}


#pragma mark 修改密码
- (void)changeCodeRequest:(NSString *)returnKey{

    RegisterCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    RegisterCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];

        //    WEAKSELF
    [HttpDataRequest askListByPage:@{@"type":@"2",@"loginName":cell.contentText.text,@"password":cell2.contentText.text,@"returnKey":returnKey} pageTitle:@"密码修改"
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

                                   [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dic[@"msg"]];

                                       //观察状态
                                   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backSVPInLogin) name:@"SVProgressHUDDidDisappearNotification" object:nil];
                               }
                               else{
                                   [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dic[@"msg"]];
                               }
                           }
                           
                       }];
}


#pragma mark ========   成功   ========
- (void)backSVPInLogin{

    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
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
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *n_pBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 100)];

        //登录按钮
    n_pBackView.backgroundColor = [UIColor clearColor];

    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    loginBtn.frame = CGRectMake(20, 40, kWidth - 40, 40);

    [loginBtn setTitle:@"确认提交" forState:UIControlStateNormal];

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
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RegisterCell" owner:self options:nil] objectAtIndex:3];
    }

    cell.registerdelegate = self;
    
    cell.titleLab.text = titleAry[indexPath.row];

    cell.contentText.placeholder = textPromptAry[indexPath.row];

    if (indexPath.row == 1) {
        cell.contentText.keyboardType = UIKeyboardTypeNumberPad;

        cell.verCodeBtn.hidden = NO;
//        [self feedTextPhone:cell.contentText];
    }
    else{
        cell.verCodeBtn.hidden = YES;

        if (indexPath.row == 2){
            cell.contentText.secureTextEntry = YES;
        }
    }

        // Configure the cell...

    return cell;
}


- (void)feedTextPhone:(UITextField *)tfText
{
        //cxf 自定义数字键盘上的完成按钮
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kWidth, 35)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * spaceBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    doneBtn.frame = CGRectMake(2, 5, 40, 30);
    [doneBtn addTarget:self action:@selector(dealKeyboardHide) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *doneBtnItem = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:spaceBtn,doneBtnItem,nil];
    [topView setItems:buttonsArray];

    [tfText setInputAccessoryView:topView];
    [tfText setAutocorrectionType:UITextAutocorrectionTypeNo];
    [tfText setAutocapitalizationType:UITextAutocapitalizationTypeNone];
}


-(void)dealKeyboardHide{
    RegisterCell *cardCell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    [cardCell1.carNoText resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

@end
