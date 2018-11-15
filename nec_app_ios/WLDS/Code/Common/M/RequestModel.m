
//  RequestModel.m
//  BNZY
//
//  Created by zhiyundaohe on 2017/10/9.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import "RequestModel.h"

@implementation RequestModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(RequestModel *)shareWithDictionary:(NSDictionary *)dictionary{
    RequestModel *model = [[RequestModel alloc] init];
    [model setValuesForKeysWithDictionary:dictionary];
    return model;
}

@end
