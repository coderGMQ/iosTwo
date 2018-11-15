//
//  QRCodeViewController.h
//  BNZY
//
//  Created by zhiyundaohe on 2017/12/22.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import "CustomViewController.h"

//二维码生成页面
@interface QRCodeViewController : CustomViewController

//二维码所需要数据
@property (nonatomic,strong) NSString *data;

@property (nonatomic) BOOL back;

@end
