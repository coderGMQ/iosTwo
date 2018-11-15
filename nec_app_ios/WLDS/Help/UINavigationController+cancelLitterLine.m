

//
//  UINavigationController+cancelLitterLine.m
//  XHLEBusiness
//
//  Created by  zhiyundaohe on 17/12/30.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import "UINavigationController+cancelLitterLine.h"

@implementation UINavigationController (cancelLitterLine)

- (void)cancelLitterBlackLine{
    
//    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
//
//        NSArray *list = self.navigationBar.subviews;
//
//        for (id obj in list){
//
//            if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0){
//
//                //10.0的系统字段不一样
//                UIView *view = (UIView*)obj;
//
//                for (id obj2 in view.subviews) {
//
//                    if ([obj2 isKindOfClass:[UIImageView class]]){
//
//                        UIImageView *image =  (UIImageView*)obj2;
//
//                        image.hidden = YES;
//
//                        break;
//                    }
//                }
//
//            }else{
//
//                if ([obj isKindOfClass:[UIImageView class]]) {
//
//                    UIImageView *imageView=(UIImageView *)obj;
//
//                    NSArray *list2=imageView.subviews;
//
//                    for (id obj2 in list2) {
//
//                        if ([obj2 isKindOfClass:[UIImageView class]]) {
//
//                            UIImageView *imageView2=(UIImageView *)obj2;
//
//                            imageView2.hidden=YES;
//
//                            break;
//                        }
//                    }
//                }
//            }
//
//        }
//    }

    //去掉导航栏下部的黑色素线
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){

        NSArray *list = self.navigationBar.subviews;

        for (id obj in list) {

            if ([obj isKindOfClass:[UIImageView class]]) {

                UIImageView *imageView=(UIImageView *)obj;

                imageView.hidden=YES;

                //跳出循环
                break;
            }
        }
    }
}


//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if (self.viewControllers.count > 0) {
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
//    [super pushViewController:viewController animated:animated];
//    // 修改tabBra的frame
//    CGRect frame = self.tabBarController.tabBar.frame;
//    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
//    self.tabBarController.tabBar.frame = frame;
//}

@end
