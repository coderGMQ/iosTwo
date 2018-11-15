//
//  AuthenticationAccountViewController.m
//  WLDS
//
//  Created by han chen on 2018/3/13.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "AuthenticationAccountViewController.h"
#import "HttpDataRequest.h"
#import "UITools.h"


@interface AuthenticationAccountViewController ()
{
    NSArray *titleAry;
}
@end

@implementation AuthenticationAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNavInMessageDetails];

    titleAry = @[@"姓名",@"手机号",@"身份证号"];

    self.tableView.estimatedRowHeight = 50;

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


#pragma mark 网络数据请求
- (void)networkRequest{

        //开loading
    [SVProgressHUD show];

        //    WEAKSELF
    [HttpDataRequest askListByPage:nil pageTitle:self.title
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
                                       //观察状态
                                   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backSVPInLogin) name:@"SVProgressHUDDidDisappearNotification" object:nil];
                               }

                               [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dic[@"msg"]];
                           }
                           
                       }];
}


#pragma mark ========   登出成功   ========
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
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *n_pBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 100)];

        //登录按钮
    n_pBackView.backgroundColor = [UIColor clearColor];

    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    loginBtn.frame = CGRectMake(0, 20, kWidth , 55);

    if ([[self.userLoginDic stringWithKey:@"authentication"] intValue] == 1) {
        [loginBtn setTitle:@"账户认证" forState:UIControlStateNormal];

        [loginBtn addTarget:self action:@selector(networkRequest) forControlEvents:UIControlEventTouchUpInside];
    }
    else
        [loginBtn setTitle:@"账户已认证" forState:UIControlStateNormal];

    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [loginBtn setBackgroundColor:[UIColor whiteColor]];

    [n_pBackView addSubview:loginBtn];

    return n_pBackView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textLabel.text = titleAry[indexPath.row];

    cell.textLabel.textColor = kHexColor(0x333333);

    cell.textLabel.font = KFontSize15;

    NSString *detailStr = @"";
    
    switch (indexPath.row) {

        case 0:
            detailStr = [self.userLoginDic stringWithKey:@"userName"];
            break;
        case 2:
            detailStr = [UITools cardNoFromStr:[self.userLoginDic stringWithKey:@"idCard"]];
            break;
        case 1:
            detailStr = [self.userLoginDic stringWithKey:@"phone"];
            break;
        default:
            break;
    }

    cell.detailTextLabel.text = detailStr;

    cell.detailTextLabel.textColor = kHexColor(0x999999);

    cell.detailTextLabel.font = KFontSize15;
        // Configure the cell...

    return cell;
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
