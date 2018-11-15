
//
//  InfoChooseCell.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/18.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "InfoChooseCell.h"


@interface InfoChooseCell ()

//存放于窗口的视图
@property (nonatomic,strong) UIView *putView;

//视图
@property (nonatomic,strong) UIView *backView;

//位置
@property (nonatomic) NSInteger location;


@end

@implementation InfoChooseCell

/* * * * * * * * * *
 *
 * @ 懒加载视图
 *
 * * * * * * * * * */
- (UIView *)putView{
    
    if (!_putView) {
        
        _putView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _putView.backgroundColor = kWindowColor;
        
        //添加手势处理视图
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenView)];
        [_putView addGestureRecognizer:tap];
        
        //获取窗口
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //视图添加到当前窗口
        [window addSubview:_putView];
        
        //初始化视图
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0,kHeight,kWidth,0)];
        _backView.backgroundColor = kWhiteColor;
        [_putView addSubview:_backView];
        
    }
    return _putView;
}

//隐藏视图
- (void)hidenView{
    
    WEAKSELF
    [UIView animateWithDuration:0.2 animations:^{
        
        weakSelf.backView.frame = CGRectMake(0, kHeight, kWidth,0);
        
    } completion:^(BOOL finished) {
        
        //删除视图
        [weakSelf.putView removeFromSuperview];
        weakSelf.putView = nil;
    }];
}

//展示视图
- (void)showWithItems:(NSArray *)items{
    
    if (items.count == 0) {
        return;
    }
    
    //展示视图
    self.putView.hidden = NO;
    
    
    
    //循环创建
    for (NSInteger i = 0; i < items.count; i++) {
        
        //
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,i*50, kWidth, 50)];
        [self.backView addSubview:view];
        //设置标签
        view.tag = 1000 + i;
        
        //添加选择手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseType:)];
        [view addGestureRecognizer:tap];
        
        //图片
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15,(view.h - 20) / 2, 20, 20)];
        [view addSubview:iv];
        
        iv.image = kSetImage(@"dianxuan_un");
        
        //判断是否包含
        if ([items containsObject:self.sub.text] && i == [items indexOfObject:self.sub.text]) {

            //记录位置
            self.location = i;
            iv.image = kSetImage(@"dianxuan_m");
        }
        
        //设置标签
        iv.tag = 2000 + i;
        
        //文本信息
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iv.l + 10,0, view.w - (iv.l + 10 * 2), view.h - 1.0)];
        label.textColor = KTEXT_COLOR;
        label.font = kFontSize(kFitW(15));
        //设置标签
        label.tag = 3000 + i;
        label.text = [items objectAtIndex:i];
        [view addSubview:label];
        
        //底部细线
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,label.v, kWidth, 1.0)];
        [view addSubview:line];
        line.backgroundColor = kLikeColor;
  
        if (i == items.count - 1){
            
            WEAKSELF
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.backView.frame = CGRectMake(weakSelf.backView.x,(kHeight - view.v), weakSelf.backView.w, view.v);
            }];
        }
    }
}

//选择操作
- (void)chooseType:(UITapGestureRecognizer *)tap{
    
    //修改位置
    [self chaneImage:tap.view.tag - 1000];
}

- (void)chaneImage:(NSInteger)index{
    
    //其他位置图片
    UIImageView *ot = (UIImageView *)[self.backView viewWithTag:2000 + self.location];
    ot.image = kSetImage(@"dianxuan_un");
    
    //新选中位置图片
    UIImageView *iv = (UIImageView *)[self.backView viewWithTag:2000 + index];
    iv.image = kSetImage(@"dianxuan_m");
    
    //记录新选中的位置
    self.location = index;
    
    //回传数据
    UILabel *label = (UILabel *)[self.backView viewWithTag:3000 + index];
    //子标题赋值
    self.sub.text = label.text;
    
    if (self.chooseValueBlock) {
        
        self.chooseValueBlock(index, label.text);
    }
    
    //隐藏视图
    [self hidenView];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
