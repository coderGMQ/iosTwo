//
//  MyLogisticsCompanyCell.h
//  WLDS
//
//  Created by han chen on 2018/3/22.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyLogisticsComDelegate <NSObject>

    //解绑
- (void)unbundlingBtn:(UIButton *)sender;

@end

@interface MyLogisticsCompanyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIButton *Unbundlingbtn;

@property (nonatomic, weak)id <MyLogisticsComDelegate> myLogisticsdelegate;



@end
