//
//  ChooseFloor.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/4/18.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "ChooseFloor.h"

typedef void(^doneBlock)(BOOL unLift,BOOL big,BOOL five);

@interface ChooseFloor ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong)doneBlock doneBlock;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

//无电梯
@property (nonatomic) BOOL unLift;

//大件
@property (nonatomic) BOOL big;

//5层以上
@property (nonatomic) BOOL five;

@end

@implementation ChooseFloor


#pragma mark ========   按钮点击实现   ========
- (IBAction)clickInChooseFloor:(UIButton *)sender {
    
    switch (sender.tag) {
        case 100:{
            
            //修改按钮
            [sender changeButtonStatue:@[@101] view:self];
            //隐藏底部视图
            self.bottomView.hidden = YES;
            self.unLift = NO;
            self.five = NO;
        }
            break;
        case 101:{
            
            //修改按钮
            [sender changeButtonStatue:@[@100] view:self];
            
            //展示底部视图
            self.bottomView.hidden = NO;
            self.unLift = YES;
        }
            break;
        case 102:{
            
            //修改按钮
            [sender changeButtonStatue:@[@103] view:self];
            self.big = NO;
        }
            break;
        case 103:{
            
            //修改按钮
            [sender changeButtonStatue:@[@102] view:self];
            self.big = YES;
        }
            break;
        case 104:{
            //修改按钮
            [sender changeButtonStatue:@[@105] view:self];
            self.five = NO;
            
        }
            break;
        case 105:{
            
            //修改按钮
            [sender changeButtonStatue:@[@104] view:self];
            self.five = YES;
        }
            break;
            
        default:
            break;
    }
    
}


- (instancetype)initWithCompleteBlock:(void (^)(NSDictionary *data))completeBlock{
    
    self = [super init];
    
    if (self) {
        
        self = [[[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        
        [self setupUI];
        
        if (completeBlock) {
            
            //回传数据
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            self.doneBlock = ^(BOOL unLift,BOOL big,BOOL five) {

                
                //lineUpType:0无电梯1有电梯
                [dict setObject:[NSString stringWithFormat:@"%d",!unLift] forKey:@"lineUpType"];
                
                //lineUpWeightType:0小件1大件
                [dict setObject:[NSString stringWithFormat:@"%d",big] forKey:@"lineUpWeightType"];
                
                //lineUpWeightType:0小件1大件
                [dict setObject:[NSString stringWithFormat:@"%d",five] forKey:@"startUp"];
        
                completeBlock(dict);
            };
        }
    }
    
    return self;
}

#pragma mark - Action
-(void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.15 animations:^{
//        self.bottomConstraint.constant = 10;
        self.backgroundColor = kRGBA(0, 0, 0, 0.4);
        [self layoutIfNeeded];
    }];
}

#pragma mark ========   隐藏视图   ========
-(void)dismiss{

    self.doneBlock(self.unLift, self.big, self.five);
    
    [UIView animateWithDuration:0.15 animations:^{
//        self.bottomConstraint.constant = -self.frame.size.height;
        self.backgroundColor = kRGBA(0, 0, 0, 0);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
//        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
        
    }];
}

-(void)setupUI {

    self.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight);

    //点击背景是否影藏
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];

    self.backgroundColor = kRGBA(0, 0, 0, 0);
    [self layoutIfNeeded];
    
    //隐藏底部视图
    self.bottomView.hidden = YES;
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
