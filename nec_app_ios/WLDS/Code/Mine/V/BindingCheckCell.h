//
//  BindingCheckCell.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/4/24.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BindingCheckCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *orgName;

@property (weak, nonatomic) IBOutlet UILabel *principal;

@property (weak, nonatomic) IBOutlet UILabel *phone;

@property (weak, nonatomic) IBOutlet UILabel *address;

//绑定按钮回调
@property (nonatomic,copy) void (^bindingBlock) (void);


@property (weak, nonatomic) IBOutlet UIButton *bindBtn;

@end
