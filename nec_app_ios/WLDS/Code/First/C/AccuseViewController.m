//
//  AccuseViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/20.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "AccuseViewController.h"

#import "InfoCell.h"

#import "InfoChooseCell.h"

#import "InfoOptionsCell.h"

#import "AccuseTypeViewController.h"

@interface AccuseViewController ()<UITableViewDelegate,UITableViewDataSource,InputViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//预置集合
@property (nonatomic,strong) NSMutableArray *array;

//底部视图
@property (nonatomic,strong) UIView *footerView;

@property (nonatomic,strong) InputView *putView;

//数据
@property (nonatomic,strong) NSMutableDictionary *request;

//展示视图
@property (nonatomic,strong) ShowView *showView;

@end

@implementation AccuseViewController

/* * * * * * * * * *
 *
 * @ 懒加载展示视图
 *
 * * * * * * * * * */
- (ShowView *)showView{
    
    if (!_showView) {
        _showView = [[ShowView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _showView.disTap = YES;
        
        CGFloat width =  kWidth - kFitW(40);
        
        UIView *backView = [[UIView alloc] init];
        [_showView addSubview:backView];
        backView.backgroundColor = kWhiteColor;
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake((width - kFitW(100))/2, kFitW(30),kFitW(100), kFitW(100))];
        iv.image = kSetImage(@"showAfter@2x");
        [backView addSubview:iv];
        
        //文本信息
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kFitW(20),iv.v + kFitW(20),width - kFitW(40), kFitW(80))];
        label.textColor = KTEXT_COLOR;
        label.font = kFontSize(kFitW(17));
        label.numberOfLines = 0;
        label.text = @"我们已经收到您提交的问题\n工作人员会尽快为您回复\n请您耐心等待,谢谢!";
        label.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:label];
        
        //按钮创建
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.titleLabel.font = kFontSize(kFitW(15));
        [backView addSubview:button];
        button.frame = CGRectMake(label.x,label.v + kFitW(20),label.w, kFitW(40));
        [button cropLayer:button.h/2];
        
        button.backgroundColor = kMainColor;
        [button setTitle:@"返回" forState:(UIControlStateNormal)];
        [button setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
        //添加监听事件
        [button addTarget:self action:@selector(backAfterShow) forControlEvents:(UIControlEventTouchUpInside)];
        
        backView.frame = CGRectMake((kWidth - width)/2, (kHeight - button.v - kFitW(30))/2, width, button.v+kFitW(30));
        [backView cropLayer:10];
    }
    return _showView;
}

//展示视图后
- (void)backAfterShow{

    [self.showView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:NO];

}
/* * * * * * * * * *
 *
 * @ 懒加载
 *
 * * * * * * * * * */
-(NSMutableDictionary *)request{
    
    if (!_request) {
        _request = [[NSMutableDictionary alloc] init];
    }
    return _request;
}

/* * * * * * * * * *
 *
 * @ 懒加载底部视图
 *
 * * * * * * * * * */
- (UIView *)footerView{
    
    if (!_footerView) {
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kFitW(140))];

        //输入框
        _putView = [[InputView alloc] initWithFrame:CGRectMake(0,0, kWidth,_footerView.h)];
        //预置500字
        _putView.count = 500;
        _putView.title = @"问题内容:";
        _putView.text = @"请输入您的问题内容，500字以内";
        _putView.delegate = self;
        [_footerView addSubview:_putView];
    }
    return _footerView;
}

/* * * * * * * * * *
 *
 * @ 懒加载预置参数对象
 *
 * * * * * * * * * */
- (NSMutableArray *)array{
    
    if (!_array){
        _array = [[NSMutableArray alloc] init];
  
            //附加服务
        for (int i = 0; i < 6; i++) {
            
            RequestModel *model = [[RequestModel alloc] init];
            
            switch (i) {
                case 0:{
                    //0时效类1费用类3态度问题4破损缺少遗失5咨询建议
                    model.must = YES;
                    model.type = 1;
                    model.title = @"问题类型";
                    model.field = @"problemType";

                }
                    break;
                case 1:{
                    model.must = YES;
                    //0收件人1发件人
                    model.type = 2;
                    model.title = @"客户类型";
                    model.field = @"userType";
                    model.data = @"0";
                    
                }
                    break;
                case 2:{

                    model.must = YES;
                    model.type = 0;
                    model.title = @"姓名";
                    model.field = @"name";
                    model.keyboardType = 0;
                }
                    break;
                case 3:{
                    model.must = YES;
                    model.type = 0;
                    model.title = @"手机号";
                    model.field = @"telephone";
                    model.keyboardType = 4;
                }
                    break;
                case 4:{

                    model.type = 0;
                    model.title = @"邮箱";
                    model.field = @"mail";
                    model.keyboardType = 0;
                }
                    break;
                case 5:{
                    //必须验证字段
                    model.must = YES;
                    model.type = 0;
                    model.title = @"运单号";
                    model.field = @"code";
                    if (self.code.length > 0) {
                        model.data = model.text = self.code;
                    }
                    model.keyboardType = 0;
                }
                    break;
                    
                default:
                    break;
            }

            //添加数据
            [_array addObject:model];
        }
        
    }
    return _array;
}


#pragma mark ========   视图加载完成   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationController.navigationBar.translucent = NO;
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"投诉建议"];
    [self createNavInAccuse];
    //键盘回收
    [self.view recycleKeyBoardWithDelegate:self];
    //设置底部视图
    self.tableView.tableFooterView = self.footerView;

    //注册观察键盘的变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//移动UIView
-(void)transformView:(NSNotification *)aNSNotification{
    //获取键盘弹出后的Rect
    NSValue *keyBoardEndBounds = [[aNSNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  endRect=[keyBoardEndBounds CGRectValue];
    
    //获取当前第一响应者
    UIView *view = (UIView *)[UIResponder currentFirstResponder];
    
    //获取当前响应者在窗口中的frame
    CGRect frame = [view locationInWindow];
    //比较frame差值是否被遮挡
    CGFloat value = (frame.origin.y + frame.size.height - endRect.origin.y);
    
    if (value > 0) {

        //在0.15s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动value的动画
        [UIView animateWithDuration:0.15f animations:^{
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - value, self.view.frame.size.width, self.view.frame.size.height)];
        }];

    }else{

        //返回原位置
        [self.view setFrame:CGRectMake(self.view.frame.origin.x,NAV_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    }
}

//创建导航栏
- (void)createNavInAccuse{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInAccuse)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}

//左侧返回按钮点击事件
- (void)backInAccuse{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ========   UITableViewDataSource/UITableViewDelegate   ========
//分区数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

//单个分区cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
}

//表头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 60)];
    view.backgroundColor = kWhiteColor;
    
    //图片
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, (view.h - 25)/2, 25, 25)];
    iv.image = kSetImage(@"fuwuxiangmu");
    [view addSubview:iv];
    
    //文本信息
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iv.l + 10, 0, view.w - (iv.l + 10 * 2),view.h)];
    label.textColor = KTEXT_COLOR;
    label.font = kFontSize(17);
    label.text = self.title;
    [view addSubview:label];
    
    //底部细线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,view.v - 1.0, kWidth, 1.0)];
    [view addSubview:line];
    line.backgroundColor = kLikeColor;
    return view;
    
}
//表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

//表尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}
//表尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000000001;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

//返回cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取model
    RequestModel *model = [self.array objectAtIndex:indexPath.row];
    
    NSInteger index = model.type;
    
    if (index == 0) {
        
        static NSString *identifier = @"InfoCellID";
        
        InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"InfoCell" owner:self options:nil] objectAtIndex:0];
        }
        
        //标题数据
        if (model.must == YES) {
            
            cell.title.attributedText = [NSString changeColor:kRedColor font:cell.title.font string:@"" change:@"*" last:model.title];
            
        }else{
            
            cell.title.attributedText = [NSString changeColor:kRedColor font:cell.title.font string:@"  " change:@"" last:model.title];
        }
        cell.tf.tag = 76546780 + indexPath.row;
        
        cell.tf.keyboardType = model.keyboardType;
        cell.tf.enabled = !model.ban;
        cell.tf.text = model.data;
        
        //判断是否存在占位文本
        if (model.placeholder.length > 0) {
            cell.tf.placeholder = model.placeholder;
        }else{
            cell.tf.placeholder = [NSString stringWithFormat:@"请输入%@",model.title];
        }
        
        //输入完成后的数据
        cell.endPutBlock = ^(NSString *value) {
            
            //数据文本记录
            model.data = model.text = value;
        };
        
        return cell;
        
    }else if (index == 1){
        
        static NSString *identifier = @"InfoChooseCellID";
        
        InfoChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"InfoChooseCell" owner:self options:nil] objectAtIndex:0];
        }
        //标题数据
        cell.title.attributedText = [NSString changeColor:kRedColor font:cell.title.font string:@"" change:@"*" last:model.title];
        //变化的子标题数据
        cell.sub.text = model.text;
        
        return cell;
        
    }else{
        
        static NSString *identifier = @"InfoOptionsCellID";
        
        InfoOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"InfoOptionsCell" owner:self options:nil] objectAtIndex:0];
        }
        
        //标题数据
        cell.title.attributedText = [NSString changeColor:kRedColor font:cell.title.font string:@"" change:@"*" last:model.title];
        [cell chooseWithTitle:model.text];
        
        //修改约束和位置
        [cell witdth:85 titles:@[@"收件人",@"发件人"] index:0];
        
        cell.chooseBlock = ^(NSInteger index) {
            
            //数据修改
            if (1 == index) {
                
                model.data = @"0";
            }else{
                
                model.data = @"1";
            }
        };
        
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    kKeyBoardHiden;
    
    //获取model
    RequestModel *model = [self.array objectAtIndex:indexPath.row];
    
    NSInteger index = model.type;
    
    //多选样式
    if (index == 1) {
        
        //获取cell
        InfoChooseCell *cell =  (InfoChooseCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if ([model.title isEqualToString:@"问题类型"]) {
            
            NSArray *array = @[@"时效类",@"费用类",@"态度问题",@"破损缺少遗失",@"咨询建议"];

            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"问题类型" preferredStyle:UIAlertControllerStyleActionSheet];
            
            for (int i = 0; i < array.count; i++) {
                
                //获取标题
                NSString *title = [array objectAtIndex:i];
                
                //添加title
                [alertController addAction:[UIAlertAction actionWithTitle:title style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    //标题赋值
                    cell.sub.text = title;
                    //数据赋值
                    model.text = title;
                    //存储上传数据
                    model.data = [NSString stringWithFormat:@"%d",i];
                }]];
            }
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDestructive) handler:nil]];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }
    
}

#pragma mark ========   保存   ========
//保存信息
- (IBAction)saveInfo:(UIButton *)sender {
    
    
    if ([HelperSingle shareSingle].isLogin == YES) {
        [self canSave:sender];
    }else{
        WEAKSELF
        [self toLogin:^(BOOL response) {
            [weakSelf canSave:sender];
        }];
    }
}
//允许保存
- (void)canSave:(UIButton *)button{
    
    //构造回传数据
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    //判断数据填写类型
    for (RequestModel *model in self.array) {
        
        if (model.field.length > 0) {
            
            if (model.data.length == 0) {
                model.data = @"";
            }else{
                
                if ([model.field isEqualToString:@"mail"]) {
                    //判断邮箱格式
                    if ([model.data isValidateEmail] == NO) {
                        
                        [self waringShow:@"邮箱格式有误"];
                        return;
                    }
                }else if ([model.field isEqualToString:@"telephone"]){
                    //判断手机号格式
                    if ([NSString isMobilePhone:model.data] == NO) {
                        
                        [self waringShow:@"手机号码填写有误"];
                        return;
                    }
                }
                
            }
            
            if (model.must == YES && model.data.length == 0) {
                
                [self waringShow:[NSString stringWithFormat:@"请确认%@信息",model.title]];
                //终止以下所有程序
                return;
            }
            //获取数据
            [data setObject:model.data forKey:model.field];
        }
    }
    
    //描述信息
    [data setObject:self.putView.value forKey:@"problem"];
    
    WEAKSELF
    //关闭交互
    button.userInteractionEnabled = NO;
    [NetRequestManger POST:@"base/orderComplain/insertOrderComplain" params:data success:^(id response) {
        
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
        
        //判断是否请求成功
        if (success == YES) {
            
            //记录位置(参数记录)
            [weakSelf.request setValuesForKeysWithDictionary:data];
            
            //记录位置(返回)
            [weakSelf.request setValuesForKeysWithDictionary:dictionary[@"data"]];
            
            [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dictionary[@"msg"]];
            
            //观察状态
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successSVPInAccuse) name:@"SVProgressHUDDidDisappearNotification" object:nil];
            
        }else{
            
            [SVProgressHUD showImage:kSetImage(@"fail@2x") status:dictionary[@"msg"]];
        }
        
        //打开交互
        button.userInteractionEnabled = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //打开交互
        button.userInteractionEnabled = YES;
    }];
}

#pragma mark ========   成功回传   ========
- (void)successSVPInAccuse{
    
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SVProgressHUDDidDisappearNotification" object:nil];
    //判断是否为"破损缺少遗失"
    if ([[self.request stringWithKey:@"problemType"] isEqualToString:@"3"]) {
        AccuseTypeViewController *vc = [[AccuseTypeViewController alloc] init];
        vc.obj = self.request;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        self.showView.hidden = NO;
    }
}


#pragma mark == 手势冲突处理 ==
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    //不为输入框时候，执行结束编辑
    if (![NSStringFromClass([touch.view class]) isEqualToString:@"UITextField"] && ![NSStringFromClass([touch.view class]) isEqualToString:@"UITextView"]) {
        
        kKeyBoardHiden;
    }
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        
        return NO;
    }
    
    return  YES;
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
