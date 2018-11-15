//
//  PersonalregisterViewController.m
//  WLDS
//
//  Created by han chen on 2018/3/7.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "PersonalregisterViewController.h"
#import "JQLoginViewController.h"
#import "RegisterCell.h"
#import "UITools.h"
#import "HttpDataRequest.h"

@interface PersonalregisterViewController (){
    NSArray *titleAry;

    NSArray *textPromptAry;
}

@property (nonatomic,strong) NSMutableDictionary *request;

@end

@implementation PersonalregisterViewController

/* * * * * * * * * *
 *
 * @
 *
 * * * * * * * * * */
- (NSMutableDictionary *)request{
    
    if (!_request) {
        _request = [[NSMutableDictionary alloc] init];
    }
    return _request;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"个人注册";

    [self createNavInMessageDetails];

    titleAry = @[@[@"注册账号",@"密码",@"重复密码"],@[@"姓名",@"身份证号",@"手机号"]];

    textPromptAry = @[@[@"请输入注册账号",@"请输入密码",@"请再次输入密码"],@[@"请输入姓名",@"请输入18位身份证号",@"请输入手机号"]];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return titleAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [titleAry[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 100.0f;
    }
    else
        return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
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
    else
        return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegisterCell"];

    if ((indexPath.section == 1) && (indexPath.row == 1)){
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RegisterCell" owner:self options:nil] objectAtIndex:1];
        }
    }else{
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RegisterCell" owner:self options:nil] objectAtIndex:0];
        }
    }


    //    cell.titleLab.attributedText = [UITools setAttributeStr:titleAry[indexPath.section][indexPath.row] titleStrLeng:1];
    //标题
    cell.titleLab.text = titleAry[indexPath.section][indexPath.row];
    if ((indexPath.section == 1) && (indexPath.row == 1)){
        
        cell.carNoText.placeholder = textPromptAry[indexPath.section][indexPath.row];
        
        cell.carNoText.text = [self.request stringWithKey:@"idCard"];
        
        [self feedTextPhone:cell.carNoText];
        
    }else{
        
        cell.contentText.placeholder = textPromptAry[indexPath.section][indexPath.row];
        
        NSString *value = @"";
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                value = [self.request stringWithKey:@"loginName"];
                
            }else if (indexPath.row == 1) {
                
                value = [self.request stringWithKey:@"onePassword"];
                
                cell.contentText.secureTextEntry = YES;
                
            }else{
                
                value = [self.request stringWithKey:@"password"];
                
                cell.contentText.secureTextEntry = YES;
            }
            
        }else{
            
            if (indexPath.row == 0) {
                
                value = [self.request stringWithKey:@"userName"];
                
            }else{

                value = [self.request stringWithKey:@"phone"];
                
                
                cell.contentText.keyboardType = UIKeyboardTypeNumberPad;
                
                [self feedTextPhone:cell.contentText];
            }
        }
        
        //赋值
        cell.contentText.text = value;
    }
    
    return cell;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    textField.text = [NSString removeTheSpacesForString:textField.text];
    
    NSString *key = @"";
    
    
    //手机号 phone 身份证idCard 姓名userName 密码password 输入密码onePassword 登录loginName
    
    if ([textField.placeholder isEqualToString:@"请输入注册账号"]) {
        key = @"loginName";
        
    }else if ([textField.placeholder isEqualToString:@"请输入密码"]) {
        key = @"onePassword";
        
    }else if ([textField.placeholder isEqualToString:@"请再次输入密码"]) {
        key = @"password";
        
    }else if ([textField.placeholder isEqualToString:@"请输入姓名"]) {
        key = @"userName";
        
    }else if ([textField.placeholder isEqualToString:@"请输入18位身份证号"]) {
        key = @"idCard";
        
    }else if ([textField.placeholder isEqualToString:@"请输入手机号"]) {
        key = @"phone";
        
    }
    
    if (key.length > 0) {
        
        [self.request setObject:textField.text forKey:key];
    }
}


- (void)feedTextPhone:(UITextField *)tfText{
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
    RegisterCell *cardCell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];

    RegisterCell *cardCell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];

    [cardCell1.carNoText resignFirstResponder];

    [cardCell2.contentText resignFirstResponder];
}


- (void)sureCommitMsg{
    
    kKeyBoardHiden;

    //注册账号
    NSString *value = [self.request stringWithKey:@"loginName"];
    if (value.length == 0) {
        [self waringShow:@"请输入注册账号"];
        return;
    }

    value = [self.request stringWithKey:@"onePassword"];
    if (value.length == 0) {
        [self waringShow:@"请输入密码"];
        return;
    }
    
    value = [self.request stringWithKey:@"password"];
    if (value.length == 0) {
        [self waringShow:@"请再次输入密码"];
        return;
    }
    
    if ([[self.request stringWithKey:@"password"] isEqualToString:[self.request stringWithKey:@"onePassword"]] == NO) {
        [self waringShow:@"两次密码输入不一致"];
        return;
    }
//    
//    value = [self.request stringWithKey:@"userName"];
//    if (value.length == 0) {
//        [self waringShow:@"请输入姓名"];
//        return;
//    }
//    
//    value = [self.request stringWithKey:@"idCard"];
//    if (value.length == 0) {
//        [self waringShow:@"请输入18位身份证号"];
//        return;
//    }
//    
//    value = [self.request stringWithKey:@"phone"];
//    if (value.length == 0) {
//        [self waringShow:@"请输入手机号"];
//        return;
//    }
    
    //数据请求
    [self networkRequest:self.request];
}


#pragma mark 网络数据请求
- (void)networkRequest:(NSMutableDictionary *)askDic{

    //    WEAKSELF
    [HttpDataRequest askListByPage:askDic pageTitle:self.title
                            requestData:^(BOOL isSuccess, NSDictionary *dic) {
                                
                                [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
                                    //展示风火轮时，禁止其他操作
                                [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
                                [SVProgressHUD setBackgroundColor:kLikeColor];
                                [SVProgressHUD setForegroundColor:KTEXT_COLOR];
                                [SVProgressHUD dismissWithDelay:1.0];
                                
                                if (isSuccess) {
                                    if ([dic[@"success"] boolValue]) {
                                        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

                                        [[NSUserDefaults standardUserDefaults] setObject:askDic forKey:@"registerData"];

                                        [userDefault synchronize];

                                        [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dic[@"msg"]];

                                            //观察状态
                                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToLoginPage) name:@"SVProgressHUDDidDisappearNotification" object:nil];
                                    } else{
                                        [SVProgressHUD showImage:kSetImage(@"fail@2x") status:dic[@"msg"]];
                                    }
                                }
    
                            }];
}

#pragma mark ========   登录成功   ========
- (void)goToLoginPage{

    for (UIViewController *showPage in [self.navigationController viewControllers]) {
        if ([showPage isKindOfClass:[JQLoginViewController class]]) {

            JQLoginViewController *page = (JQLoginViewController *)showPage;

                //服务端存储极光推送ID
            NSDictionary *reginsterMsg = [[NSUserDefaults standardUserDefaults] objectForKey:@"registerData"];

            [page registSuccessLogin:@{@"loginName":reginsterMsg[@"loginName"],@"password":reginsterMsg[@"password"]}];

            [self.navigationController popToViewController:showPage animated:YES];
        }
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
