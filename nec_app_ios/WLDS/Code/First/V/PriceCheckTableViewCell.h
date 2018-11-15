//
//  PriceCheckTableViewCell.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/1.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceCheckTableViewCell : UITableViewCell

//输入文本信息
@property (nonatomic,copy) void (^inputValueBlock)(NSString *text,NSInteger location);


@end
