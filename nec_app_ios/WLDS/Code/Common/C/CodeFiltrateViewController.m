//
//  CodeFiltrateViewController.m
//  BNZY
//
//  Created by zhiyundaohe on 2018/1/13.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "CodeFiltrateViewController.h"

@interface CodeFiltrateViewController ()<UITextFieldDelegate>

//菜单页面
@property (nonatomic,strong) QJMenuView *menu;


@end

@implementation CodeFiltrateViewController

/* * * * * * * * * *
 *
 * @ 加载状态值
 *
 * * * * * * * * * */
- (QJMenuView *)menu{
    
    if (!_menu) {
        
        _menu = [[QJMenuView alloc] initWithFrame:self.view.bounds items:self.statueArray];
        
        WEAKSELF
        _menu.chooseMenu = ^(NSInteger index, NSString *message) {
            
            //标题文本
            UITextField *otTF = (UITextField *)[weakSelf.view viewWithTag:45673];
            
            //判断是否相同
            if (![otTF.text isEqualToString:message]) {
                
                otTF.text = message;
                
            }
        };
    }
    
    return _menu;
    
}

/* * * * * * * * * *
 *
 * @ 懒加载状态集合
 *
 * * * * * * * * * */
- (NSMutableArray *)statueArray{
    
    if (!_statueArray) {
        
        _statueArray = [[NSMutableArray alloc] init];
    }
    
    return _statueArray;
}


#pragma mark - view
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark ========   视图加载完成   ========
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = kLikeColor;
    
    [self setFont:kTitFont color:kWhiteColor title:@"筛选"];
    
    //判断是否存在标题
    if (self.name.length == 0) {
        self.name = @"";
    }
    
    //添加回收键盘手势
    [self.view recycleKeyBoardWithDelegate:nil];
    
    //创建导航栏
    [self createNavInFiltrate];
}

//赛选条件
- (void)rightBarButtoonInFiltrate{
    
    //我要代收
    QJScanViewController *vc = [[QJScanViewController alloc] init];
    vc.title = @"扫一扫";
    
    WEAKSELF
    vc.backCodeBlock = ^(NSString *code) {
        
        UITextField *tfOne = (UITextField *)[weakSelf.view viewWithTag:45670];
        //第一对象
        tfOne.text = code;
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

//创建导航栏
- (void)createNavInFiltrate{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInFiltrate)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
  
    //预置自提
    UIFont *font = kFontSize(kFitW(15));
    
    //预置宽度
    CGFloat width = [@"开始时间间: " gainWidthWithFont:font];
    
    
    //是否为时间选择呢
    if (self.checkTime == YES) {
        
        //训话创建
        for (int i = 0; i < 2; i++) {
            
            UIView *backView = [[UIView alloc] init];
            backView.backgroundColor = kWhiteColor;
            //设置标签
            backView.tag = 67500 + i;
            [self.view addSubview:backView];
            
            //文本信息
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kFitW(10), 0, width, kFitW(55))];
            label.textColor = kGrayColor;
            label.font = font;
            [backView addSubview:label];
            
            //输入文本
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(label.l + kFitW(5), label.y + kFitW(10), kWidth - label.l - kFitW(5 + 10), label.h - kFitW(10 * 2))];
            tf.delegate = self;
            tf.textColor = KTEXT_COLOR;
            //设置标签
            tf.tag = 45670 + i;
            tf.font = font;
            tf.textAlignment = NSTextAlignmentRight;
            [backView addSubview:tf];
            
            //底部细线
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(tf.x, tf.v, tf.w, 1.0)];
            [backView addSubview:line];
            line.backgroundColor = kLikeColor;
            
            //底部细线
            UILabel *lineT = [[UILabel alloc] initWithFrame:CGRectMake(0,label.v, kWidth, 1.0)];
            [backView addSubview:lineT];
            lineT.backgroundColor = kLikeColor;
            
            //设置frame
            backView.frame = CGRectMake(0, i * lineT.v, kWidth, lineT.v);
            
            //添加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChooseDateInFiltrate:)];
            [backView addGestureRecognizer:tap];
            
            //禁止输入
            tf.enabled = NO;
            
            if (0 == i) {
                
                label.text = @"开始时间:";
                tf.text = [NSDate beforeSineNow:7 formatter:@"yyyy-MM-dd"];
                
            }else if (1 == i) {
                
                label.text = @"结束时间:";
                tf.text = [NSDate getCurrentTimeWithFormat:@"yyyy-MM-dd"];

                //按钮创建
                UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
                button.titleLabel.font = kFontSize(kFitW(15));
                [self.view addSubview:button];
                [button setTitle:@"确定" forState:(UIControlStateNormal)];
                [button setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
                button.frame = CGRectMake(kFitW(20), backView.v + kFitW(35), kWidth - kFitW(20 * 2), kFitW(40));
                [button cropLayer:5];
                 button.backgroundColor = kMainColor;
                //添加监听事件
                [button addTarget:self action:@selector(sureFiltrate:) forControlEvents:(UIControlEventTouchUpInside)];
            }
        }

    }else{
        
        //右侧按钮
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"扫一扫" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtoonInFiltrate)];
        [rightBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kTitFont,NSFontAttributeName, nil] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightBar;
        rightBar.tintColor = kWhiteColor;
        
        //循环创建数量
        NSInteger count = 3;
        
        //判断是否存在状态值
        if (self.statueArray.count > 0){
            
            count = 4;
        }
        
        //循环创建
        for (int i = 0; i < count; i++) {
            
            UIView *backView = [[UIView alloc] init];
            backView.backgroundColor = kWhiteColor;
            //设置标签
            backView.tag = 67500 + i;
            [self.view addSubview:backView];
            
            //文本信息
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kFitW(10), 0, width, kFitW(55))];
            label.textColor = kGrayColor;
            label.font = font;
            [backView addSubview:label];
            
            //输入文本
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(label.l + kFitW(5), label.y + kFitW(10), kWidth - label.l - kFitW(5 + 10), label.h - kFitW(10 * 2))];
            tf.delegate = self;
            tf.textColor = KTEXT_COLOR;
            //设置标签
            tf.tag = 45670 + i;
            tf.font = font;
            tf.textAlignment = NSTextAlignmentRight;
            [backView addSubview:tf];
            
            
            //底部细线
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(tf.x, tf.v, tf.w, 1.0)];
            [backView addSubview:line];
            line.backgroundColor = kLikeColor;
            
            //底部细线
            UILabel *lineT = [[UILabel alloc] initWithFrame:CGRectMake(0,label.v, kWidth, 1.0)];
            [backView addSubview:lineT];
            lineT.backgroundColor = kLikeColor;
            
            //设置frame
            backView.frame = CGRectMake(0, i * lineT.v, kWidth, lineT.v);
            
            //判断位置信息
            if (0 == i) {
                
                label.text = [self.name stringByAppendingString:@"编号:"];
                tf.placeholder = [NSString stringWithFormat:@"请填写或扫描%@编号",self.name];
                
            }else{
                
                //添加手势
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChooseDateInFiltrate:)];
                [backView addGestureRecognizer:tap];
                
                //禁止输入
                tf.enabled = NO;
                
                if (1 == i) {
                    
                    label.text = @"开始时间:";
                    tf.text = [NSDate beforeSineNow:7 formatter:@"yyyy-MM-dd"];
                    
                }else if (2 == i) {
                    
                    label.text = @"结束时间:";
                    tf.text = [NSDate getCurrentTimeWithFormat:@"yyyy-MM-dd"];
                    
                    //确认按钮操作
                    if (count == 3){
                        
                        //按钮创建
                        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
                        button.titleLabel.font = kFontSize(kFitW(15));
                        [self.view addSubview:button];
                        [button setTitle:@"确定" forState:(UIControlStateNormal)];
                        [button setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
                        button.frame = CGRectMake(kFitW(20), backView.v + kFitW(35), kWidth - kFitW(20 * 2), kFitW(40));
                        [button cropLayer:5];
                         button.backgroundColor = kMainColor;
                        //添加监听事件
                        [button addTarget:self action:@selector(sureFiltrate:) forControlEvents:(UIControlEventTouchUpInside)];
                    }
                    
                }else{
                    
                    //移除细线
                    [line removeFromSuperview];
                    
                    label.text = [self.name stringByAppendingString:@"状态:"];
                    tf.text = @"全部";
                    tf.textAlignment = NSTextAlignmentCenter;
                    
                    //判断是否存在状态选择值
                    if (self.statueArray.count > 0) {
                        //右边视图
                        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tf.h, tf.h)];
                        tf.rightView = rightView;
                        tf.rightViewMode = UITextFieldViewModeAlways;
                        //图片位置
                        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake((rightView.w - kFitW(12)) / 2, (rightView.h - kFitW(12)) / 2, kFitW(12), kFitW(12))];
                        [rightView addSubview:iv];
                        iv.image = kSetImage(@"xiala");
                        iv.contentMode = UIViewContentModeScaleAspectFit;
                    }
                    
                    //按钮创建
                    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
                    button.titleLabel.font = kFontSize(kFitW(15));
                    [self.view addSubview:button];
                    [button setTitle:@"确定" forState:(UIControlStateNormal)];
                    [button setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
                    button.frame = CGRectMake(kFitW(20), backView.v + kFitW(35), kWidth - kFitW(20 * 2), kFitW(40));
                    [button cropLayer:5];
                     button.backgroundColor = kMainColor;
                    //添加监听事件
                    [button addTarget:self action:@selector(sureFiltrate:) forControlEvents:(UIControlEventTouchUpInside)];
                }
            }
        }
    }

}

#pragma mark ========   选择时间   ========
- (void)tapChooseDateInFiltrate:(UITapGestureRecognizer *)tap{
    
    //    67500 45670
    NSInteger index = tap.view.tag - 67500;
    
    kKeyBoardHiden;
    
    //判断是否为状态选择
    if (index == 3) {
        
        //标题文本
        UITextField *otTF = (UITextField *)[self.view viewWithTag:45670 + index];
        
        [self.menu showTableViewByView:otTF offset:0 again:NO];
        
        return;
    }
    //时间显示
    XHDateStyle dateStyle = DateStyleShowYearMonthDay;
    //时间样式
    NSString *format = @"yyyy-MM-dd";
    
    WEAKSELF
    XHDatePickerView *pickerView = [[XHDatePickerView alloc] initWithCurrentDate:[NSDate date] CompleteBlock:^(NSDate *startDate, NSDate *endDate) {
        
        if (startDate) {
            
            //标题文本
            UITextField *tf = (UITextField *)[weakSelf.view viewWithTag:45670 + index];
            
            NSString *chooseTime = [startDate stringWithFormat:format];
            
            //选择开始时间
            if (index == 1) {
                
                //标题文本
                UITextField *otTF = (UITextField *)[weakSelf.view viewWithTag:45670 + index + 1];
                
                //计算时间差
                double time = [NSDate timeInterval:otTF.text other:chooseTime];
                
                //时间差小于0赋新值
                if (time < 0){
                    
                    [weakSelf waringShow:@"选择开始时间不能晚于结束时间"];
                    
                }else{
                    
                    //文本赋新值
                    tf.text = chooseTime;
                }
                
            }else{
                
                //标题文本
                UITextField *otTF = (UITextField *)[weakSelf.view viewWithTag:45670 + index - 1];
                
                //计算时间差
                double time = [NSDate timeInterval:chooseTime other:otTF.text];
                
                //时间差小于0赋新值
                if (time < 0){
                    
                    [weakSelf waringShow:@"选择结束时间不能早于开始时间"];
                    
                }else{
                    
                    //文本赋新值
                    tf.text = chooseTime;
                }
            }
        }
    }];
    
    pickerView.datePickerStyle = dateStyle;
    
    //获取开始时间
    pickerView.dateType = DateTypeStartDate;
    
    //最小时间
    pickerView.minLimitDate = [NSDate date:@"2017-1-1" WithFormat:format];
    //最大时间设置为当前时间
    pickerView.maxLimitDate =  [[NSDate date] dateWithFormatter:format];
    
    [pickerView show];
}

#pragma mark ========   确认筛选   ========
- (void)sureFiltrate:(UIButton *)button{
    
    //45670 (编码或者开始时间文本)
    UITextField *tfOne = (UITextField *)[self.view viewWithTag:45670];
    
    //开始时间（或者结束时间）
    UITextField *tfTwo = (UITextField *)[self.view viewWithTag:45671];
    
    //是否为时间筛选
    if (self.checkTime == YES) {

        //回传筛选条件
     BLOCK_EXEC(self.codeFiltrateStatueData,@"",tfOne.text,tfTwo.text,@"");
        
    }else{
        
        //结束时间
        UITextField *tfThree = (UITextField *)[self.view viewWithTag:45672];
        
        //判断是否存在状态值
        if (self.statueArray.count == 0){
            
            //回传筛选条件
        BLOCK_EXEC(self.codeFiltrateStatueData,tfOne.text,tfTwo.text,tfThree.text,@"");
            
        }else{
            
            //标题文本
            UITextField *otTF = (UITextField *)[self.view viewWithTag:45673];
            
            //回传筛选条件
        BLOCK_EXEC(self.codeFiltrateStatueData,tfOne.text,tfTwo.text,tfThree.text,otTF.text);
        }
    }
    
   
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//左侧返回按钮点击事件
- (void)backInFiltrate{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ========   UITextFieldDelegate   ========
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return  [textField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    textField.text = [NSString removeTheSpacesForString:textField.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
