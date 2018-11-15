//
//  LoginCell.h
//  WLDS
//
//  Created by han chen on 2018/3/6.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;


@property (weak, nonatomic) IBOutlet UITextField *tf;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

//是否密文输入
@property (nonatomic) BOOL secureText;


@end
