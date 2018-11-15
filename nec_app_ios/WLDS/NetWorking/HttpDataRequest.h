//
//  HttpDataRequest.h
//  BNZY
//
//  Created by han chen on 2017/12/17.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpDataRequest : NSObject

+(void)askListByPage:(NSDictionary *)params pageTitle:(NSString *)titleStr  requestData:(void(^)(BOOL isSuccess,NSDictionary *dic))Judege;

    //
+(void)uploadMultiMedia:(NSArray *)imgParams pageTitle:(NSString *)titleStr  requestData:(void(^)(BOOL isSuccess,NSDictionary *dic))Judege;

@end
