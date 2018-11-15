//
//  NSDictionary+category.h
//  XHLEBusiness
//
//  Created by 新货郎 on 2017/4/30.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (category)

//判断字典中是否包含某一个key
- (BOOL)includeTheKey:(NSString *)key;

//字典转json格式字符串：
- (NSString*)dictionaryToJsonString;

//json格式字符串转字典：
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//字典取值字符串
- (NSString *)stringWithKey:(NSString *)key;

//字典中的
- (NSString *)stringWithKey:(NSString *)key prefix:(NSString *)prefix;

@end
