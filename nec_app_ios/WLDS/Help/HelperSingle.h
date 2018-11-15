//
//  HelperSingle.h
//  XHLEBusiness
//
//  Created by  zhiyundaohe on 17/11/27.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HelperSingle : NSObject

//数据对象
@property (nonatomic,strong) NSMutableDictionary *dict;

//是否已经登录
@property (nonatomic) BOOL isLogin;

//版本信息
@property (nonatomic,strong) NSString *version;

//编码
@property (nonatomic,strong) NSString *code;
//预设辅助单利（创建）
+ (HelperSingle *)shareSingle;

//解析plist文件
- (NSMutableDictionary *)resolveAraeAndAddress;


@end


/*
 
     {
     "checked" : false,
     "id" : "a23252f72fd64bcebbab58ae96ad5a44",
     "expanded" : false,
         "children" : [
         {
         "checked" : false,
         "id" : "0707b5b4bfc1436da39d2d5ea12fd627",
         "expanded" : false,
             "children" : [
             {
             "checked" : false,
             "id" : "6d19ffa2325f41979e026ccdad6095ad",
             "expanded" : false,
             "href" : "",
             "text" : "应收应付汇总",
             "iconCls" : "",
             "leaf" : true
             },
             {
             "checked" : false,
             "id" : "d69cd176438444f0846596b043c4954d",
             "expanded" : false,
             "href" : "",
             "text" : "利润统计表",
             "iconCls" : "",
             "leaf" : true
             }
             ],
         "href" : "",
         "text" : "财务报表",
         "iconCls" : "",
         "leaf" : false
         },
         {
         "checked" : false,
         "id" : "2cae0c159b7f4f08bb92eece997e08e5",
         "expanded" : false,
             "children" : [
             {
             "checked" : false,
             "id" : "0e66639293cd4958a69d062bcbd3db28",
             "expanded" : false,
             "href" : "",
             "text" : "科目管理",
             "iconCls" : "",
             "leaf" : true
             },
             {
             "checked" : false,
             "id" : "b001303bf04642b0b92fad54d7a37597",
             "expanded" : false,
             "href" : "",
             "text" : "申请报销",
             "iconCls" : "",
             "leaf" : true
             },
             {
             "checked" : false,
             "id" : "f8727f9f3e9e4987a8b2dffa81845c74",
             "expanded" : false,
             "href" : "",
             "text" : "我的报销",
             "iconCls" : "",
             "leaf" : true
             }
             ],
         "href" : "",
         "text" : "员工报销",
         "iconCls" : "",
         "leaf" : false
         },
         {
         "checked" : false,
         "id" : "387ad815a89743698637874eb4585b94",
         "expanded" : false,
             "children" : [
             {
             "checked" : false,
             "id" : "321cdd0437fd4b59a76231554255c5b3",
             "expanded" : false,
             "href" : "",
             "text" : "运费核销",
             "iconCls" : "",
             "leaf" : true
             },
             {
             "checked" : false,
             "id" : "ec09959816964fdeb58aaf63ea6b230b",
             "expanded" : false,
             "href" : "",
             "text" : "支出核销",
             "iconCls" : "",
             "leaf" : true
             }
             ],
         "href" : "",
         "text" : "会计核销",
         "iconCls" : "",
         "leaf" : false
         },
         {
         "checked" : false,
         "id" : "5a4b7ab62aff44218e9a65007061872c",
         "expanded" : false,
             "children" : [
             {
             "checked" : false,
             "id" : "116037ade9844f3aafc659e105a89807",
             "expanded" : false,
             "href" : "",
             "text" : "财务审核",
             "iconCls" : "",
             "leaf" : true
             },
             {
             "checked" : false,
             "id" : "8d80786a137d494fae08681ba6fc3cff",
             "expanded" : false,
             "href" : "",
             "text" : "部门审核",
             "iconCls" : "",
             "leaf" : true
             },
             {
             "checked" : false,
             "id" : "9d670823e85b4389b83e49c11f91fa11",
             "expanded" : false,
             "href" : "",
             "text" : "批准",
             "iconCls" : "",
             "leaf" : true
             },
             {
             "checked" : false,
             "id" : "d59909900a9d44f4bec7024423bcb563",
             "expanded" : false,
             "href" : "",
             "text" : "定向审核",
             "iconCls" : "",
             "leaf" : true
             }
             ],
         "href" : "",
         "text" : "报销审核",
         "iconCls" : "",
         "leaf" : false
         },
         {
         "checked" : false,
         "id" : "b8fae5169c97481698764c8696411beb",
         "expanded" : false,
             "children" : [
             {
             "checked" : false,
             "id" : "44b4373bd9984b7ea8ec7ea67c48171c",
             "expanded" : false,
             "href" : "",
             "text" : "添加日常收入",
             "iconCls" : "",
             "leaf" : true
             },
             {
             "checked" : false,
             "id" : "abfad6f89ef74e42b8316b1e8b54cc1d",
             "expanded" : false,
             "href" : "",
             "text" : "日常收入列表",
             "iconCls" : "",
             "leaf" : true
             }
             ],
         "href" : "",
         "text" : "日常收入",
         "iconCls" : "",
         "leaf" : false
         },
         {
         "checked" : false,
         "id" : "be2bb689407f4325b5fcee45fc84ee6e",
         "expanded" : false,
             "children" : [
             {
             "checked" : false,
             "id" : "1019f1a01ed142b0bfa153f33e563fe5",
             "expanded" : false,
             "href" : "",
             "text" : "我的摊销",
             "iconCls" : "",
             "leaf" : true
             },
             {
             "checked" : false,
             "id" : "1d2ca9ccb80f42168c850b59ff8b8277",
             "expanded" : false,
             "href" : "",
             "text" : "审核",
             "iconCls" : "",
             "leaf" : true
             },
             {
             "checked" : false,
             "id" : "8b98fd6d911d462681492357ad566f56",
             "expanded" : false,
             "href" : "",
             "text" : "新建摊销",
             "iconCls" : "",
             "leaf" : true
             },
             {
             "checked" : false,
             "id" : "c9db3e78130b4227ba4c8444d0371813",
             "expanded" : false,
             "href" : "",
             "text" : "核销",
             "iconCls" : "",
             "leaf" : true
             }
             ],
         "href" : "",
         "text" : "公司摊销",
         "iconCls" : "",
         "leaf" : false
         }
         ],
     "href" : "",
     "text" : "财务管理",
     "iconCls" : "",
     "leaf" : false
     },
 
 */
