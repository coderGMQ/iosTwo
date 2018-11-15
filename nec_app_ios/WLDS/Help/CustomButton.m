


//
//  CustomButton.m
//  XHLEBusiness
//
//  Created by xhl on 16/1/22.
//  Copyright © 2016年  zhiyundaohe. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        _buttonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height, height)];

        
        [self addSubview:_buttonImageView];
        
        _buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(height, 0, width - height, height)];
        _buttonLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_buttonLabel];
        
    }
    return self;
}

//+ (instancetype)buttonWithType:(UIButtonType)buttonType
//{
//    CustomButton *button = [super buttonWithType:buttonType];
//    
//    button.buttonImageView = [[UIImageView alloc] init];
//    
//    
//    [button addSubview:button.buttonImageView];
//    
//    button.buttonLabel = [[UILabel alloc] init];
//    button.buttonLabel.font = [UIFont systemFontOfSize:14];
//    [button addSubview:button.buttonLabel];
//    
//    return button;
//}

- (void)adjustButtonImageViewWithCustomLocation:(CustomLocation)customLocation button:(CustomButton *)button
{

    
    button.buttonImageView.frame = CGRectMake(customLocation.lefet, customLocation.top,button.frame.size.height - 2 * customLocation.top, button.frame.size.height - 2 * customLocation.top);
    
    button.buttonLabel.frame = CGRectMake(button.buttonImageView.frame.size.width + button.buttonImageView.frame.origin.x + 3, 0 , button.frame.size.width - (button.buttonImageView.frame.size.width + button.buttonImageView.frame.origin.x + 3), button.frame.size.height);
}



- (void)adjustButtonImageViewWithCustomLocation:(CustomLocation)customLocation button:(CustomButton *)button location:(NSInteger)location
{
    
    switch (location) {
            
        case 0:
        {
            //上
            button.buttonImageView.frame = CGRectMake(customLocation.lefet, customLocation.top,button.frame.size.width - 2 * customLocation.lefet, button.frame.size.width - 2 * customLocation.lefet);
            
            button.buttonLabel.frame = CGRectMake(0,button.buttonImageView.frame.size.height +customLocation.top, button.frame.size.width, button.frame.size.height - (button.buttonImageView.frame.size.height +customLocation.top));
            button.buttonLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
            
        case 1:
        {
            //左
            button.buttonImageView.frame = CGRectMake(customLocation.lefet, customLocation.top,button.frame.size.height - 2 * customLocation.top, button.frame.size.height - 2 * customLocation.top);
            
            button.buttonLabel.frame = CGRectMake(button.buttonImageView.frame.size.width + button.buttonImageView.frame.origin.x + 3, 0 , button.frame.size.width - (button.buttonImageView.frame.size.width + button.buttonImageView.frame.origin.x + 3), button.frame.size.height);
        }
            break;
            
        case 2:
        {
            //下
            
        }
            break;
            
        case 3:
        {
            //右
            
            button.buttonImageView.frame = CGRectMake(button.frame.size.width -  customLocation.right, customLocation.top,customLocation.right, button.frame.size.height - 2 * customLocation.top);
            
            button.buttonLabel.frame = CGRectMake(0, 0 ,button.frame.size.width -  customLocation.right - 1, button.frame.size.height);
            
        }
            break;
        case 4:
        {
            //other他右上角
            
            _buttonImageView.frame = CGRectMake(customLocation.lefet, customLocation.top, button.frame.size.width - 2 *customLocation.lefet, button.frame.size.width - 2 *customLocation.lefet);
            
            _buttonLabel.frame = CGRectMake(0, _buttonImageView.frame.origin.y + _buttonImageView.frame.size.height, button.frame.size.width,button.frame.size.height - (_buttonImageView.frame.origin.y + _buttonImageView.frame.size.height));
            
            _buttonLabel.textAlignment = NSTextAlignmentCenter;
            
            _otherLabel.frame = CGRectMake(_buttonImageView.frame.origin.x + 3 *_buttonImageView.frame.size.width / 4, _buttonImageView.frame.origin.y - _buttonImageView.frame.size.width / 4, _buttonImageView.frame.size.height/2, _buttonImageView.frame.size.height/2);
            
            _otherLabel.layer.masksToBounds = YES;
            
            _otherLabel.layer.cornerRadius = _otherLabel.frame.size.height/2;
            
            _otherLabel.textAlignment = NSTextAlignmentCenter;
            
            
            
            
        }
            break;
        case 5:
        {
            //图片据最右边 (customLocation: lefet影响buttonLabel的x坐标,top影响buttonImageView的高度（和宽度一致），right和top影响buttonImageView的x坐标)
            
            _buttonImageView.frame = CGRectMake(button.frame.size.width - (button.frame.size.height - 2 * customLocation.top + customLocation.right), customLocation.top, button.frame.size.height - 2 * customLocation.top, button.frame.size.height - 2 * customLocation.top);
            
            _otherLabel.frame = CGRectMake(_buttonImageView.frame.origin.x - (_otherLabel.text.length * _otherLabel.font.pointSize + 5), 0, _otherLabel.text.length * _otherLabel.font.pointSize + 5, button.frame.size.height);
            
            _otherLabel.textAlignment = NSTextAlignmentRight;
            
            _buttonLabel.frame = CGRectMake(customLocation.lefet, 0, _buttonLabel.text.length * _buttonLabel.font.pointSize + 5,button.frame.size.height);
            
            _buttonLabel.textAlignment = NSTextAlignmentLeft;
                        
        }
            break;
            
        default:
            break;
    }
    
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
