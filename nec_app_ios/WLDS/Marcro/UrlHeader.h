
//  UrlHeader.h
//  XHLEBusiness
//  Created by  zhiyundaohe on 17/11/21.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.

#ifndef UrlHeader_h
#define UrlHeader_h

#import "AFNetworking.h"

//网络请求管理对象
#import "NetRequestManger.h"

//极光推送
#define kJG_APP_KEY @"79d77332a3d6c0a17532173b"

//正式环境
#define serverUrl @"http://www.bnzyll.com/"
#define kPictureUrlIp @"http://www.bnzyll.com"


#define kIVUrl(imagePath) [imagePath hasPrefix:@"http"] == YES ? [NSURL URLWithString:imagePath]:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kPictureUrlIp,imagePath]]

//#define kIVUrl(imagePath) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kPictureUrlIp,imagePath]]

#define kSetImage(imageName) [UIImage imageNamed:(imageName)]


#endif /* UrlHeader_h */


