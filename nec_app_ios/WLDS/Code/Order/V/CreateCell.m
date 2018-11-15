//
//  CreateCell.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/16.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "CreateCell.h"

@implementation CreateCell

//手势点击实现
- (IBAction)tapInCreateCell:(UITapGestureRecognizer *)sender {
    
    if (self.tapChooseBlock){
        
        //获取位置
        NSInteger index = sender.view.tag - 100;
        
        //获取回传的值，进行赋值操作
        self.tapChooseBlock(index);
    }
}

//赋值操作
- (void)giveValueWithDict:(NSDictionary *)dict{
    
    //货物名称
    NSString *value = [dict stringWithKey:@"productName"];
    if (value.length == 0){
        value = @"填写货物信息";
    }
    self.name.text = value;
    
    //货物信息
    value = [dict stringWithKey:@"goodsNum"];
    if (value.integerValue > 0){
        value = [value stringByAppendingString:@"件"];
    }
    //货物重量
    if ([dict stringWithKey:@"weight"].doubleValue > 0){
        value = [NSString stringWithFormat:@"%@,%.3f吨",value,[dict[@"weight"] doubleValue]];
    }
    //货物重量
    if ([dict stringWithKey:@"volume"].doubleValue > 0){
        value = [NSString stringWithFormat:@"%@,%.3fm³",value,[dict[@"volume"] doubleValue]];
    }
    
    //判断是否有数据信息
    if (value.length == 0){
        value = @"货物描述";
    }
    //货物描述信息赋值
    self.notice.text = value;
    
    //回单类型
    value = [dict stringWithKey:@"receiptType"];
    if ([value isEqualToString:@"0"]){
        value = @"厂单";
    }else if ([value isEqualToString:@"1"]){
        value = @"回执";
    }else if ([value isEqualToString:@"2"]){
        value = @"面单";
    }else if ([value isEqualToString:@"3"]){
        value = @"收条";
    }else{
        value = @"回单类型";
    }
    self.order.text = [NSString stringWithFormat:@"%@%ld份",value,[dict[@"theReceipt"] integerValue]];
    
    //付款方式
    value = [dict stringWithKey:@"payMethod"];

    if ([value isEqualToString:@"1"]){
        value = @"现付";
    }else if ([value isEqualToString:@"2"]){
        value = @"到付";
    }else if ([value isEqualToString:@"3"]){
        value = @"回付";
    }else if ([value isEqualToString:@"4"]){
        value = @"欠付";
    }else if ([value isEqualToString:@"5"]){
        value = @"30天付";
    }else if ([value isEqualToString:@"6"]){
        value = @"60天付";
    }else if ([value isEqualToString:@"7"]){
        value = @"90天付";
    }else{
        value = @"付款方式";
    }
    self.pay.text = value;
    
    //是否提货
    value = [dict stringWithKey:@"pickGoodsMethod"];
    if ([value isEqualToString:@"1"]){
        value = @"提货";
    }else{
        value = @"不提货";
    }
    self.pick.text = value;
    
    //送货方式
    value = [dict stringWithKey:@"deliveryMethod"];
   
    if ([value isEqualToString:@"0"]){
        value = @"送货";
    }else{
        value = @"不送货";
    }
    self.send.text = value;
    
    //代收货款
    value = [dict stringWithKey:@"collectionMoney"];
    if (value.doubleValue > 0){
        value = [NSString stringWithFormat:@"%.2f元",[dict stringWithKey:@"collectionMoney"].doubleValue];
    }else{
        value = @"代收货款0元";
    }
    self.collection.text = value;
    
    //投保金额
    value = [dict stringWithKey:@"declaredValue"];
    if (value.doubleValue > 0){
        value = [NSString stringWithFormat:@"价值%.2f元，已投保",[dict stringWithKey:@"declaredValue"].doubleValue];
    }else{
        value = @"未投保";
    }
    self.insure.text = value;
    
    //货物详情
    value = [dict stringWithKey:@"goodsMsg"];
    if (value.length == 0){
        value = @"填写其他货物详情";
    }
    self.detail.text = value;

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
