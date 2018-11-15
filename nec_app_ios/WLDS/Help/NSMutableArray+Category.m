//
//  NSMutableArray+Category.m
//  XHLEBusiness
//
//  Created by xhl on 16/1/15.
//  Copyright © 2016年  zhiyundaohe. All rights reserved.
//

#import "NSMutableArray+Category.h"

//包含对类、成员变量、属性、方法的操作
#import <objc/runtime.h>
//包含消息机制
#import <objc/message.h>

@implementation NSMutableArray (Category)

//运行时避免可变数据添加为nil的空数据

/* * * * * * * * * *
 *
 * @ 该方法在类或者分类第一次家在内存的时候自动调用
 *
 * * * * * * * * * */

+ (void)load{
    
    //__NSArrayM 是 NSMutableArray真正的类型
    Method one = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:));
    
    Method two = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(em_addObject:));
    //交换方法
    method_exchangeImplementations(one, two);
    
}
/* * * * * * * * * *
 *
 * @ 自写的交换后的实现方法
 *
 * * * * * * * * * */

- (void)em_addObject:(id)object{
    
    if (object != nil){
        //注意该方法的调用，因为方法实现已经替换了，如果调用addObject:方法，会造成死循环，调用em_addObject:其实是在调用addObject:方法
        [self em_addObject:object];
    }
}
//  将数组重复的对象去除，只保留一个
+ (NSMutableArray *)removeRepetitiveElementsWithArray:(NSArray *)array{
    
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    
    for (unsigned i = 0; i < [array count]; i++) {
        
        if ([categoryArray containsObject:[array objectAtIndex:i]] == NO) {
            
            [categoryArray addObject:[array objectAtIndex:i]];
        }
    }
    
    return categoryArray;
}


//可变数组排序
+ (void)sortingArray:(NSMutableArray *)array
{
    for (int i = 0; i < array.count - 1; i++) {
        
        for (int j = i + 1; j < array.count ; j++) {
            
            NSInteger a = [[array objectAtIndex:i] intValue];
            
            NSInteger b = [[array objectAtIndex:j] intValue];
            
            if (a > b) {
                
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
}

//根据key排序
- (void)sortWitKey:(NSString *)key{

    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:key ascending:YES];
    
    [self sortUsingDescriptors:[NSArray arrayWithObject:sort]];
}

//+ (void)gfred
//{
//    NSArray *originalArray = @[@"10",@"3",@"5",@"6",@"0",@"4"];
//    //block比较方法，数组中可以是NSInteger，NSString（需要转换）
//    NSComparator finderSort = ^(id string1,id string2){
//        
//        if ([string1 integerValue] > [string2 integerValue]) {
//            
//            return (NSComparisonResult)NSOrderedDescending;
//            
//        }else if ([string1 integerValue] < [string2 integerValue]){
//            
//            return (NSComparisonResult)NSOrderedAscending;
//            
//        }else{
//            
//            return (NSComparisonResult)NSOrderedSame;
//        }
//    };
//    
//    //        //数组排序：
//    NSArray *resultArray = [originalArray sortedArrayUsingComparator:finderSort];
//
//    
//}



@end
