//
//  OrderModel.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/21.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject


//订单编号
@property (nonatomic,strong) NSString *orderCode;

//运单编号
@property (nonatomic,strong) NSString *waybillCode;

//运单状态
@property (nonatomic,strong) NSString *isAccept;

//货物名称
@property (nonatomic,strong) NSString *productName;

//货物件数
@property (nonatomic,strong) NSString *goodsNum;

//货物重量
@property (nonatomic,strong) NSString *weight;

//货物体积
@property (nonatomic,strong) NSNumber *volume;


//收件人姓名
@property (nonatomic,strong) NSString *receivingName;

//收件人电话
@property (nonatomic,strong) NSString *receivingPhone;

//收货人地址信息
@property (nonatomic,strong) NSString *receivingAddress;

//创建时间
@property (nonatomic,strong) NSString *createTime;

+(OrderModel *)shareOrderModelWithDictionary:(NSDictionary *)dictionary;

@end
