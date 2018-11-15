//
//  QJScanViewController.h
//  CALayerCreate
//
//  Created by  zhiyundaohe on 17/12/17.
//  Copyright © 2017年  zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QJScanViewController : UIViewController

//回传单号
@property (nonatomic,copy) void (^backCodeBlock) (NSString *code);

@end
