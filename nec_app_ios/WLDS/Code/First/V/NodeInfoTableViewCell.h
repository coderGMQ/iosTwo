//
//  NodeInfoTableViewCell.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/6.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NodeInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UILabel *statue;
@property (weak, nonatomic) IBOutlet UIImageView *picture;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statueH;

@property (weak, nonatomic) IBOutlet UIImageView *bottom;

@end
