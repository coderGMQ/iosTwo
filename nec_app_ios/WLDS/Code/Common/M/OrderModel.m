//
//  OrderModel.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/21.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(OrderModel *)shareOrderModelWithDictionary:(NSDictionary *)dictionary{
    
    OrderModel *model = [[OrderModel alloc] init];
    
    [model setValuesForKeysWithDictionary:dictionary];
    
    return model;
}

@end
