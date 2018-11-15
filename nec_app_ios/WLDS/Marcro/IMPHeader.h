//
//  IMPHeader.h
//  XHLEBusiness
//
//  Created by  zhiyundaohe on 17/11/21.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#ifndef IMPHeader_h
#define IMPHeader_h


//支付宝
#import <AlipaySDK/AlipaySDK.h>
//微信开发者平台
#define kWXAppId @"wx5ae333f4c5a7c315"
#import "WXApi.h"

//高德地图框架包
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

//高德地图
#define KGD_APP_KEY @"659cef28ca425f9119ca04727723418f"


// =============== 类目头文件 ============
#import "UIViewController+AnimationMake.h"
#import "NSString+ChangeColor.h"
#import "UIButton+Adaptive.h"
#import "UILabel+Adaptive.h"
#import "UIColor+changColor.h"
#import "NSMutableArray+Category.h"
#import "UIView+frame.h"
#import "NSMutableDictionary+RemoveNull.h"
#import "UITableView+category.h"
#import "UISegmentedControl+category.h"
#import "UIImageView+category.h"
#import "UINavigationController+cancelLitterLine.h"
#import "NSDate+category.h"
#import "UIImage+category.h"
#import "NSDictionary+category.h"
#import "XHDatePickerView.h"
#import "NSDate+QJCategory.h"
#import "UITextField+QJCategory.h"

#import "CALayer+JQCategory.h"

#import "UIResponder+Category.h"
//
////重写使用矿建
//#import <objc/runtime.h>
// =============== 自定义部分 ============
#import "ClaimViewController.h"
//下一页cell
#import "NextTableViewCell.h"
//公共网页部分
#import "WebViewController.h"
//选择图片页面
#import "ChooseImageCell.h"

//单独标题
#import "TitleTableViewCell.h"

//消息详情、运单详情
#import "MessageDetailsController.h"

//搜索单号
#import "SearchOrderViewController.h"

//提示框
#import "JQWarningView.h"

//登录页面
#import "JQLoginViewController.h"

//二维码编码页面
#import "QRCodeViewController.h"
#import "CodeFiltrateViewController.h"

#import "CustomViewController.h"
#import "PictureCollectionViewCell.h"

#import "QJScanViewController.h"

#import "WriteShipAddressViewController.h"

//数据库操作
#import "QJPlayDataBase.h"

//下单页面
#import "CreateOrderViewController.h"

//运单节点信息
#import "NodeInfoViewController.h"

//收发货人管理
#import "ConsigneeTableViewController.h"

//运单列表
#import "OrderListCell.h"


//自定义搜索
#import "CustomSearchBar.h"
//明杰刷新
#import "MJRefresh.h"
//自带点击功能图片
#import "TapImageView.h"
//自定义按钮
#import "CustomButton.h"
//动画执行对象
#import "AnimationObject.h"
//动画
#import "XLCATransAnimation.h"
//清除缓存
#import "QJCleanCache.h"
//风火轮
#import "SVProgressHUD.h"

//网络请求管理对象
#import "NetRequestManger.h"

//自定义基本视图
#import "QJCustomView.h"
//自定义下拉菜单
#import "QJMenuView.h"

//自定义顶部视图
#import "TopView.h"
//多行输入
#import "InputView.h"

//辅助单利
#import "HelperSingle.h"

#import "AppDelegate.h"


//选择楼层
#import "ChooseFloor.h"

//翻页视图
#import "PagesView.h"

#import "ShowView.h"

#import "UITools.h"
//========================= 公用model =====================
//运单
#import "OrderModel.h"
#import "RequestModel.h"

//系统音频依赖库
#import <AVFoundation/AVFoundation.h>


#import <Foundation/Foundation.h>

//视频播放器
#import <MediaPlayer/MediaPlayer.h>

// =========================  第三方 =========================
//高德地图框架包

//环信即时通讯

#endif /* IMPHeader_h */
