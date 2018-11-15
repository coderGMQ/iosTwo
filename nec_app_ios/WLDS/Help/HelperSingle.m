//
//  HelperSingle.m
//  XHLEBusiness
//
//  Created by  zhiyundaohe on 17/11/27.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import "HelperSingle.h"

static HelperSingle *helperSingle;

@implementation HelperSingle

+ (HelperSingle *)shareSingle{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        helperSingle = [[HelperSingle alloc] init];
    });
    
    return helperSingle;
}


/* * * * * * * * * *
 *
 * @ 数据字典
 *
 * * * * * * * * * */
- (NSMutableDictionary *)dict{
    
    if (!_dict) {
        
        _dict = [[NSMutableDictionary alloc] init];
        
    }
    return _dict;
}


//解析olist文件的数据
- (NSMutableDictionary *)resolveAraeAndAddress{
    
    NSMutableArray *provinceArray = [NSMutableArray array];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    // 文件数据类型是array
    
    //文件数据类型是*dictionary
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *newArray = [dictionary allKeys];
    
    NSMutableArray *firstKeys = [NSMutableArray arrayWithArray:newArray];
    
    [NSMutableArray sortingArray:firstKeys];
    
    for (int i = 0; i < firstKeys.count; i++) {
        
        NSDictionary *secondDict = [dictionary objectForKey:[firstKeys objectAtIndex:i]];
        //省的名字
        NSString *shengName = [[secondDict allKeys] objectAtIndex:0];
        
        [provinceArray addObject:shengName];
        
        NSDictionary *shengDict = [secondDict objectForKey:shengName];
        
        NSArray *chengshiArr = [shengDict allKeys];
        
        NSMutableArray *newchengshiArr = [NSMutableArray arrayWithArray:chengshiArr];
        
        [NSMutableArray sortingArray:newchengshiArr];
        
        NSMutableDictionary *needChengShiDict = [NSMutableDictionary dictionary];
        
        for (int h = 0; h < newchengshiArr.count; h++) {
            
            NSDictionary *kgvfd =[shengDict objectForKey:[newchengshiArr objectAtIndex:h]];
            
            NSArray *shiArray = [kgvfd allKeys];
            
            NSString *shiName = [shiArray objectAtIndex:0];
            
            NSArray *xianArray = [kgvfd objectForKey:shiName];
            
            [needChengShiDict setObject:xianArray forKey:shiName];
            
        }
        
        [dataDict setObject:needChengShiDict forKey:shengName];
        
    }
    
    return dataDict;
}



-(NSDictionary *)setUpDateForArea{
    
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 600, 375, 40)];
//    label.backgroundColor = [UIColor orangeColor];
//    label.textColor = [UIColor blueColor];
//    [self.view addSubview:label];
    
    NSMutableArray *provinceArray = [NSMutableArray array];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    // 文件数据类型是array
    
    //文件数据类型是*dictionary
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *newArray = [dictionary allKeys];
    
    NSMutableArray *firstKeys = [NSMutableArray arrayWithArray:newArray];
    
    [NSMutableArray sortingArray:firstKeys];
    
    for (int i = 0; i < firstKeys.count; i++) {
        
        NSDictionary *secondDict = [dictionary objectForKey:[firstKeys objectAtIndex:i]];
        //省的名字
        NSString *shengName = [[secondDict allKeys] objectAtIndex:0];
        
        [provinceArray addObject:shengName];
        
        NSDictionary *shengDict = [secondDict objectForKey:shengName];
        
        NSArray *chengshiArr = [shengDict allKeys];
        
        NSMutableArray *newchengshiArr = [NSMutableArray arrayWithArray:chengshiArr];
        
        [NSMutableArray sortingArray:newchengshiArr];
        
        NSMutableDictionary *needChengShiDict = [NSMutableDictionary dictionary];
        
        for (int h = 0; h < newchengshiArr.count; h++) {
            
            NSDictionary *kgvfd =[shengDict objectForKey:[newchengshiArr objectAtIndex:h]];
            
            NSArray *shiArray = [kgvfd allKeys];
            
            NSString *shiName = [shiArray objectAtIndex:0];
            
            NSArray *xianArray = [kgvfd objectForKey:shiName];
            
            [needChengShiDict setObject:xianArray forKey:shiName];
            
        }
        
        [dataDict setObject:needChengShiDict forKey:shengName];
        
    }
    
    return dataDict;
    
}





@end



