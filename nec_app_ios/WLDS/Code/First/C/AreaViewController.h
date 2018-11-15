//
//  AreaViewController.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/4/25.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaViewController : UIViewController

//区域Id
@property (nonatomic,strong) NSString *Id;

//更新前页数据
@property (nonatomic,copy) void (^chooseAreaBlock) (NSString *name,NSString *Id);

@end

