//
//  NextTableViewCell.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/7.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "NextTableViewCell.h"

@implementation NextTableViewCell


//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//
//    if (self) {
//
//        self = [[[NSBundle mainBundle] loadNibNamed:@"NextTableViewCell" owner:self options:nil] objectAtIndex:0];
//    }
//    return self;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame{
//
//    self = [super initWithFrame:frame];
//
//    if (self) {
//
//        self = [[[NSBundle mainBundle] loadNibNamed:@"NextTableViewCell" owner:self options:nil] objectAtIndex:0];
//    }
//    return self;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
