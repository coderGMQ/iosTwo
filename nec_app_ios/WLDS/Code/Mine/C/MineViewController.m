//
//  MineViewController.m
//  WLDS
//
//  Created by han chen on 2018/3/5.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "MineViewController.h"
#import "JQLoginViewController.h"
#import "PersonAccountMsgViewController.h"
#import "AuthenticationAccountViewController.h"
#import "MyLogisticsCompanyViewController.h"
#import "ModifyPasswordViewController.h"
#import "MyDispatchViewController.h"

#import "MineCell.h"
#import "UITools.h"

#import "JQLoginViewController.h"


@interface MineViewController ()<MineCellDelegate>
//{
//
//    NSArray *titleAry;
//}

@property (nonatomic,strong) NSArray *titleAry;

//登录回调
@property (nonatomic,copy) void (^loginBlockSuccess)(NSIndexPath *indexPath);


@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

        //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"我的"];

    self.titleAry = @[@[@"我的发货单",@"我的收货单",@"已完成订单",@"发货人管理",@"收货人管理"],@[@"账户认证",@"密码修改",@"账户信息"],@[@"我的物流公司"]];

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1)];
    
    if (self.back == YES) {
        
        [self createNavInMine];
    }

    //注册登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotificationInMine:) name:@"loginNotification" object:nil];
    
    WEAKSELF
    
    self.loginBlockSuccess = ^(NSIndexPath *indexPath) {
      
        if (indexPath.section != 0) {

                UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
                
                if ([cell.textLabel.text isEqualToString:@"发货人管理"]) {
                    
                    ConsigneeTableViewController *vc = [[ConsigneeTableViewController alloc] init];
                    vc.title = @"发货人管理";
                    [weakSelf pushToVC:vc];
                    
                }else if ([cell.textLabel.text isEqualToString:@"收货人管理"]) {
                    ConsigneeTableViewController *vc = [[ConsigneeTableViewController alloc] init];
                    vc.title = @"收货人管理";
                    [weakSelf pushToVC:vc];
                }
                else if ([cell.textLabel.text isEqualToString:@"我的物流公司"]){
                    MyLogisticsCompanyViewController *pushPage = [[MyLogisticsCompanyViewController alloc] init];
                    
                    pushPage.title = weakSelf.titleAry[indexPath.section - 1][indexPath.row];
                    
                    [weakSelf pushToVC:pushPage];
                }
                else if((indexPath.section == 1) && (indexPath.row < 3)){
                    MyDispatchViewController *pushPage = [[MyDispatchViewController alloc] init];
                    
                    pushPage.title = weakSelf.titleAry[indexPath.section - 1][indexPath.row];
                    
                    pushPage.myDispatchMark = indexPath.row;
                    
                    [weakSelf pushToVC:pushPage];
                }
                else if (indexPath.section == 2){
                    if (indexPath.row == 2) {
                        
                        MineCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        
                        
                        PersonAccountMsgViewController *pushPage = [[PersonAccountMsgViewController alloc] init];
                        
                        //
                        NSDictionary *userLoginMsg = [[NSUserDefaults standardUserDefaults] objectForKey:@"lgdata"];
                        
                        pushPage.picture = cell.loginImg.image;
                        
                        pushPage.userLoginDic = userLoginMsg;
                        
                        pushPage.isAccountType = [userLoginMsg[@"userType"] intValue];
                        
                        [weakSelf pushToVC:pushPage];
                    }
                    else if (indexPath.row == 1){
                        ModifyPasswordViewController *pushPage = [[ModifyPasswordViewController alloc] init];
                        
                        pushPage.title = weakSelf.titleAry[indexPath.section - 1][indexPath.row];
                        
                        [weakSelf pushToVC:pushPage];
                    }
                    else if (indexPath.row == 0){
                        AuthenticationAccountViewController *pushPage = [[AuthenticationAccountViewController alloc] init]
                        ;
                        //
                        NSDictionary *userLoginMsg = [[NSUserDefaults standardUserDefaults] objectForKey:@"lgdata"];
                        
                        pushPage.userLoginDic = userLoginMsg;
                        
                        pushPage.title = weakSelf.titleAry[indexPath.section - 1][indexPath.row];
                        
                        [weakSelf pushToVC:pushPage];
                    }
                }
            
        }else{
            
            
            MineCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            
            PersonAccountMsgViewController *pushPage = [[PersonAccountMsgViewController alloc] init];
            
            pushPage.picture = cell.loginImg.image;
            
            //
            NSDictionary *userLoginMsg = [[NSUserDefaults standardUserDefaults] objectForKey:@"lgdata"];
            
            pushPage.userLoginDic = userLoginMsg;
            
            pushPage.isAccountType = [userLoginMsg[@"userType"] intValue];
            
            [weakSelf pushToVC:pushPage];
                
        }
        
    };
}

//创建导航栏
- (void)createNavInMine{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInMine)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
}

- (void)backInMine{

    [self.navigationController popViewControllerAnimated:YES];
}

//通知处理方法
- (void)loginNotificationInMine:(NSNotification *)info{
    
    //刷新页面
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    [self.tableView reloadData];
}


- (void)userLogin:(UIButton *)sender{
    
    JQLoginViewController *loginPage = [[JQLoginViewController alloc] init];
    
    [self pushToVC:loginPage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    }
    else
    return [self.titleAry[section - 1] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 110;
    }
    else
        return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        MineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell"];

        if ([HelperSingle shareSingle].isLogin == YES) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MineCell" owner:self options:nil] objectAtIndex:1];

                //服务端存储极光推送ID
            NSDictionary *userLoginMsg = [[NSUserDefaults standardUserDefaults] objectForKey:@"lgdata"];

            cell.loginNameLab.text = userLoginMsg[@"userName"];
            
            NSString *name = [userLoginMsg stringWithKey:@"avatar"];

            [cell.loginImg sd_setImageWithURL:kIVUrl(name) placeholderImage:[UIImage imageNamed:@"MineM00"]];
        }
        else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MineCell" owner:self options:nil] objectAtIndex:0];

            cell.minedelegate = self;

            cell.loginImg.image = [UIImage imageNamed:@"MineM00"];
        }
        
        return cell;
    }
    else{
        NSDictionary *userLoginMsg = [[NSUserDefaults standardUserDefaults] objectForKey:@"lgdata"];

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
        }

        if ((indexPath.section == 2) && (indexPath.row == 0)  && ([userLoginMsg[@"authentication"] intValue] == 2)) {

            //文本
            UILabel *titleLab = (UILabel *)[cell.contentView viewWithTag:111];
            
            if ([HelperSingle shareSingle].isLogin == YES) {
                
                if (titleLab == nil) {
                    
                    //创建视图
                    titleLab = [[UILabel alloc] initWithFrame:CGRectMake(kWidth - 100, 19, 60, 25)];
                    
                    titleLab.textAlignment = NSTextAlignmentCenter;
                    
                    titleLab.font = [UIFont systemFontOfSize:14];
                    
                    titleLab.text = @"已认证";
                    
                    titleLab.layer.cornerRadius = 5;
                    
                    titleLab.layer.masksToBounds=YES;
                    
                    titleLab.layer.borderWidth= 1;
                    
                    [UITools changeBackground:titleLab];
                    
                    titleLab.tag = 111;
                    
                    [cell.contentView addSubview:titleLab];
                }
                
            }else{
                
                if (titleLab != nil) {
                    //移除视图
                    [titleLab removeFromSuperview];
                }
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if (indexPath.section != 0) {
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"MineM%ld%ld",indexPath.section, indexPath.row]];

            cell.textLabel.text = self.titleAry[indexPath.section - 1][indexPath.row];
        }

        return cell;
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section != 0) {
        if ([HelperSingle shareSingle].isLogin == NO) {

            WEAKSELF
            [self toLogin:^(BOOL response) {
                
                weakSelf.loginBlockSuccess(indexPath);
            }];
            
        }else{
            //回调
            self.loginBlockSuccess(indexPath);
        }
        
    }else{
        
        if ([HelperSingle shareSingle].isLogin == YES) {
            
            //回调
            self.loginBlockSuccess(indexPath);
            
        }else{
            
            WEAKSELF
            [self toLogin:^(BOOL response) {
                
                weakSelf.loginBlockSuccess(indexPath);
            }];
        }
    }
}


/**
 *  用颜色返回一张图片
 */
- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end
