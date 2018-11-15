//
//  QJCleanCache.m
//  BQBusiness
//
//  Created by xhl on 16/5/27.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import "QJCleanCache.h"

@implementation QJCleanCache


//单个文件的大小

+ (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    
    return 0;
    
}

//遍历文件夹获得文件夹大小，返回多少M

+ (float ) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize/(1024.0*1024.0);
    
}

//清理缓存
+(void)cancelRubbshIsShowSVP:(BOOL)isShow{
    
    
    //[[PlayerDataBase shareDataBase] deleteModelFromTable:@"PlayHistory" WithID:@"All"];
    
    //    //sdWebImage 清除缓存 @"com.hackemist.SDWebImageCache.default"
    //    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //    NSString *SDWebImg = [cachePath stringByAppendingString:@"/com.hackemist.SDWebImageCache.default"];
    
    
    [[NSFileManager defaultManager] removeItemAtPath:kSDWebImageDirectories error:nil];
    
    if (isShow) {
        
        [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
        //展示风火轮时，禁止其他操作
        [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
        
        [SVProgressHUD setBackgroundColor:kLightGrayColor];
        
        //        [SVProgressHUD setForegroundColor:kMainColor];
        
        [SVProgressHUD showImage:[UIImage imageNamed:@"gouxuan@2x"] status:@"清理成功"];
    }
    
}





@end
