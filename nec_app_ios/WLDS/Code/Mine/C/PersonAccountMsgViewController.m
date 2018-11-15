//
//  PersonAccountMsgViewController.m
//  WLDS
//
//  Created by han chen on 2018/3/11.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "PersonAccountMsgViewController.h"
#import "HttpDataRequest.h"
#import "RegisterCell.h"
#import "UITools.h"

@interface PersonAccountMsgViewController ()
{
     NSArray *titleAry;
}
@end

@implementation PersonAccountMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title =@"账户信息";

    if (self.isAccountType == 4) {
        titleAry = @[@[@"个人头像"],@[@"我的账号",@"姓名",@"身份证号",@"手机号"]];
    }
    else if([self.userLoginDic[@"documentType"] isEqualToString:@"2"]){
        titleAry = @[@[@"企业头像"],@[@"公司名称",@"法人",@"证件类型",@"营业执照注册号",@"组织机构代码",@"税务登记证号"],@[@"公司地址",@"公司电话",@"联系人",@"联系电话",@"联系邮箱"]];
    }
    else{
        titleAry = @[@[@"企业头像"],@[@"公司名称",@"法人",@"证件类型",@"社会信用码"],@[@"公司地址",@"公司电话",@"联系人",@"联系电话",@"联系邮箱"]];
    }

    [self createNavInMessageDetails];

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
                                   
                                   //标记登出
                                   [HelperSingle shareSingle].isLogin = NO;
                                   
                                   
                                   NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                                   [userDefault setObject:@"0" forKey:@"isLogin"];
                                   [userDefault synchronize];
                                   
                                   [NetRequestManger clearCookie];
//                                   NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//                                   [userDefault removeObjectForKey:@"lgdata"];
//                                   [userDefault removeObjectForKey:@"isLogin"];
//                                   [userDefault removeObjectForKey:@"registerData"];
//                                   [userDefault synchronize];

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

#pragma mark ========   登出成功   ========
- (void)backSVPInLogin{

        //成功登录通知，携带数据 @“1”，退出登录携带@“0”
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginNotification" object:@"0"];

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return titleAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [titleAry[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }
    else{
        return 55;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == (titleAry.count - 1)) {
        return 80.0f;
    }
    else
        return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == (titleAry.count - 1)) {
        UIView *n_pBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 100)];

            //登录按钮
        n_pBackView.backgroundColor = [UIColor clearColor];

        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        loginBtn.frame = CGRectMake(0, 20, kWidth , 55);

        [loginBtn setTitle:@"退出登录" forState:UIControlStateNormal];

        loginBtn.titleLabel.textColor = kHexColor(0x333333);

        [loginBtn addTarget:self action:@selector(networkRequest) forControlEvents:UIControlEventTouchUpInside];

        [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [loginBtn setBackgroundColor:[UIColor whiteColor]];

        [n_pBackView addSubview:loginBtn];

        return n_pBackView;
    }
    else
        return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){

        RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegisterCell"];

        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RegisterCell" owner:self options:nil] objectAtIndex:2];
        }

        cell.titleLab.text = titleAry[indexPath.section][indexPath.row];

        cell.titleLab.textColor = kHexColor(0x333333);

        cell.titleLab.font = KFontSize16;

        
        if (self.picture != nil) {
            
            //设置图片
            [cell.registerImg setBackgroundImage:self.picture forState:UIControlStateNormal];
            
        }else{
            
            if (self.isAccountType == 4) {
                
                [cell.registerImg setBackgroundImage:[UIImage imageNamed:@"MineM00"] forState:UIControlStateNormal];
            }else{
                
                [cell.registerImg setBackgroundImage:[UIImage imageNamed:@"qiyetouxiang"] forState:UIControlStateNormal];
            }
        }

        return cell;

    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.textLabel.text = titleAry[indexPath.section][indexPath.row];

        cell.textLabel.textColor = kHexColor(0x333333);

        cell.textLabel.font = KFontSize15;

        NSString *detailStr = @"";

        if (self.isAccountType == 4) {
            switch (indexPath.row) {
                case 0:
                    detailStr =[self.userLoginDic stringWithKey:@"loginName"];
                    break;
                case 1:
                    detailStr = [self.userLoginDic stringWithKey:@"userName"];
                    break;
                case 2:
                    detailStr = [UITools cardNoFromStr:[self.userLoginDic stringWithKey:@"idCard"]];
                    break;
                case 3:
                    detailStr = [self.userLoginDic stringWithKey:@"phone"];
                    break;
                default:
                    break;
            }
        }
        else{
            switch (indexPath.section) {
                case 1:{
                    switch (indexPath.row) {
                        case 0:{
                            detailStr =[self.userLoginDic stringWithKey:@"orgName"];
                        }
                            break;
                        case 1:{
                            detailStr =[self.userLoginDic stringWithKey:@"legalPerson"];
                        }
                            break;
                        case 2:{
                            detailStr = [self.userLoginDic stringWithKey:@"documentType"];
                            if ([detailStr isEqualToString:@"2"]) {
                                detailStr = @"三证";
                            }
                            else{
                                detailStr = @"三证合一";
                            }
                        }
                            break;
                        case 3:{
                            detailStr = [self.userLoginDic stringWithKey:@"documentType"];
                            if ([detailStr isEqualToString:@"2"]) {
                                detailStr = [self.userLoginDic stringWithKey:@"licenseCode"];
                            }
                            else{
                                detailStr = [self.userLoginDic stringWithKey:@"creditCode"];
                            }
                        }
                            break;
                        case 4:{
                            detailStr = [self.userLoginDic stringWithKey:@"organizationCode"];
                        }
                            break;
                        case 5:{
                            detailStr = [self.userLoginDic stringWithKey:@"taxCode"];
                        }
                            break;

                        default:
                            break;
                    }


                    break;

                case 2:{
                    switch (indexPath.row) {
                        case 0:{
                            detailStr = [self.userLoginDic stringWithKey:@"address"];
                        }
                            break;
                        case 1:{
                            detailStr = [self.userLoginDic stringWithKey:@"orgPhone"];
                        }
                            break;
                        case 2:{
                            detailStr = [self.userLoginDic stringWithKey:@"principal"];
                        }
                            break;
                        case 3:{
                            detailStr = [self.userLoginDic stringWithKey:@"phone"];
                        }
                            break;
                        case 4:{
                            detailStr = [self.userLoginDic stringWithKey:@"address"];
                        }
                            break;
                        case 5:{
                            detailStr = [self.userLoginDic stringWithKey:@"eMail"];
                        }

                            break;

                        default:
                            break;
                    }
                }
                    break;
                }
                default:
                    break;
            }

        }

        
        cell.detailTextLabel.text = detailStr;

        cell.detailTextLabel.textColor = kHexColor(0xaaaaaa);

        cell.detailTextLabel.font = KFontSize16;
            // Configure the cell...

        return cell;
    }

    return nil;
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
