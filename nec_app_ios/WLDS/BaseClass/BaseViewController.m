
//  BaseViewController.m
//  BNZY
//
//  Created by zhiyundaohe on 2017/9/6.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.

#import "BaseViewController.h"

#import "FirstViewController.h"

#import "MessageViewController.h"

#import "MineViewController.h"


@interface BaseViewController ()

//选中标题
@property (nonatomic,strong) NSString *item;

@end


@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    

    //监听版本信息
    [[HelperSingle shareSingle] addObserver:self forKeyPath:@"version" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    //判断改变的属性值
    if ([keyPath isEqualToString:@"version"]) {
        
        //更新后的值
        NSString *value = change[@"new"];
        
        // app build版本
        NSString *app_build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        //判断是否存在最新版本
        if (value.integerValue > app_build.integerValue) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"版本信息" message:@"应用已发布最新版本\n是否去更新?" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"去更新" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
                //跳转至app store
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/id1372426193"]];
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDestructive) handler:nil]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}


#pragma mark ========   视图加载   ========
- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.frame = [UIScreen mainScreen].bounds;
    
    self.view.backgroundColor = kWhiteColor;
    //预置为"首页"
    self.item = @"首页";
    
    //首页
    FirstViewController *firstVC = [[FirstViewController alloc] init];
    [self addChildVC:firstVC title:@"首页" imageName:@"shouye@2x" seleteImage:@"shouye_s@2x"];

    //下单
    CreateOrderViewController *waybillVC = [[CreateOrderViewController alloc] init];
    [self addChildVC:waybillVC title:@"下单" imageName:@"xiadan@2x" seleteImage:@"xiadan_s@2x"];

    //消息
    MessageViewController *infoListVC = [[MessageViewController alloc] init];
    [self addChildVC:infoListVC title:@"消息" imageName:@"xiaoxi@2x" seleteImage:@"xiaoxi_s@2x"];

    //我的
    MineViewController *mineVC = [[MineViewController alloc] init];
    [self addChildVC:mineVC title:@"我的" imageName:@"wode@2x" seleteImage:@"wode_s@2x"];
    
    //调整标题字体的大小
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13]} forState:(UIControlStateNormal)];
    
    //记录登录
    [self rememberLogin];

}

//记住登录
- (void)rememberLogin{
    
    //判断是否点击登录
    NSString *loginOut =  [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"];
    
    if ([loginOut isEqualToString:@"1"]) {
        
        NSDictionary *sLoginInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"lgdata"];
        
        if ([sLoginInfo includeTheKey:@"loginName"]) {
            
            //密码
            NSString *pw = sLoginInfo[@"lpw"];
            
            NSString *name = sLoginInfo[@"loginName"];
            
            if (pw != nil && pw.length > 0) {

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
                [NetRequestManger POST:@"lxzy/user/login" params:@{@"loginName":name,@"password":pw,@"deviceId":idfv,@"registrationId":registrationId,@"platform":@"ios"} success:^(id response) {
                    
                    //数据转换
                    NSDictionary *dictionary = (NSDictionary *)response;
                    
                    //数据请求值
                    BOOL success = [dictionary[@"success"] boolValue];
                    
                    //判断是否请求成功
                    if (success == YES) {
                        
                        [HelperSingle shareSingle].isLogin = YES;
                        
                        //登录成功数据
                        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithDictionary:[NSMutableDictionary nullDic:dictionary[@"data"]]];
                        [data setObject:pw forKey:@"lpw"];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"lgdata"];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
                        
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        //成功登录通知，携带数据 @“1”，退出登录携带@“0”
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginNotification" object:@"1"];
                        
                    }else{
                        //登录失败
                        [HelperSingle shareSingle].isLogin = NO;
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    //登录失败
                    [HelperSingle shareSingle].isLogin = NO;
                }];
            }
        }
    }
}


// 封装方法【设置导航栏】
- (void)addChildVC:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName seleteImage:(NSString *)seleteImage{
    
//    //导航标题渲染颜色
//    self.tabBar.tintColor = kMainColor;
//    //2.设置默认图标
//    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
//    // 3.设置选中图标
//    childVC.tabBarItem.selectedImage = [UIImage imageNamed:seleteImage];
//
//    childVC.tabBarController.tabBar.tintColor = kBlackColor;
//
//    //设置标题
//    childVC.tabBarItem.title = title;
//
//    // 将我们设置好的视图控制器添加至TabBarControlle
//    [self addChildViewController:childVC];
//
//    //选择样式
//    self.tabBar.barStyle = UIBarStyleDefault;
    
//    //导航标题渲染颜色
//    self.tabBar.tintColor = kMainColor;
    //2.设置默认图标
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    // 3.设置选中图标
    childVC.tabBarItem.selectedImage = [UIImage imageNamed:seleteImage];
    // 4.设置导航控制器
    UINavigationController *childNVC = [[UINavigationController alloc] initWithRootViewController:childVC];
    
    //底部素线隐藏（组合使用）
//    childNVC.navigationBar.translucent = NO;
//    childVC.navigationController.navigationBar.translucent = NO;
//    childVC.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
//
    //导航栏顶部颜色
    childNVC.navigationBar.barTintColor = kMainColor;
    
    //标题颜色
    childNVC.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    //设置按钮文字颜色 白色
//    childNVC.tabBarController.tabBar.tintColor = kBlackColor;
    
    //设置标题
    childNVC.tabBarItem.title = title;
    
    // 将我们设置好的视图控制器添加至TabBarControlle
    [self addChildViewController:childNVC];
    
    //选择样式
    self.tabBar.barStyle = UIBarStyleDefault;
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
     
    if ([item.title isEqualToString:self.item] == NO) {
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabBarItemChange" object:item.title];
        
        //标题赋值
        self.item = item.title;
    }
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
