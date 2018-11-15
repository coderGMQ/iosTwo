
//
//  HistoryTableViewCell.m
//  BNZY
//
//  Created by zhiyundaohe on 2017/11/27.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell


//自定义初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width height:(CGFloat)height bottom:(CGFloat)bottom{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
//        //选中背景视图
//        self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
//
//        self.selectedBackgroundView.backgroundColor = kHexColor(0xFFE384);
        
        self.selectionStyle = 0;
        
        //标题文本
        _title = [[UILabel alloc] init];
        _title.font = kFontSize(kFitW(16));
        _title.textColor = KTEXT_COLOR;
        [self addSubview:_title];
        
        //按钮创建
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self addSubview:button];
        [button setImage:kSetImage(@"delect@2x") forState:(UIControlStateNormal)];
        [button setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
        button.frame = CGRectMake(width - height, 0, height, height);
        //添加监听事件
        [button addTarget:self action:@selector(clickButtonInHistory:) forControlEvents:(UIControlEventTouchUpInside)];
        
        //判断是否大于0
        if (bottom > 0) {
            
            //设置标题frame
            _title.frame = CGRectMake(kFitW(10), 0, button.x - kFitW(10), height - bottom);
            _title.numberOfLines = 2;
            //细线
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(2, _title.v, width - 2 * 2, bottom)];
            line.backgroundColor = kLikeColor;
            [self addSubview:line];
            
        }else{
            
            //设置标题frame
            _title.frame = CGRectMake(kFitW(10), 0,button.x - kFitW(10), height - 1.0);
            
            _title.numberOfLines = 3;
        }
    }
    
    return self;
}

#pragma mark ========   点击实现方法   ========
- (void)clickButtonInHistory:(UIButton *)button{
    
    //传值
    BLOCK_EXEC(self.removeBlock,YES);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
