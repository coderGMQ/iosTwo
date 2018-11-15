  
//  NetRequestManger.m
//  XHLEBusiness
//
//  Created by  zhiyundaohe on 17/11/23.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import "NetRequestManger.h"

@implementation NetRequestManger

//取消所有网络请求
+ (void)cancelRequst{
    
    //创建请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //取消所有数据请求
    [manager.operationQueue cancelAllOperations];
}

+ (void)POST:(NSString *)URL params:(NSDictionary * )params success:(void (^)(id response))success failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))Error{
    // 创建请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 请求超时时间
    manager.requestSerializer.timeoutInterval = 10;
    NSString *postStr = URL;
    
    if (![URL hasPrefix:@"http"]) {
        
        postStr = [NSString stringWithFormat:@"%@%@", serverUrl,URL];
    }
    
    NSMutableDictionary *dict = [params mutableCopy];
    
    // 发送post请求
    [manager POST:postStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 请求成功
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        
        success(responseDict);

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //判断是否执行了错误反馈代码
        Error( operation,error);
    }];
}

+ (void)GET:(NSString *)URL success:(void (^)(id response))success failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))Error {
    // 获得请求管理者
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    manager.requestSerializer.timeoutInterval = 10;
    NSString *getStr = URL;
    
    if (![URL hasPrefix:@"http"]) {
        
        getStr = [NSString stringWithFormat:@"%@%@", serverUrl,URL] ;
    }
    
    // 发送GET请求
    [manager GET:getStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        
        success(responseDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (!operation.responseObject) {
            
        }
        
        Error( operation,error);
    }];
}

+ (void)UPLOADIMAGE:(NSString *)URL params:(NSDictionary *)params uploadImage:(UIImage *)image success:(void (^)(id response))success failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))Error{
    // 创建请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    NSString *postStr = [NSString stringWithFormat:@"%@%@", serverUrl,URL];
    
    // 自己的图片
    //    NSString *postStr = [NSString stringWithFormat:@"%@%@", kPictureUrlIp,URL];
    
    NSMutableDictionary *dict = [params mutableCopy];
    
    [manager POST:postStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
        
        [formData appendPartWithFileData:imageData name:@"imgFile" fileName:@"head.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        success(responseDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        Error( operation,error);
        
    }];
    
}


+ (void)UPLOADIMAGEForM:(NSString *)URL params:(NSDictionary *)params uploadImage:(NSArray *)imageAry success:(void (^)(id response))success failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))Error{
        // 创建请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
        //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //
        //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];


    NSString *postStr = [NSString stringWithFormat:@"%@%@", serverUrl,URL];

        // 自己的图片
        //    NSString *postStr = [NSString stringWithFormat:@"%@%@", kPictureUrlIp,URL];

    NSMutableDictionary *dict = [params mutableCopy];

    [manager POST:postStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        for (int i = 0 ; i < imageAry.count; i++) {
            UIImage *img = [imageAry objectAtIndex:i];

            NSData *imageData = UIImageJPEGRepresentation(img, 0.1);

            [formData appendPartWithFileData:imageData name:@"imgFile" fileName:@"head.jpg" mimeType:@"image/jpeg"];
            }

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *responseDict = (NSDictionary *)responseObject;
        success(responseDict);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        Error( operation,error);

    }];

}

+ (void)QJUPLOADIMAGE:(NSString *)URL params:(NSDictionary *)params uploadImage:(UIImage *)image witjFileName:(NSString *)fileName success:(void (^)(id response))success failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))Error {
    // 创建请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    NSString *postStr = [NSString stringWithFormat:@"%@%@", serverUrl,URL];
    
    // 自己的图片
    //    NSString *postStr = [NSString stringWithFormat:@"%@%@", kPictureUrlIp,URL];
    
    NSMutableDictionary *dict = [params mutableCopy];
    
    [manager POST:postStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
        //        @"head.jpg"
        [formData appendPartWithFileData:imageData name:@"imgFile" fileName:[NSString stringWithFormat:@"%@.jpg",fileName] mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        success(responseDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        Error( operation,error);
        
    }];
    
    
}


#pragma mark --  上传图片
- (void)POSTImgWithURL:(NSString *)strURL parameters:(id)parameters imgArr:(NSArray *) imgArr success:(void(^)(NSDictionary *result))success failure:(void (^)( NSError *error))failure{
    //
    //    MBProgressHUD *_waitView = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    //    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:_waitView];
    //    _waitView.labelText = @"数据正在上传";
    //    [_waitView show:YES];
    
    
    /*
     FileData:UIImagePNGRepresentation(imgDic[@"FileData"]) //图片data
     name:imgDic[@"name"] //接口key值
     fileName:imgDic[@"FileName"] //图片名称，必须有后缀
     mimeType:imgDic[@"MineType"]]; //文件类型，后台接受使用
     */
    
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //设置默认的请求超时时间
    manager.requestSerializer.timeoutInterval = 60;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:strURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSDictionary *imgDic in imgArr) {
            
            [formData appendPartWithFileData:imgDic[@"FileData"] //图片data
                                        name:imgDic[@"name"] //接口key值
                                    fileName:imgDic[@"FileName"] //图片名称，必须有后缀
                                    mimeType:imgDic[@"MineType"]]; //文件类型，后台接受使用
            
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        success(result);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
}


+(void)clearCookie{
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    for (int i = 0; i < [cookies count]; i++) {
        
        NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
        
        if ([cookie.name isEqualToString:@"JSESSIONID"]) {
            
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}

/*
 *  上传.mp3文件
 */
+ (void)uploadVoice:(NSString *)URL params:(NSDictionary * )params  file:(NSURL *)fileUrl name:(NSString *)fileName success:(void (^)(id response))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))Error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"image/jpeg", nil];
    
    NSString *postStr = URL;
    
    if (![URL hasPrefix:@"http"]) {
        
        postStr = [NSString stringWithFormat:@"%@%@", serverUrl,URL];
    }
    
    [manager POST:postStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //              application/octer-stream   audio/mpeg video/mp4 application/octet-stream
        /* url      :  本地文件路径
         * name     :  与服务端约定的参数
         * fileName :  自己随便命名的
         * mimeType :  文件格式类型 [mp3 : application/octer-stream application/octet-stream] [mp4 : video/mp4]
         */
        
        //        [formData appendPartWithFileData:[NSData dataWithContentsOfURL:fileUrl] name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
        
        [formData appendPartWithFileURL:fileUrl name:@"file" fileName:fileName mimeType:@"application/octet-stream" error:nil];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        
        success(responseDict);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        Error( task,error);
        
//        NSLog(@" ======  MP3 上传失败 =====%@",error);
        
    }];
}

/*
 *  上传.mp4文件
 */
+ (void)uploadMp4:(NSString *)URL params:(NSDictionary * )params  file:(NSURL *)fileUrl name:(NSString *)fileName success:(void (^)(id response))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))Error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"image/jpeg", nil];
    
    NSString *postStr = URL;
    
    if (![URL hasPrefix:@"http"]) {
        
        postStr = [NSString stringWithFormat:@"%@%@", serverUrl,URL];
    }
    
    [manager POST:postStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //              application/octer-stream   audio/mpeg video/mp4 application/octet-stream
        /* url      :  本地文件路径
         * name     :  与服务端约定的参数
         * fileName :  自己随便命名的
         * mimeType :  文件格式类型 [mp3 : application/octer-stream application/octet-stream] [mp4 : video/mp4]
         */
        [formData appendPartWithFileURL:fileUrl name:@"file" fileName:fileName mimeType:@"video/mp4" error:nil];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        
        success(responseDict);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        Error( task,error);
        
//        NSLog(@" ======  MP4 上传失败 =====%@",error);
        
    }];
}

@end

