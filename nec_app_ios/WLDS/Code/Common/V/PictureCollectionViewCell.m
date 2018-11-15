//
//  PictureCollectionViewCell.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/2.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "PictureCollectionViewCell.h"

@implementation PictureCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {

        self = [[NSBundle mainBundle] loadNibNamed:@"PictureCollectionViewCell" owner:self options:nil].firstObject;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
