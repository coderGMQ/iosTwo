//
//  PersonAccountMsgViewController.h
//  WLDS
//
//  Created by han chen on 2018/3/11.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonAccountMsgViewController : UITableViewController

//1.个人 2.企业
@property(readwrite) int isAccountType;

@property(nonatomic,retain) NSDictionary *userLoginDic;

//头像
@property (nonatomic,strong) UIImage *picture;

@end
