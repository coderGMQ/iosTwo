//
//  JQLoginViewController.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/5/11.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQLoginViewController : UIViewController

//登录回调
@property (nonatomic,copy) void (^loginBlock)(BOOL success);

//注册成功登录 
- (void)registSuccessLogin:(NSDictionary *)loginData;

@end
