//
//  SearchOrderViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/12.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "SearchOrderViewController.h"

@interface SearchOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>

//顶部视图
@property (nonatomic,strong) UIView *topView;

@property (nonatomic,strong) UITextField *tf;

//数据集合
@property (nonatomic,strong) NSMutableArray *array;

@end

@implementation SearchOrderViewController

/* * * * * * * * * *
 *
 * @ 懒加载数据集合
 *
 * * * * * * * * * */
- (NSMutableArray *)array{
    
    if (!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
}

/* * * * * * * * * *
 *
 * @
 *
 * * * * * * * * * */
- (UIView *)topView{
    
    if (!_topView) {
        
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 60)];
        _topView.backgroundColor = kMainColor;
        [self.view addSubview:_topView];
        
        _tf = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, _topView.w - 30, _topView.h - 20)];
        [_topView addSubview:_tf];
        _tf.placeholder = @"请输入搜索单号";
        _tf.delegate = self;
        _tf.backgroundColor = kWhiteColor;
        _tf.returnKeyType = UIReturnKeySearch;
        
        //左侧视图
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,10, _tf.h)];
        leftView.backgroundColor = kWhiteColor;
        _tf.leftViewMode = UITextFieldViewModeAlways;
        //右侧视图
        _tf.leftView = leftView;
        [_tf cropLayer:3];
        
        //按钮创建
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.titleLabel.font = kFontSize(kFitW(13));
        [button setTitle:@"获取" forState:(UIControlStateNormal)];
        [button setTitleColor:kMainColor forState:(UIControlStateNormal)];
        button.frame = CGRectMake(0, 0, _tf.h, _tf.h);
        [button setImage:kSetImage(@"search_m@2x") forState:(UIControlStateNormal)];

        [button addTarget:self action:@selector(gainNumberButton:) forControlEvents:(UIControlEventTouchUpInside)];
        
        _tf.rightViewMode = UITextFieldViewModeAlways;
        //右侧视图
        _tf.rightView = button;
    }
    return _topView;
}

#pragma mark ========   搜索按钮   ========
- (void)gainNumberButton:(UIButton *)button{
    
    if (self.tf.text.length == 0) {
        
        [self waringShow:@"请输入搜索单号"];
        
        return;
    }
    
    //查询
    [self gainDataInSearchOrder];
    
    //判断本地是否有数据
//    if (self.array.count > 0) {
//
//        //查询条件
//        NSString *check = [NSString stringWithFormat:@"orderCode = %@",self.tf.text];
//
//        //谓词创建
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:check];
//
//        //谓词查询结果
//        NSArray *array = [self.array filteredArrayUsingPredicate:predicate];
//
//        //判断有无查询结果
//        if (array.count > 0) {
//
//            //删除原数据，添加新数据，刷新页面
//            [self.array removeAllObjects];
//            [self.array addObjectsFromArray:array];
//            [self.tableView reloadData];
//
//        }else{
//
//            //查询
//            [self gainDataInSearchOrder];
//        }
//
//    }else{
    
//        //查询
//        [self gainDataInSearchOrder];
//    }
}
#pragma mark ========   视图加载   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    //设置标题
    if (self.title.length == 0) {
        
        self.title = @"搜索单号";
    }
        
    //手势
    [self.view recycleKeyBoardWithDelegate:self];
    
    self.style = 1;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.frame = CGRectMake(0,self.topView.v, kWidth,self.tableView.h - self.topView.v);
    
    //创建导航栏按钮
    [self createNavInSearchOrder];
    
    //数据请求接口 (搜索运单，默认搜索解接口)
//    self.url = @"lxzy/order/findOrderByOrderCode";精确到订单信息
    
    self.url = @"lxzy/order/seachOrder";
    
    //判断搜索页面来源
    if ([self.undoPage isEqualToString:@"我的代收货单"]) {

        //数据请求接口 - (代收搜索接口)
        self.url = @"lxzy/order/representReceiveOrderList";
        
        //获取数据
        [self gainDataInSearchOrder];

    }else if ([self.undoPage isEqualToString:@"首页"]) {
        
        WEAKSELF
        self.backBlock = ^{
            
            //返回首页
            [weakSelf.navigationController popViewControllerAnimated:NO];
        };
    }
}

#pragma mark ========   获取数据   ========
- (void)gainDataInSearchOrder{
    
    //获取数据
    if (self.url.length == 0) {
        
        return;
    }
    
    //判断页面来源
    if ([self.undoPage isEqualToString:@"首页"]) {
        
        [self.request setObject:self.tf.text forKey:@"keyword"];
        
    }else{
        
        [self.request setObject:self.tf.text forKey:@"orderCode"];
    }
    
    WEAKSELF
    
    [NetRequestManger POST:self.url params:self.request success:^(id response) {
        
        //数据转换
        NSDictionary *dictionary = (NSDictionary *)response;
            
        //数据请求值
        BOOL success = [dictionary[@"success"] boolValue];
        
        //判断是否请求成功
        if (success == YES) {
            
            NSDictionary *data = dictionary[@"data"];
            
            //移除所有数据
            [weakSelf.array removeAllObjects];
            
            for (NSDictionary *obj in data[@"items"]) {
                
                OrderModel *model = [OrderModel shareOrderModelWithDictionary:[NSMutableDictionary nullDic:obj]];
                
                [weakSelf.array addObject:model];
            }
            
            //
            if (weakSelf.array.count == 0) {
                
                [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
                //展示风火轮时，禁止其他操作
                [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
                [SVProgressHUD setBackgroundColor:kLikeColor];
                [SVProgressHUD setForegroundColor:KTEXT_COLOR];
                [SVProgressHUD dismissWithDelay:1.0];
                
                [SVProgressHUD showImage:kSetImage(@"fail@2x") status:@"未查询到更多订单"];
            }
            
            //刷新页面
            [weakSelf.tableView reloadData];
            
        }else{
            
            [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
            //展示风火轮时，禁止其他操作
            [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
            [SVProgressHUD setBackgroundColor:kLikeColor];
            [SVProgressHUD setForegroundColor:KTEXT_COLOR];
            [SVProgressHUD dismissWithDelay:1.0];
            
            [SVProgressHUD showImage:kSetImage(@"fail@2x") status:@"未查询到此订单"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
//    [NetRequestManger POST:self.url params:self.request success:^(id response) {
//
//        //数据转换
//        NSDictionary *dictionary = (NSDictionary *)response;
//
//        //搜索运单
//        if ([weakSelf.url isEqualToString:@"lxzy/order/seachOrder"]) {
//
//            //数据请求值
//            BOOL success = [dictionary[@"success"] boolValue];
//
//            //判断是否请求成功
//            if (success == YES) {
//
//                OrderModel *model = [OrderModel shareOrderModelWithDictionary:[NSMutableDictionary nullDic:dictionary[@"data"]]];
//
//                //添加数据
//                [weakSelf.array addObject:model];
//                //刷新页面
//                [weakSelf.tableView reloadData];
//
//            }else{
//
//                [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
//                //展示风火轮时，禁止其他操作
//                [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
//                [SVProgressHUD setBackgroundColor:kLikeColor];
//                [SVProgressHUD setForegroundColor:KTEXT_COLOR];
//                [SVProgressHUD dismissWithDelay:1.0];
//
//                [SVProgressHUD showImage:kSetImage(@"fail@2x") status:@"未查询到此订单"];
//
//            }
//
//        }else if ([weakSelf.url isEqualToString:@"lxzy/order/representReceiveOrderList"]) {
//
//            //数据请求值
//            BOOL success = [dictionary[@"success"] boolValue];
//
//            //判断是否请求成功
//            if (success == YES) {
//
//                NSDictionary *data = dictionary[@"data"];
//
//                for (NSDictionary *obj in data[@"items"]) {
//
//                    OrderModel *model = [OrderModel shareOrderModelWithDictionary:[NSMutableDictionary nullDic:obj]];
//
//                    [weakSelf.array addObject:model];
//                }
//
//                //刷新页面
//                [weakSelf.tableView reloadData];
//
//            }else{
//
//                [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
//                //展示风火轮时，禁止其他操作
//                [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
//                [SVProgressHUD setBackgroundColor:kLikeColor];
//                [SVProgressHUD setForegroundColor:KTEXT_COLOR];
//                [SVProgressHUD dismissWithDelay:1.0];
//
//                [SVProgressHUD showImage:kSetImage(@"fail@2x") status:@"未查询到此订单"];
//            }
//        }
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//    }];
}

//创建导航栏视图
- (void)createNavInSearchOrder{

    //右侧自定义按钮
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(0, 5, 34, 34);
    [button setImage:[UIImage changeImage:kSetImage(@"saoyisao@2x") color:kWhiteColor] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(richScan) forControlEvents:(UIControlEventTouchUpInside)];
    
    //    右侧扫一扫
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBar;
    rightBar.tintColor = kWhiteColor;

}

//扫一扫搜索
- (void)richScan{
    
    //我要代收
    QJScanViewController *vc = [[QJScanViewController alloc] init];
    vc.title = @"扫一扫";
    
    WEAKSELF
    vc.backCodeBlock = ^(NSString *code) {
        //搜索
        weakSelf.tf.text = code;
        [weakSelf gainNumberButton:nil];
    };
    [self.navigationController pushViewController:vc animated:YES];
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
    
    return nil;
}
//表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000000001;
}

//表尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}
//表尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000000001;
}


//返回cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"OrderListCellID";
    
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderListCell" owner:self options:nil] objectAtIndex:0];
    }
    
    //订单数据
    OrderModel *model = [self.array objectAtIndex:indexPath.row];

    //订单号
    cell.number.text = [@"订单号: " stringByAppendingString:model.orderCode];
    
    //运单号
    cell.code.text = [@"运单号: " stringByAppendingString:model.waybillCode];
    
    
    cell.statue.text = model.isAccept;
    
    cell.statue.layer.cornerRadius = 5;
    
    cell.statue.layer.masksToBounds=YES;
    
    cell.statue.layer.borderWidth= 1;
    
    [UITools changeBackground:cell.statue];
    
    //货物信息
    cell.goodsInfo.text = [NSString stringWithFormat:@"名称: %@; 件数: %ld件; 重量: %.3fkg; 体积: %.3fm³",model.productName,model.goodsNum.integerValue,model.weight.doubleValue,model.volume.doubleValue];
    //收货人信息
    cell.personInfo.text = [NSString stringWithFormat:@"收件人: %@; 收件人电话: %@",model.receivingName,model.receivingPhone];
    
    //地址
    cell.address.text = [@"收货地址: " stringByAppendingString:model.receivingAddress];
    
    //订单创建时间
    cell.time.text = [@"时间: " stringByAppendingString:model.createTime];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageDetailsController *vc = [[MessageDetailsController alloc] init];
    vc.title = @"订单详情";
    OrderModel *model = [self.array objectAtIndex:indexPath.row];
    vc.orderCode = model.orderCode;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//预估高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
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

#pragma mark ========   UITextFieldDelegate   ========
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //搜索获取数据
    [self gainNumberButton:nil];
    
    return [textField resignFirstResponder];
}


#pragma mark ========   UIScrollViewDelegate   ========
//拖拽回收键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    kKeyBoardHiden;
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
