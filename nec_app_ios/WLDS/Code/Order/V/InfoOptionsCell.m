//
//  InfoOptionsCell.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/18.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "InfoOptionsCell.h"

@implementation InfoOptionsCell

- (IBAction)tapInfoOptions:(UITapGestureRecognizer *)sender {
    
    //获取选中的点击
    NSInteger index = sender.view.tag;
    
    //修改图片
    [self changeWithIndex:index];
    
    if (self.chooseBlock) {
        //余数个位数字传出
        self.chooseBlock(index / 1000);
    }
}

- (void)changeWithIndex:(NSInteger)index{

    //记录新位置
    self.location = index;
    
    //获取图片
    UIImageView *iv = (UIImageView *)[self viewWithTag:index + 1];
    iv.image = kSetImage(@"dianxuan_m");
    
    if (index == 1000) {
        
        //获取图片
        UIImageView *ot = (UIImageView *)[self viewWithTag:2001];
        ot.image = kSetImage(@"dianxuan_un");
    }else if (index == 2000){
        
        //获取图片
        UIImageView *ot = (UIImageView *)[self viewWithTag:1001];
        ot.image = kSetImage(@"dianxuan_un");
    }
    
}

//根据标题默认选择
- (void)chooseWithTitle:(NSString *)title{

    if ([title isEqualToString:@"是"]) {
        
        [self changeWithIndex:1000];
        
    }else if ([title isEqualToString:@"否"]){
        
        [self changeWithIndex:2000];
    }
}

//修改约束及标题位置(默认选中位置)
- (void)witdth:(CGFloat)width titles:(NSArray *)titles index:(NSInteger)index{

    if (width > 0) {
        //修改约束
        self.subWidth.constant = width;
    }
    
    //遍历标题集合
    for (int i = 0;i < titles.count; i++) {
        
        if (i == 0) {
            //获取第一个文本
            UILabel *label = (UILabel *)[self viewWithTag:1002];
            label.text = [titles objectAtIndex:i];
        }else if (i == 1){
            //获取第二个文本
            UILabel *label = (UILabel *)[self viewWithTag:2002];
            label.text = [titles objectAtIndex:i];
            
        }
    }
    
    if (index == 0) {
        [self changeWithIndex:1000];
    }else if (index == 1){
        [self changeWithIndex:2000];
    }
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
