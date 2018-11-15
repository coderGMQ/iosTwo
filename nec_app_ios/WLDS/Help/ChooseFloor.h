//
//  ChooseFloor.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/4/18.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseFloor : UIView


- (instancetype)initWithCompleteBlock:(void (^)(NSDictionary *data))completeBlock;

-(void)dismiss;

-(void)show;

@end
