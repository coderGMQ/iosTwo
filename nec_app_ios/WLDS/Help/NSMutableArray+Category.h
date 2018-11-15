//
//  NSMutableArray+Category.h
//  XHLEBusiness
//
//  Created by xhl on 16/1/15.
//  Copyright © 2016年  zhiyundaohe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Category)


//  将数组重复的对象去除，只保留一个
+ (NSMutableArray *)removeRepetitiveElementsWithArray:(NSArray *)array;

//可变数组排序
+ (void)sortingArray:(NSMutableArray *)array;

//根据key排序
- (void)sortWitKey:(NSString *)key;

@end
