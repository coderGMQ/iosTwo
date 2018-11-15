//
//  MyDispatchCell.m
//  WLDS
//
//  Created by han chen on 2018/3/11.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "MyDispatchCell.h"

@implementation MyDispatchCell

- (void)awakeFromNib {

    self.myDispatchState.layer.cornerRadius = 4;

    self.myDispatchState.layer.masksToBounds=YES;

    self.myDispatchState.layer.borderColor=[kHexColor(0x878889) CGColor];

    self.myDispatchState.layer.borderWidth= 1;
    
    [super awakeFromNib];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
