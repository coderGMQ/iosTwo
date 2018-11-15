//
//  MyLogisticsCompanyCell.m
//  WLDS
//
//  Created by han chen on 2018/3/22.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "MyLogisticsCompanyCell.h"

@implementation MyLogisticsCompanyCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.Unbundlingbtn.layer.cornerRadius = 5;

    self.Unbundlingbtn.layer.masksToBounds=YES;

    self.Unbundlingbtn.layer.borderWidth= 1;

    self.Unbundlingbtn.layer.borderColor=[kHexColor(0x3086de) CGColor];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark   证件类型选择
- (IBAction)unbundlingBtn:(UIButton *)sender{

    if (self.myLogisticsdelegate && [self.myLogisticsdelegate respondsToSelector:@selector(unbundlingBtn:)]) {

        [self.myLogisticsdelegate unbundlingBtn:sender];
    }
}


@end
