//
//  UIViewController+AnimationMake.m
//  TestAnimation
//
//  Created by lanou3g on 15/9/19.
//  Copyright (c) 2015年 QiJiaJia. All rights reserved.
//

#import "UIViewController+AnimationMake.h"

#import <objc/runtime.h>

//动画时间间隔
//#define DURATION 2.0f

@implementation UIViewController (AnimationMake)

//+ (void)load {
//    
//    //我们只有在开发的时候才需要查看哪个viewController将出现
//    //所以在release模式下就没必要进行方法的交换
//#ifdef DEBUG
//    
//    //原本的viewWillAppear方法
//    Method viewWillAppear = class_getInstanceMethod(self, @selector(viewWillAppear:));
//    
//    //需要替换成 能够输出日志的viewWillAppear
//    Method logViewWillAppear = class_getInstanceMethod(self, @selector(logViewWillAppear:));
//    
//    //两方法进行交换
//    method_exchangeImplementations(viewWillAppear, logViewWillAppear);
//    
//#endif
//    
//}

//- (void)logViewWillAppear:(BOOL)animated {
//    
//    NSString *className = NSStringFromClass([self class]);
//    
//    //在这里，你可以进行过滤操作，指定哪些viewController需要打印，哪些不需要打印
//    if ([className hasPrefix:@"UI"] == NO) {
//        NSLog(@" === 将要展示的控制器 == %@ ==",className);
//    }
//    
//    //下面方法的调用，其实是调用viewWillAppear
//    [self logViewWillAppear:animated];
//}

//类目属性赋值操作
- (void)setEmptyView:(UIView *)emptyView{

    objc_setAssociatedObject(self, @selector(emptyView), emptyView, OBJC_ASSOCIATION_RETAIN);
    
//    emptyView.frame = self.view.bounds;
//    emptyView.backgroundColor = kMainColor;
//    [self.view addSubview:emptyView];
//    
//    //文本信息
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, emptyView.w, emptyView.h / 2)];
//    label.textColor = kWhiteColor;
//    label.font = kFontSize(kFitW(15));
//    label.backgroundColor = kOrangeColor;
//    label.text = @"空文本页面属性";
//    label.textAlignment = NSTextAlignmentCenter;
//    [emptyView addSubview:label];
}

-(UIView *)emptyView{
    
    return objc_getAssociatedObject(self, @selector(emptyView));
}

- (void)setAnimationWithSubtype:(AnimationSubType)subtype andAnimationType:(AnimationType)animationType animateWithDuration:(CGFloat)duration{

        //设置动画方向
    
     //2：从右向左动  0：从左向右动 1：从上向下动 3：从下往上动
        NSString *subtypeString;
    
        switch (subtype) {
            case 0:
                //方向从左开始 
                subtypeString = kCATransitionFromLeft;
                break;
            case 1:
                //方向从底部开始
                subtypeString = kCATransitionFromBottom;
                break;
            case 2:
                //方向从右开始
                subtypeString = kCATransitionFromRight;
                break;
            case 3:
                //方向从上开始
                subtypeString = kCATransitionFromTop;
                break;
            default:
                break;
        }
    
    //设置动画类型
    switch (animationType) {
        case AnimationTypeFade:
            [self transitionWithType:kCATransitionFade WithSubtype:subtypeString ForView:self.view andAnimateWithDuration:duration];
            break;
            
        case AnimationTypePush:
            [self transitionWithType:kCATransitionPush WithSubtype:subtypeString ForView:self.view andAnimateWithDuration:duration];
            break;
            
        case AnimationTypeReveal:
            [self transitionWithType:kCATransitionReveal WithSubtype:subtypeString ForView:self.view andAnimateWithDuration:duration];
            break;
            
        case AnimationTypeMoveIn:
            [self transitionWithType:kCATransitionMoveIn WithSubtype:subtypeString ForView:self.view andAnimateWithDuration:duration];
            break;
            
        case AnimationTypeCube:
            [self transitionWithType:@"cube" WithSubtype:subtypeString ForView:self.view andAnimateWithDuration:duration];
            break;
            
        case AnimationTypeSuckEffect:
            [self transitionWithType:@"suckEffect" WithSubtype:subtypeString ForView:self.view andAnimateWithDuration:duration];
            break;
            
        case AnimationTypeOglFlip:
            [self transitionWithType:@"oglFlip" WithSubtype:subtypeString ForView:self.view andAnimateWithDuration:duration];
            break;
            
        case AnimationTypeRippleEffect:
            [self transitionWithType:@"rippleEffect" WithSubtype:subtypeString ForView:self.view andAnimateWithDuration:duration];
            break;
            
        case AnimationTypePageCurl:
            [self transitionWithType:@"pageCurl" WithSubtype:subtypeString ForView:self.view andAnimateWithDuration:duration];
            break;
            
        case AnimationTypePageUnCurl:
            [self transitionWithType:@"pageUnCurl" WithSubtype:subtypeString ForView:self.view andAnimateWithDuration:duration];
            break;
            
        case AnimationTypeCameraIrisHollowOpen:
            [self transitionWithType:@"cameraIrisHollowOpen" WithSubtype:subtypeString ForView:self.view andAnimateWithDuration:duration];
            break;
            
        case AnimationTypeCameraIrisHollowClose:
            [self transitionWithType:@"cameraIrisHollowClose" WithSubtype:subtypeString ForView:self.view andAnimateWithDuration:duration];
            break;
            
        case AnimationTypeCurlDown:
            [self animationWithView:self.view WithAnimationTransition:UIViewAnimationTransitionCurlDown andAnimateWithDuration:duration];
            break;
            
        case AnimationTypeCurlUp:
            [self animationWithView:self.view WithAnimationTransition:UIViewAnimationTransitionCurlUp andAnimateWithDuration:duration];
            break;
            
        case AnimationTypeFlipFromLeft:
            [self animationWithView:self.view WithAnimationTransition:UIViewAnimationTransitionFlipFromLeft andAnimateWithDuration:duration];
            break;
            
        case AnimationTypeFlipFromRight:
            [self animationWithView:self.view WithAnimationTransition:UIViewAnimationTransitionFlipFromRight andAnimateWithDuration:duration];
            break;
            
        default:
            break;
    }
    
//    static int i = 0;
//    if (i == 0) {
//        [self addBgImageWithImageName:IMAGE1];
//        i = 1;
//    }
//    else
//    {
//        [self addBgImageWithImageName:IMAGE2];
//        i = 0;
//    }
    
}

#pragma CATransition动画实现

- (void)transitionWithType:(NSString *)type WithSubtype:(NSString *)subtype ForView:(UIView *)view andAnimateWithDuration:(CGFloat)duration
{
    
    
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置动画时间间隔
    animation.duration = duration;
    
    //设置运动type
    animation.type = type;
    
    if (subtype != nil) {
        //设置动画子类（方向）
        animation.subtype = subtype;
    }
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];

}



#pragma UIView实现动画
- (void)animationWithView:(UIView *)view WithAnimationTransition: (UIViewAnimationTransition)transition andAnimateWithDuration:(CGFloat)duration
{
    
    [UIView animateWithDuration:duration animations:^{
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [UIView setAnimationTransition:transition forView:view cache:YES];
        
    }];
    
}


//#pragma 给View添加背景图
//-(void)addBgImageWithImageName:(NSString *) imageName
//{
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
//}

//模态跳转加导航控制器
- (void)modalPresentToVC:(UIViewController *)controller{
    
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:controller];
    //隐藏底部竖线 translucent = NO必须设置为NO，否则为：
    //    naVC.navigationBar.translucent = NO;
//        naVC.navigationBar.subviews[0].subviews[0].hidden = YES;
    //导航栏颜色设置
    naVC.navigationBar.barTintColor = KNANBC;

    //页面跳转
    [self presentViewController:naVC animated:YES completion:nil];
}

//导航控制器跳转
- (void)pushToVC:(UIViewController *)controller{
    
//    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:controller];
    
    
//    //隐藏底部竖线 translucent = NO必须设置为NO，否则为：naVC.navigationBar.subviews[0].subviews[1].hidden = YES;
//    naVC.navigationBar.translucent = NO;
//    controller.navigationBar.subviews[0].subviews[0].hidden = YES;
    
    //在跳转之前设置为YES
    controller.hidesBottomBarWhenPushed = YES;
    //
    [self.navigationController pushViewController:controller animated:YES];
    ////在跳转之后再设置为NO
    self.hidesBottomBarWhenPushed = NO;
}


//导航栏添加自定义标题
- (void)giveColor:(UIColor *)color andFontSize:(CGFloat)fontSize forNavigationItemTitle:(NSString *)title{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, title.length * fontSize, 44)];
    
    self.navigationItem.titleView = label;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text = title;
    
    label.textColor = color;
    
    label.font = [UIFont systemFontOfSize:fontSize];
    
}

//为导航控制器加标题及夜色
- (void)setFont:(UIFont *)font color:(UIColor *)color title:(NSString *)title{
    
    self.title = title;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}] ;
}

#pragma mark ========   正在建设中   ========
- (void)buildindNow{
    
    //创建alertController
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"正在建设中" preferredStyle:(UIAlertControllerStyleAlert)];
    
    //为alertController添加按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"知道啦" style:(UIAlertActionStyleDefault) handler:nil]];
    
    //alertController展示
    [self presentViewController:alert animated:YES completion: nil];
}

#pragma mark ========   提示框   ========
- (void)waringShow:(NSString *)msg{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark ========   提示框   ========
- (void)waringShow:(NSString *)msg over:(void (^)(BOOL response))over{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        //执行回调
        BLOCK_EXEC(over,YES);
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

//去登录页面
- (void)toLogin:(void (^)(BOOL response))back{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"用户未登录" message:@"是否去登录?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDestructive) handler:nil]];

    WEAKSELF
        
    [alertController addAction:[UIAlertAction actionWithTitle:@"登录" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        JQLoginViewController *loginPage = [[JQLoginViewController alloc] init];
        
        loginPage.loginBlock = ^(BOOL success) {
            
            //执行回调
            BLOCK_EXEC(back,success);
        };
        
        [weakSelf modalPresentToVC:loginPage];
        
    }]];
        
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//去登录页面
- (void)toLogin:(void (^)(BOOL response))back cancel:(void (^)(BOOL response))cancel{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"用户未登录" message:@"是否去登录?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        
        //执行回调
        BLOCK_EXEC(cancel,YES);
    }]];
    
    WEAKSELF
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"登录" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        JQLoginViewController *loginPage = [[JQLoginViewController alloc] init];
        
        loginPage.loginBlock = ^(BOOL success) {
            
            //执行回调
            BLOCK_EXEC(back,success);
        };
        
        [weakSelf modalPresentToVC:loginPage];
        
    }]];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//根据总数以及单页数量，计算所需分页总数
- (NSInteger)allRowsWithTotal:(NSInteger)total  count:( NSInteger)count{
    
    NSInteger pages = total / count;
    
    NSInteger remain = total % count;
    
    if (remain != 0) {
        
        pages = pages + 1;
    }
    
    return pages;
}

- (void)backToViewController:(Class)vc{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        
        //判断是否
        if ([temp isKindOfClass:vc]) {
            
            [self.navigationController popToViewController:temp animated:YES];
            
            break;
        }
    } 
}

//监听键盘
- (void)monitorFromKeyboard{
    
    //注册观察键盘的变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//移动UIView
-(void)transformView:(NSNotification *)aNSNotification{
    //获取键盘弹出后的Rect
    NSValue *keyBoardEndBounds = [[aNSNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  endRect=[keyBoardEndBounds CGRectValue];
    
    //获取当前第一响应者
    UIView *view = (UIView *)[UIResponder currentFirstResponder];
    
    //判断当前的第一响应者是否是该控制器的子类视图
    if ([view isDescendantOfView:self.view] == NO){
        return;
    }
    
    //获取当前响应者在窗口中的frame
    CGRect frame = [view locationInWindow];
    //比较frame差值是否被遮挡
    CGFloat value = (frame.origin.y + frame.size.height - endRect.origin.y);
    
    if (value > 0) {
        
        //在0.15s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动value的动画
        [UIView animateWithDuration:0.15f animations:^{
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - value, self.view.frame.size.width, self.view.frame.size.height)];
        }];
        
    }else{
        
        //返回原位置
        [self.view setFrame:CGRectMake(self.view.frame.origin.x,NAV_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    }
}
@end
