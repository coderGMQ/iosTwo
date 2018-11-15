//
//  OrderRemarkViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/13.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "OrderRemarkViewController.h"



@interface OrderRemarkViewController ()
//提交按钮
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic,strong) UILabel *placeholderLB;
@property (weak, nonatomic) IBOutlet UIView *backView;

//评论星数
@property (nonatomic) NSInteger grade;

@end

@implementation OrderRemarkViewController

#pragma mark ========   星按钮   ========
- (IBAction)starButton:(UIButton *)sender {
    
    [self changeStar:sender.tag - 100 open:YES];
}

//改变星星
- (void)changeStar:(NSInteger)index open:(BOOL)open{
    //记录星数
    self.grade = index + 1;
    
    for (NSInteger i = 0; i < 5;i++) {
        
        //按钮
        UIButton *button = (UIButton *)[self.view viewWithTag:100 + i];
        
        //是否开启交互
        button.userInteractionEnabled = open;
        
        if (i > index) {
            //未选中星星
            [button setNormal:kSetImage(@"star_g@2x")];
            
        }else{

            //选中星星
            [button setNormal:kSetImage(@"star_y@2x")];
        }
    } 
}

#pragma mark ========   上传评论   ========
- (IBAction)uploadClick:(UIButton *)sender {
    
    [NetRequestManger POST:@"lxzy/order/commentOfOrder" params:@{@"orderCode":self.orderCode,@"grade":[NSString stringWithFormat:@"%ld",self.grade],@"comment":self.textView.text} success:^(id response) {
        //数据转换
        NSDictionary *dictionary = (NSDictionary *)response;
        
        //数据请求值
        BOOL success = [dictionary[@"success"] boolValue];
        
        [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
        //展示风火轮时，禁止其他操作
        [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
        [SVProgressHUD setBackgroundColor:kLikeColor];
        [SVProgressHUD setForegroundColor:KTEXT_COLOR];
        [SVProgressHUD dismissWithDelay:1.0];
        
        //观察状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backInOrderRemark) name:@"SVProgressHUDDidDisappearNotification" object:nil];
        
        //判断是否请求成功
        if (success == YES) {
            
            [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dictionary[@"msg"]];
        }else{
            [SVProgressHUD showImage:kSetImage(@"fail@2x") status:dictionary[@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark ========   视图加载   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //默认1星
    self.grade = 1;
    
    //键盘回收
    [self.view recycleKeyBoardWithDelegate:nil];
    
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"评价"];
    [self createNavInOrderRemark];
    
    
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 5;
    [self.textView borderCutWithColor:kLikeColor width:1.0];
    //文字边距设设置
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 10);//设置页边距
    
    self.textView.textAlignment = NSTextAlignmentNatural; // 设置字体对其方式
    self.textView.font = [UIFont systemFontOfSize:16]; // 设置字体大小
    self.textView.textColor = kBlackColor; // 设置文字颜色
    [self.textView setEditable:YES]; // 设置时候可以编辑
    
    //其次在UITextView上面覆盖个UILable,UILable设置为全局变量。
    _placeholderLB = [[UILabel alloc] init];
    _placeholderLB.numberOfLines = 0;
    _placeholderLB.text = @"在此输入您的评价...";
    _placeholderLB.font = self.textView.font;
    
    _placeholderLB.enabled = NO;//lable必须设置为不可用
    _placeholderLB.backgroundColor = [UIColor clearColor];
    [self.backView addSubview:_placeholderLB];
    _placeholderLB.frame =CGRectMake(self.textView.frame.origin.x + 12, self.textView.frame.origin.y + 10, self.textView.frame.size.width - 24, self.textView.frame.size.height - 20);
    [UILabel adjustThePositionForLabel:_placeholderLB withLineSpacing:5];
    
    //是否评价
    [self isComment];
}

//是否评价
- (void)isComment{
    
    if (self.orderCode.length == 0) {
        return;
    }
    
    WEAKSELF
    //判断是否已经评价
    [NetRequestManger POST:@"lxzy/order/findOrderComment" params:@{@"orderCode":self.orderCode} success:^(id response) {
        
        //数据转换
        NSDictionary *dictionary = (NSDictionary *)response;
        
        //数据请求值
        BOOL success = [dictionary[@"success"] boolValue];
        
        //判断是否请求成功
        if (success == YES) {
            //已经评价
            NSDictionary *data = dictionary[@"data"];
            
            //评分数据获取
            NSInteger grade = [data[@"grade"] integerValue];
            
            //评分
            [weakSelf changeStar:grade open:NO];
            
            NSString *comment = [data stringWithKey:@"comment"];
            
            if (comment.length > 0) {
                weakSelf.textView.text = comment;
                weakSelf.placeholderLB.hidden = YES;
            }
            //关闭交互
            weakSelf.textView.userInteractionEnabled = weakSelf.button.userInteractionEnabled = NO;
            
            //处理按钮
            weakSelf.button.backgroundColor = kLightGrayColor;
            [weakSelf.button setTitle:@"已评价" forState:(UIControlStateNormal)];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//创建导航栏
- (void)createNavInOrderRemark{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInOrderRemark)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;

}


- (void)backInOrderRemark{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark == UITextView Delegate ==
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    kKeyBoardHiden;
    
    return YES;
}


//变化文本信息
-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        
        self.placeholderLB.hidden = NO;
        
    }else{
        self.placeholderLB.hidden = YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (range.location >= 500) {
        //控制输入文本的长度
        return  NO;
    }
    
    if ([text isEqualToString:@"\n"]) {
        //禁止输入换行
        kKeyBoardHiden;
        return NO;
        
    } else {
        
        return YES;
    }
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
