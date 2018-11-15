//
//  ChooseImageCell.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/23.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "ChooseImageCell.h"

@implementation ChooseImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //监听版本信息

    [self.IM addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    //判断改变的属性值
    if ([keyPath isEqualToString:@"image"]) {
        
        self.title.hidden = self.midIM.hidden = YES;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
