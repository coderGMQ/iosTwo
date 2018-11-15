//
//  JQWarningView.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/14.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQWarningView : UIView

//回传按钮的文本内容
@property (nonatomic,copy) void (^buttonBlock) (NSString *title);


@property (nonatomic,strong) NSString *title;


@end
