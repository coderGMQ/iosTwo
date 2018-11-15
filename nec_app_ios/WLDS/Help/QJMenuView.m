
//
//  QJMenuView.m
//  QJDropDownMenu
//
//  Created by xhl on 16/3/29.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import "QJMenuView.h"


#define MENU_CELL_H 50.0f


@interface QJMenuView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) NSMutableArray *array;

//是否已经更改过位置信息
@property (nonatomic) BOOL change;

@end



@implementation QJMenuView

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items{
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    
    if (self) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenMenuView)];
        [self addGestureRecognizer:tap];
        tap.delegate = self;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        
        CGFloat height = 44 * items.count;
        
        if (height > kHeight) {
            
            height = kHeight - 44 *4;
        }
        //表视图
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height) style:(UITableViewStylePlain)];
//        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        [_tableView cropLayer:5];
        [_tableView borderCutWithColor:kLikeColor width:1.0];
        [self addSubview:_tableView];
        //拷贝数据
        _array = [items mutableCopy];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"TitleTableViewCellID";
    
    TitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"TitleTableViewCell" owner:self options:nil].lastObject;
    }
    
    cell.title.text =  [self.array objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidden = YES;
    
    //回传信息
    BLOCK_EXEC(self.chooseMenu,indexPath.row,[self.array objectAtIndex:indexPath.row]);
    
//    BLOCK_EXEC(self.block,indexPath.row);
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self hidenMenuView];
//}

//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self hidenMenuView];
//}

- (instancetype)initWithFrame:(CGRect)frame menuItems:(NSArray *)items{
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    
    if (self) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenMenuView)];
        
        [self addGestureRecognizer:tap];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        [window addSubview:self];
        
        CGFloat height = frame.size.height;
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height * items.count)];
        
        _backView.backgroundColor = kRGBA(0, 0, 0, 0.65);;
        
        [self addSubview:_backView];
        
        _backView.layer.masksToBounds = YES;
        
        _backView.layer.cornerRadius = 5;
        
        
        for (int i = 0; i < items.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.tag = 6584320 + i;
            
            button.frame = CGRectMake(0, i * height, frame.size.width,height - 0.5);
            [_backView addSubview:button];
            
            [button giveTitileColor:kWhiteColor withFont:kFontSize((15)) andTitile:[items objectAtIndex:i]];
            
            [button addTarget:self action:@selector(menuButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            
            if (i < items.count - 1) {
                
                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, button.v, button.w, 0.5)];
                
                [_backView addSubview:line];
                
                line.backgroundColor = kWhiteColor;
            }
        }
    }
    
    return self;
    
}
//6584320
- (void)menuButtonClick:(UIButton *)button{
//
    [self hidenMenuView];
    
    self.block(button.tag - 6584320);
}

#pragma mark == UITableView DataSoure/Delegate ==

/*
 * 设置菜单背景颜色
 *
 **/
- (void)setMenuColor:(UIColor *)color{
    
    self.backView.backgroundColor = color;
}


#pragma mark == 隐藏 ==
- (void)hidenMenuView{
    
    self.hidden = YES;
}


#pragma mark == 展示视图 ==
- (void)showMenuView{
    
    self.hidden = NO;
}


#pragma mark == 手势冲突处理 ==
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        
        return NO;
    }
    return  YES;
}

//展示视图
//展示视图
- (void)showTableViewByView:(UIView *)view offset:(CGFloat)offset again:(BOOL)again{
    
    self.hidden = NO;
    
    //判断，如果已经更改过位置，且不允许多次更改的情况，结束该方法
    if (self.change == YES && again == NO) {

        return;
    }
    
    //记录已经更改
    self.change = YES;
    
    //获取视图所在位置
    CGRect frame = [view locationInWindow];
    
    //计算位置
    if (frame.size.height + frame.origin.y + self.tableView.h < kHeight) {
        
        self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height + offset, frame.size.width, self.tableView.h);
    }else{
        
        //判断为否在屏幕范围内
        if (frame.origin.y - self.tableView.h - offset > 0) {
            
            self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y - self.tableView.h - offset, frame.size.width, self.tableView.h);
            
        }else{
            
            self.tableView.frame = CGRectMake(frame.origin.x,NAV_HEIGHT, frame.size.width, frame.origin.y - offset - NAV_HEIGHT);
        }
    }
}

- (instancetype)initWarningItems:(NSArray *)items{
    
    self = [super init];
    
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = kWindowColor;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenMenuView)];
        [self addGestureRecognizer:tap];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        
        
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = kLikeColor;
        [self addSubview:_backView];
        
        //标题
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth - kFitW(15 * 2), kFitW(45))];
        [_backView addSubview:_title];
        _title.textColor = kWhiteColor;
        _title.font = kFontSize(kFitW(18));
        _title.backgroundColor = kMainColor;
        _title.textAlignment = NSTextAlignmentCenter;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_title.x, _title.v, _title.w, kFitW(100))];
        view.backgroundColor = kWhiteColor;
        [_backView addSubview:view];
        
        //文本信息
        _message = [[UILabel alloc] initWithFrame:CGRectMake(kFitW(18), kFitW(5), view.w - kFitW(18 * 2),view.h - kFitW(5*2))];
        _message.textColor = KTEXT_COLOR;
        _message.numberOfLines = 0;
        _message.font = kFontSize(kFitW(15));
        [view addSubview:_message];
        
        CGFloat width = 0.00;
        
        CGFloat space = kFitW(15);
        
        if (items.count == 2) {
            
            width = (_title.w - space * 3) / 2;
            
            for (int i = 0; i < items.count; i++) {
    
                UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
                button.tag = 6584320 + i;
                button.frame = CGRectMake(space + (width + space) * i,view.v + kFitW(12),width,kFitW(40));
                [_backView addSubview:button];
                [button giveTitileColor:kWhiteColor withFont:kFontSize((15)) andTitile:[items objectAtIndex:i]];
                [button cropLayer:5];
                [button addTarget:self action:@selector(menuButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];

                if (i == 1) {
                    
                    width = button.v + kFitW(12);
                    
                    space = (kWidth - _title.w) / 2;
                    
                    button.backgroundColor = kGrayColor;
                    
                }else{
                    
                    button.backgroundColor = LIGHT_YELLOW;
                }
            }
            
        }else{
            
            width = _title.w - space * 2;
            
            for (int i = 0; i < items.count; i++) {
                
                UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
                button.tag = 6584320 + i;
                [button cropLayer:5];
                button.frame = CGRectMake(space,view.v + kFitW(12) + i * kFitW(40 + 5),width,kFitW(40));
                [_backView addSubview:button];
                [button giveTitileColor:kWhiteColor withFont:kFontSize((15)) andTitile:[items objectAtIndex:i]];
                
                [button addTarget:self action:@selector(menuButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
                
                button.backgroundColor = kRandomColor;
                
                if (i == items.count - 1) {
                    
                    width = button.v + kFitW(12);
                    
                    space = (kWidth - _title.w) / 2;
                    
                }
                
            }
        }
        
        _backView.frame = CGRectMake(space, (kHeight - width) / 2, _title.w, width);
        
    }
    
    return self;
    
}

@end
