//
//  CustomButton.h
//  XHLEBusiness
//
//  Created by xhl on 16/1/22.
//  Copyright © 2016年  zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  struct{
    //自定义一个结构体
    CGFloat top;
    CGFloat lefet;
    CGFloat bottom;
    CGFloat right;
    
}CustomLocation;


UIKIT_STATIC_INLINE CustomLocation CustomLocationMakes (CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    
    CustomLocation insets = {top, left, bottom, right};
    
    return insets;
    
}

@interface CustomButton : UIButton

@property (nonatomic,strong) UIImageView *buttonImageView;

@property (nonatomic,strong) UILabel *buttonLabel;

@property (nonatomic,strong) UILabel *otherLabel;

- (void)adjustButtonImageViewWithCustomLocation:(CustomLocation)customLocation button:(CustomButton *)button;

//图片位置 0 在上; 1 在左边; 2 在下; 3 在右边;
- (void)adjustButtonImageViewWithCustomLocation:(CustomLocation)customLocation button:(CustomButton *)button location:(NSInteger)location;

@end
