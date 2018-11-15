//
//  WriteModel.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/13.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "WriteModel.h"

@implementation WriteModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(WriteModel *)shareWriteModelWithDictionary:(NSDictionary *)dictionary{
    
    WriteModel *model = [[WriteModel alloc] init];
    
    [model setValuesForKeysWithDictionary:dictionary];
    
    return model;
}

@end
