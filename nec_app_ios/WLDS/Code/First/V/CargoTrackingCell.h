//
//  CargoTrackingCell.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/10.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CargoTrackingCell : UITableViewCell

//运单编号
@property (weak, nonatomic) IBOutlet UILabel *number;

//时间
@property (weak, nonatomic) IBOutlet UILabel *time;

//状态
@property (weak, nonatomic) IBOutlet UILabel *statue;

//发货人
@property (weak, nonatomic) IBOutlet UILabel *startPerson;

//接收人
@property (weak, nonatomic) IBOutlet UILabel *receivePerson;

//中间视图
@property (weak, nonatomic) IBOutlet UIView *midView;

//中间视图的底部图片
@property (weak, nonatomic) IBOutlet UIImageView *bottomIV;

//中间点
@property (weak, nonatomic) IBOutlet UIImageView *midPoint;

//运输中
@property (weak, nonatomic) IBOutlet UILabel *transitLB;

//右侧视图
@property (weak, nonatomic) IBOutlet UIImageView *rightIV;

//灰色线
@property (weak, nonatomic) IBOutlet UILabel *grayLine;

//发站
@property (weak, nonatomic) IBOutlet UILabel *forwardingStation;

//到站
@property (weak, nonatomic) IBOutlet UILabel *endStation;

//运单描述
@property (weak, nonatomic) IBOutlet UILabel *describeLB;

//详细时间
@property (weak, nonatomic) IBOutlet UILabel *timeDetails;



@end
