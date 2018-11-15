//
//  RegisterCell.h
//  WLDS
//
//  Created by han chen on 2018/3/7.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXTextField.h"

@protocol RegisterDelegate <NSObject>

//拍照
- (void)userTakePhoto:(UIButton *)sender;

//获取验证码
- (void)getVerCode:(UIButton *)sender;

//证件类型选择
- (void)selectCertType:(UIButton *)sender;

@end

@interface RegisterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *contentText;
@property (weak, nonatomic) IBOutlet BXTextField *carNoText;
@property (weak, nonatomic) IBOutlet UIButton *registerImg;
@property (weak, nonatomic) IBOutlet UIButton *verCodeBtn;


@property (nonatomic, weak)id <RegisterDelegate> registerdelegate;
@property (weak, nonatomic) IBOutlet UIButton *togetherPicBtn1;
@property (weak, nonatomic) IBOutlet UIButton *togetherPicBtn2;


@end
