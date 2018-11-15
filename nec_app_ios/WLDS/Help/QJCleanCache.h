//
//  QJCleanCache.h
//  BQBusiness
//
//  Created by xhl on 16/5/27.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJCleanCache : NSObject

//单个文件的大小
+ (long long)fileSizeAtPath:(NSString*) filePath;
//遍历文件夹获得文件夹大小，返回多少M
+ (float )folderSizeAtPath:(NSString*) folderPath;
//清理缓存
+(void)cancelRubbshIsShowSVP:(BOOL)isShow;


@end
