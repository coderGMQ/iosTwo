//
//  HttpDataRequest.m
//  BNZY
//
//  Created by han chen on 2017/12/17.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import "HttpDataRequest.h"

@implementation HttpDataRequest

//
+(void)askListByPage:(NSDictionary *)params pageTitle:(NSString *)titleStr  requestData:(void(^)(BOOL isSuccess,NSDictionary *dic))Judege{

    NSString *requestUrl = @"";

    if ([titleStr isEqualToString:@"我的发货单"]) {
        requestUrl = @"lxzy/order/placeOrderListByPage.json";
    }
    else if ([titleStr isEqualToString:@"已完成订单"])
        {
        requestUrl = @"lxzy/order/finishOrderListByPage.json";
        }
    else if ([titleStr isEqualToString:@"我的收货单"])
        {
        requestUrl = @"lxzy/order/orderListByPageShou.json";
        }
    else if ([titleStr isEqualToString:@"客户撤销订单"])
        {
        requestUrl = @"lxzy/order/cancelOrder.json";
        }
    else if ([titleStr isEqualToString:@"客户回收回单"])
        {
        requestUrl = @"lxzy/order/recycleReceipt.json";
        }
    else if ([titleStr isEqualToString:@"客户已完成订单"])
        {
        requestUrl = @"lxzy/order/finishOrderListByPage.josn";
        }
    else if ([titleStr isEqualToString:@"客户评价订单"])
        {
        requestUrl = @"lxzy/order/commentOfOrder.josn";
        }
    else if ([titleStr isEqualToString:@"个人注册"])
        {
        requestUrl = @"lxzy/user/addUser.josn";
        }
    else if ([titleStr isEqualToString:@"企业注册"])
        {
        requestUrl = @"api/sysOrg/addOrg.josn";
        }
    else if ([titleStr isEqualToString:@"账户信息"]) {
        //登出
        requestUrl = @"lxzy/user/loginout.josn";
    }
    else if ([titleStr isEqualToString:@"密码修改"]) {
            //登出
        requestUrl = @"api/sysUser/update/password.josn";
    }
    else if ([titleStr isEqualToString:@"账户认证"]) {
            //账户认证
        requestUrl = @"lxzy/user/verification.josn";
    }
    else if ([titleStr isEqualToString:@"获取验证码"]) {
        requestUrl = @"api/sysUser/sendCheckNum.josn";
    }
    else if ([titleStr isEqualToString:@"检验验证码"]) {
        requestUrl = @"api/sysUser/checkNum.josn";
    }
    else if ([titleStr isEqualToString:@"我的物流公司"]) {
        requestUrl = @"base/clientTransportationRelation/findClientBindingOrgListByPage.josn";
    }
    else if ([titleStr isEqualToString:@"解绑"]) {
        requestUrl = @"base/clientTransportationRelation/unbindTransportation.josn";
    }



    [NetRequestManger POST:requestUrl params:params success:^(id response) {

        Judege(YES,response);
    }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                       Judege(NO, nil);
                   }];
}


    //
+(void)uploadMultiMedia:(NSArray *)imgParams pageTitle:(NSString *)titleStr  requestData:(void(^)(BOOL isSuccess,NSDictionary *dic))Judege{

        // ios android
    [NetRequestManger UPLOADIMAGEForM:@"api/upload/android.json" params:nil uploadImage:imgParams success:^(id response) {

        Judege(YES,response);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        Judege(NO, nil);
    }];

}

@end

