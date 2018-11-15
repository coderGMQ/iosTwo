
//
//  NetRequestManger.h
//  XHLEBusiness
//
//  Created by  zhiyundaohe on 17/11/23.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.


#import <Foundation/Foundation.h>

#import "AFNetworking.h"
/**
 *  base网络请求
 */

@interface NetRequestManger : NSObject

//post异步
+ (void)POST:(NSString *)URL params:(NSDictionary * )params success:(void (^)(id response))success
     failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))Error;

//get异步
+ (void)GET:(NSString *)URL
    success:(void (^)(id response))success
    failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))Error;


+ (void)UPLOADIMAGE:(NSString *)URL
             params:(NSDictionary *)params
        uploadImage:(UIImage *)image
            success:(void (^)(id response))success
            failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))Error;

+ (void)UPLOADIMAGEForM:(NSString *)URL params:(NSDictionary *)params uploadImage:(NSArray *)imageAry success:(void (^)(id response))success failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))Error;


+ (void)QJUPLOADIMAGE:(NSString *)URL
               params:(NSDictionary *)params
          uploadImage:(UIImage *)image witjFileName:(NSString *)fileName
              success:(void (^)(id response))success
              failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))Error;

/*
 *  上传.mp3文件
 */
+ (void)uploadVoice:(NSString *)URL params:(NSDictionary * )params  file:(NSURL *)fileUrl name:(NSString *)fileName success:(void (^)(id response))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))Error;

/*
 *  上传.mp4文件
 */
+ (void)uploadMp4:(NSString *)URL params:(NSDictionary * )params  file:(NSURL *)fileUrl name:(NSString *)fileName success:(void (^)(id response))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))Error;

//清楚所有的cookie
+(void)clearCookie;

//取消所有网络请求
+ (void)cancelRequst;


@end

