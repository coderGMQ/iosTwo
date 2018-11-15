  //  MessageDetailsTableViewCell.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/6.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "MessageDetailsTableViewCell.h"

@implementation MessageDetailsTableViewCell


+ (instancetype)messageDetailsTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath data:(NSDictionary *)data{
    NSString *identifier = @"";//对应xib中设置的identifier
    NSInteger index = 0; //xib中第几个Cell
    switch (indexPath.section) {
        case 0:
            identifier = @"MessageDetailsTableViewCellFour";
            index = 3;
            break;
        case 1:
            identifier = @"MessageDetailsTableViewCellOne";
            index = 0;
            break;
        case 2:
            identifier = @"MessageDetailsTableViewCellTwo";
            index = 1;
            break;
        case 3:
            identifier = @"MessageDetailsTableViewCellThree";
            index = 2;
            break;
        case 4:
            identifier = @"MessageDetailsTableViewCellFive";
            index = 4;
            break;
            
        default:
            break;
    }
    MessageDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageDetailsTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
    
    switch (indexPath.section) {
        case 0:
//            identifier = @"MessageDetailsTableViewCellFour";
        {
            for (int i = 0; i < 4; i++) {
                
                UILabel *label = (UILabel *)[cell viewWithTag:400+i];
                
                if (0 == i) {
                    label.text = [NSString stringWithFormat:@"%@   %@",[data stringWithKey:@"deliveryName"],[data stringWithKey:@"deliveryPhone"]];
                }else if (1 == i){
                    label.text = [NSString stringWithFormat:@"%@%@%@%@%@",[data stringWithKey:@"deliveryProvince"],[data stringWithKey:@"deliveryCity"],[data stringWithKey:@"deliveryRegion"],[data stringWithKey:@"deliveryStreet"],[data stringWithKey:@"deliveryAddress"]];
                }else if (2 == i){
                    label.text = [NSString stringWithFormat:@"%@   %@",[data stringWithKey:@"receivingName"],[data stringWithKey:@"receivingPhone"]];
                }else if (3 == i){
                    label.text = [NSString stringWithFormat:@"%@%@%@%@%@",[data stringWithKey:@"receivingProvince"],[data stringWithKey:@"receivingCity"],[data stringWithKey:@"receivingRegion"],[data stringWithKey:@"deliveryStreet"],[data stringWithKey:@"receivingAddress"]];
                }
            }
        }

            break;
        case 1:
//            identifier = @"MessageDetailsTableViewCellOne";
        {
            NSString *title = @"";

            [cell.productName changeLabelTextColor:kGrayColor string:@"货物名称: " other:[data stringWithKey:@"productName"]];
            
            title = [data stringWithKey:@"goodsNum"];

            [cell.goodsNum changeLabelTextColor:kGrayColor string:@"货物件数: " other:[NSString stringWithFormat:@"%ld 件", title.integerValue]];
            title = [data stringWithKey:@"weight"];
            
            NSString *isAccept = [data stringWithKey:@"isAccept"];
            
            UIColor *changeColor = kGrayColor;
            
            if ([isAccept isEqualToString:@"有异常"]) {
                
                changeColor = kRedColor;
            }
            
            //改变颜色
            [cell.weight changeLabelTextColor:changeColor string:@"货物重量: " other:[NSString stringWithFormat:@"%.3f 吨",title.doubleValue]];
            title = [data stringWithKey:@"volume"];
            [cell.volume changeLabelTextColor:changeColor string:@"货物体积: " other:[NSString stringWithFormat:@"%.3f m³",title.doubleValue]];
            
            //异形件
            title = [data stringWithKey:@"isRule"];
            if ([title isEqualToString:@"0"]){
                title = @"否";
            }else if ([title isEqualToString:@"1"]){
                title = @"是";
            }
            [cell.unusual changeLabelTextColor:kGrayColor string:@"异形件: " other:title];
            
            //是否含税金
            title = [data stringWithKey:@"isTaxes"];
            if ([title isEqualToString:@"0"]){
                title = @"否";
            }else if ([title isEqualToString:@"1"]){
                title = @"是";
            }
            
            [cell.taxes changeLabelTextColor:kGrayColor string:@"含税金: " other:title];

        }

            break;
        case 2:{
            
            //            identifier = @"MessageDetailsTableViewCellTwo";

            //委托单号
            UILabel *entrustCode  = (UILabel *)[cell viewWithTag:199];
            NSString *value = @"";
            value = [data stringWithKey:@"entrustCode"];
            
            if (value.length == 0) {
                
                value = @"无";
            }
            [entrustCode changeLabelTextColor:kGrayColor string:@"委托单号: " other:value];
            for (int i = 0; i < 9; i++) {
                
                UILabel *label = (UILabel *)[cell viewWithTag:200+i];
                
                NSString *title = @"";
                
                if (0 == i) {
                    
                    title = [data stringWithKey:@"orgName"];
                    
                    if (title.length == 0) {
                        title = [data stringWithKey:@"capacityOrgName"];
                    }
                    
                    [label changeLabelTextColor:kGrayColor string:@"公司名称: " other:title];

                }else if (1 == i){
                    
//                    receipt
                    title = [data stringWithKey:@"theReceipt"];
                    
                    if (title.length == 0) {
                        title = [data stringWithKey:@"receipt"];
                    }
                    [label changeLabelTextColor:kGrayColor string:@"回单: " other:[NSString stringWithFormat:@"%ld 份",title.integerValue]];
                    
                }else if (2 == i){
                    
                    title = [data stringWithKey:@"declaredValue"];
                    [label changeLabelTextColor:kGrayColor string:@"投保金额: " other:[NSString stringWithFormat:@"%.2f 元",title.doubleValue]];
                    
                }else if (3 == i){
                    title = [data stringWithKey:@"collectionMoney"];
                    
                    [label changeLabelTextColor:kGrayColor string:@"代收货款: " other:[NSString stringWithFormat:@"%.2f 元",title.doubleValue]];
                    
                }else if (4 == i){
                    title = [data stringWithKey:@"pickGoodsMethod"];
                    
                    if ([title isEqualToString:@"1"]) {
                        title = @"是";
                    }else if ([title isEqualToString:@"2"]) {
                        title = @"否";
                    }
                    [label changeLabelTextColor:kGrayColor string:@"提货: " other:title];

                }else if (5 == i){
                    
                    title = [data stringWithKey:@"deliveryMethod"];
                    if ([title isEqualToString:@"0"]) {
                        title = @"送货";
                    }else if ([title isEqualToString:@"1"]) {
                        title = @"自提";
                    }else if ([title isEqualToString:@"2"]) {
                        title = @"等通知放货";
                    }
                    
                    [label changeLabelTextColor:kGrayColor string:@"送货方式: " other:title];

                }else if (6 == i){
                    
                    title = [data stringWithKey:@"payMethod"];
                    if ([title isEqualToString:@"1"]) {
                        title = @"现付";
                    }else if ([title isEqualToString:@"2"]) {
                        title = @"到付";
                    }else if ([title isEqualToString:@"3"]) {
                        title = @"回付";
                    }else if ([title isEqualToString:@"4"]) {
                        title = @"欠付";
                    }else if ([title isEqualToString:@"5"]) {
                        title = @"30天付";
                    }else if ([title isEqualToString:@"6"]) {
                        title = @"60天付";
                    }else if ([title isEqualToString:@"7"]) {
                        title = @"90天付";
                    }
                    [label changeLabelTextColor:kGrayColor string:@"付款方式: " other:title];

                }else if (7 == i){
                    
                    title = [data stringWithKey:@"deliveryTime"];
                    
                    if (title.length == 0) {
                        
                        title = [data stringWithKey:@"makeTime"];
                    }
                    
                    //格式转换
                    title = [NSDate calculateChineseWeek:title];
                    
                    [label changeLabelTextColor:kGrayColor string:@"发货时间: " other:title];
                    
                }else if (8 == i){
                    
                    title = [data stringWithKey:@"serviceType"];
                    
                    if ([title isEqualToString:@"0"]) {
                        title = @"无";
                    }else if ([title isEqualToString:@"1"]) {
                        title = @"上楼";
                    }else if ([title isEqualToString:@"2"]) {
                        title = @"装卸";
                    }else if ([title isEqualToString:@"3"]) {
                        title = @"上楼且装卸";
                    }
                    
                    //附加服务信息
                    [label changeLabelTextColor:kGrayColor string:@"附加服务: " other:title];
                    
                    //有无电梯
                    UILabel *change = (UILabel *)[cell viewWithTag:209];
                    //大小件
                    UILabel *big = (UILabel *)[cell viewWithTag:211];
                    
//                    //lineUpType:0无电梯1有电梯
//                    [dict setObject:[NSString stringWithFormat:@"%d",!unLift] forKey:@"lineUpType"];
//
//                    //lineUpWeightType:0小件1大件
//                    [dict setObject:[NSString stringWithFormat:@"%d",big] forKey:@"lineUpWeightType"];
//
//                    //startUp:0表示1-4层，1表示5-8层
//                    [dict setObject:[NSString stringWithFormat:@"%d",five] forKey:@"startUp"];
                    
                    //修改约束
                    if ([title isContainString:@"上楼"]) {
                        
                        //更新约束
                        [change updateViewConstraints:NSLayoutAttributeHeight constant:40];
                        
                        title = [data stringWithKey:@"lineUpType"];
                        
                        if ([title isEqualToString:@"0"]) {
                            
                            title = @"无电梯";
                            //更新约束
                            [big updateViewConstraints:NSLayoutAttributeHeight constant:40];

                            if ([[data stringWithKey:@"lineUpWeightType"] isEqualToString:@"0"]) {

                                [big changeLabelTextColor:kGrayColor string:@"大小件: " other:@"小件"];
                            }else if ([[data stringWithKey:@"lineUpWeightType"] isEqualToString:@"1"]){

                                [big changeLabelTextColor:kGrayColor string:@"大小件: " other:@"大件"];
                            }

                            //楼层展示
                            big = (UILabel *)[cell viewWithTag:210];
                            
                            if ([[data stringWithKey:@"startUp"] isEqualToString:@"0"]) {
                                
                                [big changeLabelTextColor:kGrayColor string:@"楼层: " other:@"1-4层"];
                            }else if ([[data stringWithKey:@"startUp"] isEqualToString:@"1"]){
                                
                                [big changeLabelTextColor:kGrayColor string:@"楼层: " other:@"5-8层"];
                            }
                            
                            
                        }else if ([title isEqualToString:@"1"]){
                            
                            title = @"有电梯";
                            //更新约束
                            [big updateViewConstraints:NSLayoutAttributeHeight constant:0];
                            
                            big = (UILabel *)[cell viewWithTag:210];
                            
                            if ([[data stringWithKey:@"lineUpWeightType"] isEqualToString:@"0"]) {
                                
                                [big changeLabelTextColor:kGrayColor string:@"大小件: " other:@"小件"];
                            }else if ([[data stringWithKey:@"lineUpWeightType"] isEqualToString:@"1"]){
                                
                                [big changeLabelTextColor:kGrayColor string:@"大小件: " other:@"大件"];
                            }
                        }
                        
                        //附加服务信息
                        [change changeLabelTextColor:kGrayColor string:@"电梯: " other:title];

                    }else{
                        
                        //更新约束
                        [change updateViewConstraints:NSLayoutAttributeHeight constant:0];
                        
                        //更新约束
                        [big updateViewConstraints:NSLayoutAttributeHeight constant:0];
 
                    }

                }
                
            }
        }
  
            break;
        case 3:
//            identifier = @"MessageDetailsTableViewCellThree";
        {
            
            for (int i = 0; i < 3; i++) {
                
                UILabel *label = (UILabel *)[cell viewWithTag:300+i];
                
                NSString *title = @"";
                
                if (0 == i) {
                    
                    title = [data stringWithKey:@"transfee"];
                    
                    [label changeLabelTextColor:kGrayColor string:@"运费: " other:[NSString stringWithFormat:@"%.2f 元",title.doubleValue]];
                    
                }else if (1 == i){
                    
                    //insurance
                    title = [data stringWithKey:@"insurance"];
                    
                    [label changeLabelTextColor:kGrayColor string:@"保险费: " other:[NSString stringWithFormat:@"%.2f 元",title.doubleValue]];
                }else if (2 == i){
                    
                    title = [data stringWithKey:@"cast"];
                    
                    [label changeLabelTextColor:kGrayColor string:@"总费用: " other:[NSString stringWithFormat:@"%.2f 元",title.doubleValue]];
                }
            }
        }

            break;
        case 4:
//            identifier = @"MessageDetailsTableViewCellFive";
        {
            for (int i = 0; i < 4; i++) {
                
                UILabel *label = (UILabel *)[cell viewWithTag:500+i];
                
                NSString *title = @"";
                
                if (0 == i) {

                    [label changeLabelTextColor:kGrayColor string:@"下单人: " other:[data stringWithKey:@"creator"]];
                }else if (1 == i){
                    title = [data stringWithKey:@"orgName"];
                    
                    if (title.length == 0) {
                        title = [data stringWithKey:@"capacityOrgName"];
                    }

                    [label changeLabelTextColor:kGrayColor string:@"承接运力名: " other:title];
                }else if (2 == i){
                    
                    title = [data stringWithKey:@"remark"];
                    
                    if (title.length > 0) {
                        
                        //适应高度
                        [label fitHeightWithX:label.x Y:label.y width:label.w font:label.font Text:title];
                    }
                }else if (3 == i){
                    
                    title = [data stringWithKey:@"goodsMsg"];
                    
                    if (title.length > 0) {
                        
                        //适应高度
                        [label fitHeightWithX:label.x Y:label.y width:label.w font:label.font Text:title];
                    }
                }
            }
        }

            break;
            
        default:
            break;
    }
    
    return cell;
    
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
