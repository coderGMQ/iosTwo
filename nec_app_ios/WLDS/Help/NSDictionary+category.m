//
//  NSDictionary+category.m
//  XHLEBusiness
//
//  Created by 新货郎 on 2017/4/30.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import "NSDictionary+category.h"

@implementation NSDictionary (category)


//判断字典中是否包含某一个key
- (BOOL)includeTheKey:(NSString *)key{
    
    NSArray *array = [self allKeys];
    
    //默认不包含
    BOOL isInclude = NO;
    
    if (array.count > 0) {
        
       isInclude = [array containsObject:key];
    }
        
    return isInclude;
}

//字典中的
- (NSString *)stringWithKey:(NSString *)key{
    
    if ([self includeTheKey:key] == YES) {
        
        //判断是否为null
        if ([self[key] isEqual:[NSNull null]]) {

            return @"";
        }
        
        return [NSString stringWithFormat:@"%@",self[key]];
        
    }else{
        
        return @"";
    }
}

//字典中的
- (NSString *)stringWithKey:(NSString *)key prefix:(NSString *)prefix{
    
    if ([self includeTheKey:key] == YES) {
        
        if (prefix.length == 0) {
            
            return [NSString stringWithFormat:@"%@",self[key]];
        }else{
            return [NSString stringWithFormat:@"%@%@",prefix,self[key]];
        }
        
    }else{
        
        return @"";
    }
}
//字典转json格式字符串：
- (NSString*)dictionaryToJsonString{
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//json格式字符串转字典：
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    
    if (jsonString == nil) {
        
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    if(err) {
                
        return nil;
    }
    
    return dic;
}


@end
