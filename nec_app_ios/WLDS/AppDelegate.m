//
//  AppDelegate.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/2/26.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
// 测试使用

#import "AppDelegate.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"

#import "BaseViewController.h"

// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    NSString *firstUsed = [[NSUserDefaults standardUserDefaults] objectForKey:@"first_u"];
    
    if (![firstUsed isEqualToString:@"1"]) {
        
        [NSThread sleepForTimeInterval:2.5];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"first_u"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else {
        
        [NSThread sleepForTimeInterval:1.0];
    }
    
    
    BaseViewController *vc = [[BaseViewController alloc] init];
    self.window.rootViewController = vc;

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    /*
     * @ 微信支付
     *
     **/
    [WXApi registerApp:kWXAppId withDescription:@"笨鸟智运-电商"];
    
    //【=====高德地图=====】
    [AMapServices sharedServices].apiKey = KGD_APP_KEY;
    //Required【=====极光推送=====】
//    notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    //
    //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    //        // 可以添加自定义categories
    //        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
    //        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    //    }
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//#ifdef NSFoundationVersionNumber_iOS_9_x_Max
//        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
//        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
//#endif
//    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        //可以添加自定义categories
//        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
//
//    } else {
//        //categories 必须为nil
//        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
//    }
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    //    apsForProduction
    //    1.3.1版本新增，用于标识当前应用所使用的APNs证书环境。
    //    0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用。
    //    注：此字段的值要与Build Settings的Code Signing配置的证书环境一致    
    [JPUSHService setupWithOption:launchOptions appKey:kJG_APP_KEY
                          channel:@"AppStore"
                 apsForProduction:YES
            advertisingIdentifier:advertisingId];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    //接收消息通知注册
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    //接收登录完成通知注册
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    
    //清除通知
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    [JPUSHService resetBadge];
    
    //获取版本
    [self getVersion];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark ========   获取最新版本信息   ========
- (void)getVersion{
    
    [NetRequestManger POST:@"base/appVersion/version" params:@{@"appType":@"2",@"sysType":@"3"} success:^(id response) {
        
        //数据转换
        NSDictionary *dictionary = (NSDictionary *)response;
        
        //获取最新版本
        NSString *appVersion = [dictionary stringWithKey:@"appVersion"];
        
        //版本信息
        [HelperSingle shareSingle].version = appVersion;
        
    } failure:nil];
}

#pragma mark ========   （非通知信息网络传送数据）   ========
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    
    //    RegistrationID 定义
    //
    //    集成了 JPush SDK 的应用程序在第一次成功注册到 JPush 服务器时，JPush 服务器会给客户端返回一个唯一的该设备的标识 - RegistrationID。JPush SDK 会以广播的形式发送 RegistrationID 到应用程序。
    //    应用程序可以把此 RegistrationID 保存以自己的应用服务器上，然后就可以根据 RegistrationID 来向设备推送消息或者通知。
    
    //    content：获取推送的内容
    //    extras：获取用户自定义参数
    //    customizeField1：根据自定义key获取自定义的value
    
    NSDictionary * userInfo = [notification userInfo];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString * bizCode = kDictString(extras, @"bizCode");
    
    //强制下线通知
    if ([bizCode isEqualToString:@"301"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"constraintQuit" object:nil];
    }
}

//本地存储注册推送ID
- (void)networkDidLogin:(NSNotification *)notification {
    
    if ([JPUSHService registrationID]) {
        
        //本地持久化存储
        [[NSUserDefaults standardUserDefaults] setObject:[JPUSHService registrationID] forKey:@"registrationId"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark ========   支付相关   ========
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    BOOL success = NO;
    
    if ([url.host isEqualToString:@"pay"]) {
        
        success = [WXApi handleOpenURL:url delegate:self];
        
    }
    
    return  success;
}


#pragma mark == 支付回调处理 ==
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL success = NO;
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
        }];
        
        success = YES;
        
    }else if ([url.host isEqualToString:@"pay"]){
        
        success = [WXApi handleOpenURL:url delegate:self];
        
    }
    
    return success;
}


#pragma mark ========   微信回调方法【支付或者发送媒体信息】   ========
- (void)onResp:(BaseResp *)resp{
    
    NSString * wxPayResult;
    //判断是否是微信支付回调 (注意是PayResp 而不是PayReq)
    
    if ([resp isKindOfClass:[PayResp class]]) {
        
        //支付返回的结果, 实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
                
            case WXSuccess: {
                //微信支付成功
                wxPayResult = @"success";
            }
                
                break;
            case WXErrCodeUserCancel: {
                //微信支付取消
                wxPayResult = @"cancel";
            }
                break;
                
            default: {
                //微信支付失败
                wxPayResult = @"fail";
            }
                
                break;
        }
         //发出通知 从微信回调回来之后,发一个通知,让请求支付的页面接收消息,并且展示出来,或者进行一些自定义的展示或者跳转
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPay" object:wxPayResult];
    }
}


#pragma mark ========   推送注册deviceToken   ========
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    
}

#pragma mark ========   JPUSHRegisterDelegate   ========

// iOS 10 Support （app已经打开状态之下【获取】推送信息）
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
//    // Required
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//
//
//    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support （app打开点击状态栏通知后执行方法）
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
//    // Required
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//
//    //后台打开后推送信息后可以获取到信息
//    completionHandler();  // 系统要求执行这个方法]
//
//    //跳转至指定页面
//    [self goToViewControllerWith:userInfo];
//
//    //处理推送通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"disposePushMessage" object:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    //判断应用是在前台还是后台
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        
        //  iOS 10以下 极光前台不展示消息栏，此处为自定义内容
        if ([UIDevice currentDevice].systemVersion.floatValue < 10.0) {
            
            
        }
        
    }else{
        
        //第二种情况后台挂起时
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JIGUANGPUSH" object:nil userInfo:userInfo];
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

