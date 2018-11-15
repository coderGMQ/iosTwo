//
//  MessageTableViewCell.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/5.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picture;

@property (weak, nonatomic) IBOutlet UILabel *statue;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *message;

@property (weak, nonatomic) IBOutlet UILabel *orderCode;

@property (weak, nonatomic) IBOutlet UILabel *code;


@end
