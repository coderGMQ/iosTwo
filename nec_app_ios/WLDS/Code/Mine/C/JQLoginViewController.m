//
//  JQLoginViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/5/11.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//


#import "JQLoginViewController.h"

#import "ReigsterRootViewController.h"
#import "ForgetPasswordViewController.h"
#import "HistoryTableViewCell.h"
#import "LoginCell.h"

@interface JQLoginViewController ()<UITableViewDataSource,UITableViewDelegate>


//数据集合
@property (nonatomic,strong) NSMutableArray *dataArray;

//表视图
@property (nonatomic,strong) UITableView *tableView;

//窗口展示视图
@property (nonatomic,strong) ShowView *chooseView;

@end

@implementation JQLoginViewController

/* * * * * * * * * *
 *
 * @
 *
 * * * * * * * * * */
- (ShowView *)chooseView{
    
    if (!_chooseView) {
        
        _chooseView = [[ShowView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) delegate:self];
        _chooseView.backgroundColor = kClearColor;
        [_chooseView addSubview:self.tableView];
        
    }
    return _chooseView;
}

/* * * * * * * * * *
 *
 * @ 懒加载表视图集合
 *
 * * * * * * * * * */
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        //表视图
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kFitW(44 * 6)) style:(UITableViewStylePlain)];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        [_tableView cropLayer:5];
        [_tableView borderCutWithColor:kLikeColor width:0.8];
    }
    return _tableView;
}

/* * * * * * * * * *
 *
 * @
 *
 * * * * * * * * * */
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"HUser"];
        
        //判断是否存在数据
        if (array != nil) {
            
            [_dataArray addObjectsFromArray:array];
            
        }else{
            
        }
    }
    return _dataArray;
}


#pragma mark ========   按钮点击实现   ========
- (IBAction)buttonInJQLogin:(UIButton *)sender {
    
    UITextField *tf = (UITextField *)[self.view viewWithTag:sender.tag - 100];
    //判断点击按钮才做
    if (sender.tag == 200) {
        
        [self chooseUserInJQLogin];
        
    }else if (sender.tag == 201){
        
        sender.selected = !sender.selected;
                
        if (sender.selected == YES) {
            
            tf.secureTextEntry =  NO;
            
            [sender setNormal:kSetImage(@"zhankai")];
        }else{
            
            [sender setNormal:kSetImage(@"yincang")];
            tf.secureTextEntry =  YES;
        }
    }
}

#pragma mark ========   选择已经登录用户   ========
- (void)chooseUserInJQLogin{
    
    kKeyBoardHiden;
    
    UITextField *nameTF = (UITextField *)[self.view viewWithTag:100];
    
    if (self.dataArray.count > 0) {
        
        self.chooseView.hidden = NO;
        
        //获取cell所在位置
        CGRect frame = [nameTF locationInWindow];
        
        CGFloat height = 0.0;
        
        if (self.dataArray.count > 6) {
            
            height = kFitW(44 * 6);
            
        }else{
            
            height = kFitW(44 * self.dataArray.count);
        }
        
        //计算位置
        if (frame.size.height + frame.origin.y + height < kHeight) {
            
            self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, height);
        }else{
            
            self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y - height, frame.size.width, height);
        }
        
    }else{
        
        NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"HUser"];
        
        //判断是否存在数据
        if (array != nil) {
            
            [self.dataArray removeLastObject];
            
            [self.dataArray addObjectsFromArray:array];
            
            //刷新数据
            [self.tableView reloadData];
            
        }else{
            
        }
        
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //底部素线隐藏（组合使用）
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setFont:kTitFont color:kWhiteColor title:@"登录"];
    
    [self createNavInLogin];
    
    [self.view recycleKeyBoardWithDelegate:nil];
    
    //数据获取
    [self rememberUser];
    
}

#pragma mark ========   查询最近记住用户数据   ========
- (void)rememberUser{
    
    NSDictionary *info = [[NSUserDefaults standardUserDefaults] objectForKey:@"lgdata"];
    
    NSString *name = @"";
    
    if ([info includeTheKey:@"loginName"]) {
        
        name = info[@"loginName"];
    }
    
    //用户名输入文本
    UIButton *button = (UIButton *)[self.view viewWithTag:200];
    
    //历史数据集合
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"HUser"];
    
    //判断是否存在数据
    if (array.count > 0) {
        
        //展示按钮
        button.hidden = NO;
        
        if ([array containsObject:name] == NO) {
            
            name = [array firstObject];
        }
        
    }else{
        //隐藏按钮
        button.hidden = YES;
        name = @"";
    }
    
    //用户名输入文本
    UITextField *tf1 = (UITextField *)[self.view viewWithTag:100];
    tf1.text = name;
}
//创建导航栏
- (void)createNavInLogin{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInLogin)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
    //右侧按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightReigst)];
    
    self.navigationItem.rightBarButtonItem.tintColor = kWhiteColor;
}

//左侧返回按钮点击事件
- (void)backInLogin{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


//右侧注册按钮
- (void)rightReigst{
    ReigsterRootViewController *registRootPage = [[ReigsterRootViewController alloc] init];
    
    [self.navigationController pushViewController:registRootPage animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestLogin:(UIButton *)sender {
    
    //请求数据
    [self clickLoginButton];
}
#pragma mark ========   登录   ========
- (void)clickLoginButton{
    
    //用户名输入文本
    UITextField *tf1 = (UITextField *)[self.view viewWithTag:100];
    NSString *name = [NSString removeTheSpacesForString:tf1.text];
    
    if (name.length == 0) {
        
        [self waringShow:@"请输入用户名"];
        return;
    }
    //用户名密码文本
    UITextField *tf2 = (UITextField *)[self.view viewWithTag:101];
    NSString *pw = [NSString removeTheSpacesForString:tf2.text];
    
    if (pw.length == 0) {
        [self waringShow:@"请输入密码"];
        return;
    }
    
    //结束编辑
    kKeyBoardHiden;
    
    //清除cookie
    [NetRequestManger clearCookie];
    
    
    //设备唯一标识符
    NSString *idfv = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    //服务端存储极光推送ID
    NSString *registrationId = [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationId"];
    
    //判断是否存在长度
    if (registrationId.length == 0) {
        
        registrationId = @"";
    }
    //登录
    [NetRequestManger POST:@"lxzy/user/login" params:@{@"loginName":name,@"password":pw,@"deviceId":idfv,@"registrationId":registrationId,@"platform":@"ios" } success:^(id response) {
        
        //数据转换
        NSDictionary *dictionary = (NSDictionary *)response;
        
        //数据请求值
        BOOL success = [dictionary[@"success"] boolValue];
        
        [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
        //展示风火轮时，禁止其他操作
        [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
        [SVProgressHUD setBackgroundColor:kLikeColor];
        [SVProgressHUD setForegroundColor:KTEXT_COLOR];
        [SVProgressHUD dismissWithDelay:1.0];
        
        //判断是否请求成功
        if (success == YES) {
            
            [HelperSingle shareSingle].isLogin = YES;
            
            //            NSDictionary *data = [NSMutableDictionary nullDic:dictionary[@"data"]];
            NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithDictionary:[NSMutableDictionary nullDic:dictionary[@"data"]]];
            [data setObject:pw forKey:@"lpw"];
            
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"lgdata"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:@"登录成功"];
            
            //观察状态
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backSVPInLogin) name:@"SVProgressHUDDidDisappearNotification" object:nil];
            
            //新建集合
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            NSArray *historys = [[NSUserDefaults standardUserDefaults] objectForKey:@"HUser"];
            
            if (historys != nil) {
                
                //添加所有数据
                [array addObjectsFromArray:historys];
                
                //判断是否数据超过四条
                if (array.count == 6) {
                    
                    //删除最后一位数据
                    [array removeLastObject];
                }
            }
            
            //判断是否已经存在数据
            BOOL isbool = [array containsObject:name];
            
            //判断是否存在某条数据
            if (isbool == NO) {
                
                //新用户放在第一位置
                [array insertObject:name atIndex:0];
                //非退出登录状态记录
                [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"HUser"];
            }
            
            //刷新存储列表
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else{
            
            [SVProgressHUD showImage:kSetImage(@"fail@2x") status:dictionary[@"msg"]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}

#pragma mark ========   登录成功   ========
- (void)backSVPInLogin{
    
    //成功登录通知，携带数据 @“1”，退出登录携带@“0”
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginNotification" object:@"1"];
    
    //回调
    BLOCK_EXEC(self.loginBlock,YES);
    
    [self backInLogin];
}

#pragma mark 忘记密码
- (IBAction)toForgetPassWord:(UIButton *)sender {
    
    ForgetPasswordViewController *pushPage = [[ForgetPasswordViewController alloc] init];
    
    [self.navigationController pushViewController:pushPage animated:YES];
    
}


//注册成功登录
- (void)registSuccessLogin:(NSDictionary *)loginData{
    
    //用户名输入文本
    UITextField *tf1 = (UITextField *)[self.view viewWithTag:100];

    tf1.text = loginData[@"loginName"];

    //用户名密码文本
    UITextField *tf2 = (UITextField *)[self.view viewWithTag:101];

    tf2.text = loginData[@"password"];

    [self clickLoginButton];
}


#pragma mark ========   UITableViewDataSource/UITableViewDelegate   ========
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kFitW(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[HistoryTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID width:tableView.w height:kFitW(44) bottom:1.0];
    }
    
    //数据展示
    cell.title.text = [self.dataArray objectAtIndex:indexPath.row];
    
    WEAKSELF
    
    cell.removeBlock = ^(BOOL success) {
        
        //删除数据
        [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
        
        //刷新数据
        [weakSelf.tableView reloadData];
        
        //历史用户数据存储
        [[NSUserDefaults standardUserDefaults] setObject:weakSelf.dataArray forKey:@"HUser"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //判断是否存在数据
        if (weakSelf.dataArray.count == 0) {
            
            weakSelf.chooseView.hidden = YES;
        }
        
    };
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITextField *nameTF = (UITextField *)[self.view viewWithTag:100];
    
    NSString *title = [self.dataArray objectAtIndex:indexPath.row];
    
    if (![nameTF.text isEqualToString:title]) {
        
        nameTF.text = [self.dataArray objectAtIndex:indexPath.row];
        
        //密码重新赋空
        UITextField *pwTF = (UITextField *)[self.view viewWithTag:101];
        pwTF.text = @"";
    }
    
    //页面隐藏
    self.chooseView.hidden = YES;
}

#pragma mark == 手势冲突处理 ==
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        
        return NO;
    }
    
    return  YES;
}

@end
