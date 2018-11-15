//
//  PayOnlineViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/2.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "PayOnlineViewController.h"

@interface PayOnlineViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

//翻页视图
@property (nonatomic,strong) PagesView *pageView;

//状态视图
@property (nonatomic,strong) UIView *statueView;

@property (nonatomic,strong) QJMenuView *menu;

//请求参数
@property (nonatomic,strong) NSMutableDictionary  *request;

//数据字典
@property (nonatomic,strong) NSMutableDictionary *dict;

@end

@implementation PayOnlineViewController

/**
 *
 * @ 懒加载集合视图
 *
 **/
- (NSMutableDictionary *)dict{
    
    if (!_dict) {
        
        _dict = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < 2; i++) {
            
            //集合
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            //key值
            NSString *key = [NSString stringWithFormat:@"%d",i];
            
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            
            //数据集合
            [data setObject:array forKey:@"array"];
            //记录翻至页数
            [data setObject:@"1" forKey:@"page"];
            //记录总页数
            [data setObject:@"1" forKey:@"pages"];
            
            //设置
            [_dict setObject:data forKey:key];
        }
    }
    return _dict;
}

/* * * * * * * * * *
 *
 * @
 *
 * * * * * * * * * */
- (NSMutableDictionary *)request{
    
    if (!_request) {
        
        _request = [[NSMutableDictionary alloc] initWithDictionary:@{@"page":@"1" ,@"limit":@"50",@"startTime":@"",@"endTime":@""}];
    }
    
    return _request;
}

/* * * * * * * * * *
 *
 * @懒加载表视图
 *
 * * * * * * * * * */
-(QJMenuView *)menu{
    
    if (!_menu) {
        
        
//        _menu = [[MenuSelect alloc] initWithFrame:self.view.bounds items:@[@{@"name":@"全部",@"type":@""},@{@"name":@"已拒绝",@"type":@"0"},@{@"name":@"已接收",@"type":@"1"},@{@"name":@"已撤回",@"type":@"3"},@{@"name":@"已确认",@"type":@"4"},@{@"name":@"有异常",@"type":@"5"}]];
        
        _menu = [[QJMenuView alloc] initWithFrame:self.view.bounds items:@[@"全部",@"已拒绝",@"已接收",@"已撤回",@"已确认",@"有异常"]];
    }
    
    return _menu;
}

/* * * * * * * * * *
 *
 * @
 *
 * * * * * * * * * */
- (UIView *)statueView{
    
    if (!_statueView) {
        
        _statueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,50)];
        _statueView.backgroundColor = kLikeColor;
        
        //文本信息
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,13,70, _statueView.h - 13 *2)];
        label.textColor = KTEXT_COLOR;
        label.font = kFontSize(15);
        label.text = @"订单状态:";
        [_statueView addSubview:label];
        
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(label.l + 5, label.y,100, label.h)];
        [_statueView addSubview:backView];
        [backView cropLayer:3];
        [backView borderCutWithColor:kLightGrayColor width:1.0];
        
        //创建手势
        [backView clickWithDelegate:nil target:self action:@selector(chooseStatue:)];
        
        
        UIImageView *IV = [[UIImageView alloc] initWithFrame:CGRectMake(backView.w - backView.h,backView.h *0.2, backView.h*0.6, backView.h *0.6)];
        [backView addSubview:IV];
        IV.image = [UIImage changeImage:kSetImage(@"next@2x") color:kLightGrayColor];
        //旋转90度
        IV.transform = CGAffineTransformMakeRotation(M_PI*0.5);
        
        //文本信息
        UILabel *statue = [[UILabel alloc] initWithFrame:CGRectMake(0,0,IV.x, backView.h)];
        statue.textColor = kGrayColor;
        statue.font = kFontSize(14);
        statue.text = @"全部";
        statue.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:statue];
    }
    return _statueView;
}

#pragma mark ========   选择状态   ========
- (void)chooseStatue:(UITapGestureRecognizer *)tap{
    
    //展示视图
    [self.menu showTableViewByView:tap.view offset:0 again:NO];
    
    self.menu.chooseMenu = ^(NSInteger index, NSString *message) {
        
    };
}


#pragma mark ========   视图加载完成   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;


    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    
    self.view.backgroundColor = kLikeColor;
    
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"在线支付"];
    [self createNavInPayOnline];
    

    //翻页视图
    _pageView = [[PagesView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - NAV_HEIGHT)];
    _pageView.backgroundColor = kWhiteColor;
    //标签纸盒
    _pageView.items = @[@"待支付",@"已支付"];
    
    //标签视图点击实现
    WEAKSELF
    _pageView.clickSegBlock = ^(NSInteger index) {
        
        //获取数据
        NSString *key = [NSString stringWithFormat:@"%ld",index];
        
        NSDictionary *data = weakSelf.dict[key];
        
        NSArray *array = data[@"array"];
        
        //数据请求条件
        if (array.count == 0) {
            
            [weakSelf resolveDataInPayOnlineWithPage:@"1" delete:index statue:1];
        }
    };
    
//    //设置代理及初始标签值
//    [_pageView setTabelViewDelagate:self tag:87890 type:0 middle:self.statueView];
    
//    //设置代理及初始标签值
//    [_pageView setTabelViewDelagate:self tag:87890 type:0 middle:nil];
    
    //底部细线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,0, kWidth, 2.0)];
    line.backgroundColor = kLikeColor;
    
    //设置代理及初始标签值
    [_pageView setTabelViewDelagate:self tag:87890 type:0 middle:line];

    //重置frame
    [self.view addSubview:_pageView];

    //获取第一个位置表视图
    UITableView *tableView = [_pageView gainTableView:0];
    //添加刷新及加载数据
    [tableView createHeaderAction:@selector(refreshInPayOnline:) footerAction:@selector(loadInPayOnline:) target:self];

    //获取第一个位置表视图
    UITableView *tableView1 = [_pageView gainTableView:1];
    //添加刷新及加载数据
    [tableView1 createHeaderAction:@selector(refreshInPayOnline:) footerAction:@selector(loadInPayOnline:) target:self];
    
    //默认数据解析
    [self resolveDataInPayOnlineWithPage:@"1" delete:0 statue:1];
   
}

//刷新数据
- (void)refreshInPayOnline:(UITableView *)tableView{

    //数据解析
    [self resolveDataInPayOnlineWithPage:@"1" delete:self.pageView.location statue:2];
}

- (void)loadInPayOnline:(UITableView *)tableView{
    
    UITableView *tableView1 = [self.pageView gainTableView:self.pageView.location];
    
    NSString *key = [NSString stringWithFormat:@"%ld",self.pageView.location];
    
    NSDictionary *data = self.dict[key];
    
    //获取读取页数
    NSInteger page = [data[@"page"] integerValue];
    
    //获取总页数
    NSInteger pages = [data[@"pages"] integerValue];
    
    //页数判断
    if (page < pages) {
        
        //获取当前展示视图
        tableView1.footerRefreshingText = @"加载数据";
        
        NSString *string = [NSString stringWithFormat:@"%ld",page + 1];
        
        [self resolveDataInPayOnlineWithPage:string delete:self.pageView.location statue:3];
        
    }else {
        
        //获取当前展示视图
        tableView1.footerRefreshingText = @"暂无更多数据";
        
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //结束刷新状态
            [tableView1 footerEndRefreshing];
            
        });
    }
}

#pragma mark ========   数据解析   ========
- (void)resolveDataInPayOnlineWithPage:(NSString *)page delete:(NSInteger)delete statue:(int)statue{
    
    WEAKSELF;
    //获取表视图
    UITableView *tableView = (UITableView *)[self.pageView gainTableView:delete];
    
    //判断是否为刷新或者加载页面，
    if (1 == statue) {
        
        //展示风火轮
        [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
        //展示风火轮时，禁止其他操作
        [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
        //显示风火轮
        [SVProgressHUD show];
    }
    
    //页数
    [self.request setObject:page forKey:@"page"];
    

    [self.request setObject:[NSString stringWithFormat:@"%ld",self.pageView.location + 1] forKey:@"payStatus"];
    //数据请求
    [NetRequestManger POST:@"lxzy/order/payOnlineOrderList" params:self.request success:^(id response) {
        
        //数据转换
        NSDictionary *dictionary = (NSDictionary *)response;
        
        //数据请求值
        BOOL success = [dictionary[@"success"] boolValue];
        
        //判断是否请求成功
        if (success == YES) {
            
            
            NSDictionary *data = dictionary[@"data"];

            //数据集合
            NSArray *items = data[@"items"];
            
            //获取数据对象
            NSString *key = [NSString stringWithFormat:@"%ld",delete];
            NSMutableDictionary *dict = weakSelf.dict[key];
            NSMutableArray *array = dict[@"array"];
            
            //记录读取信息
            [dict setObject:page forKey:@"page"];
            
            //计算页数
            NSInteger pages = [data[@"pages"] integerValue];
            
            //记录页数
            [dict setObject:[NSString stringWithFormat:@"%ld",pages] forKey:@"pages"];
            
            //判断是否需要移除数据
            if ([page isEqualToString:@"1"]) {
                
                //移除所有数据
                [array removeAllObjects];
            }
            
            //遍历数据
            for (NSDictionary *obj in items) {
                
                OrderModel *model = [OrderModel shareOrderModelWithDictionary:[NSMutableDictionary nullDic:obj]];
                
                [array addObject:model];
            }
            
            //记录标签值
            NSInteger tag = 567870 + delete;
            
            //空图片
            UIImageView *imageView = (UIImageView *)[weakSelf.pageView.scroll viewWithTag:tag];
            
            //判断是否存在数据
            if (array.count > 0) {
                
                if (imageView != nil) {
                    //移除
                    [imageView removeFromSuperview];
                }
                
            }else{
                
                if (imageView == nil) {
                    
                    imageView = [[UIImageView alloc] initWithFrame:CGRectMake( (kWidth - kFitW(50)) / 2 + delete * kWidth,(tableView.h - kFitW(50)) / 2, kFitW(50), kFitW(50))];
                    imageView.tag = tag;
                    [weakSelf.pageView.scroll addSubview:imageView];
                    imageView.image = kSetImage(@"fail@2x");
                }

            }
            
            //普通加载数据
            if (1 == statue) {
                
                //刷新数据
                [tableView reloadData];
                
                //风火轮消失
                [SVProgressHUD dismissWithDelay:0.3];
                
            }else if (2 == statue){
                
                //结束加载并且刷新页面
                
                // 2.2秒后刷新表格UI
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //结束刷新状态
                    [tableView headerEndRefreshing];
                    
                    //刷新数据
                    [tableView reloadData];
                });
                
            }else{
                //结束加载并且刷新页面
                // 2.2秒后刷新表格UI
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    //结束刷新状态
                    [tableView footerEndRefreshing];
                    
                    if ([tableView.footerRefreshingText isContainString:@"无"]) {
                        
                        tableView.footerRefreshingText = @"正在加载数据";
                    }
                    
                    //刷新数据
                    [tableView reloadData];
                });
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //普通加载数据
        if (1 == statue) {
            
            //风火轮消失
            [SVProgressHUD dismissWithDelay:0.3];
            
        }else if (2 == statue){
            
            //结束加载并且刷新页面
            
            // 2.2秒后刷新表格UI
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //结束刷新状态
                [tableView headerEndRefreshing];
            });
            
        }else{
            //结束刷新并且刷新页面
            // 2.2秒后刷新表格UI
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //结束刷新状态
                [tableView footerEndRefreshing];
                
                if ([tableView.footerRefreshingText isContainString:@"无"]) {
                    
                    tableView.footerRefreshingText = @"正在加载数据";
                }
            });
        }
        
    }];
}

//创建导航栏
- (void)createNavInPayOnline{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInPayOnline)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
    //右侧按钮
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtoonInPayOnline)];
    [rightBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kTitFont,NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBar;
    rightBar.tintColor = kWhiteColor;
    
}

#pragma mark ========   筛选按钮   ========
- (void)rightBarButtoonInPayOnline{
    
    CodeFiltrateViewController *vc = [[CodeFiltrateViewController alloc] init];
    //状态数据
    //    [vc.statueArray addObjectsFromArray:@[@"全部",@"提货费"]];
    vc.name = @"运单";
    WEAKSELF
    vc.codeFiltrateStatueData = ^(NSString *number, NSString *start, NSString *end, NSString *statue) {
        
        //筛选开始时间
        [weakSelf.request setObject:number forKey:@"orderCode"];
        //筛选开始时间
        [weakSelf.request setObject:[start stringByAppendingString:@" 00:00:00"] forKey:@"startTime"];
        //筛选结束时间
        [weakSelf.request setObject:[end stringByAppendingString:@" 23:59:59"] forKey:@"endTime"];
        
        //数据解析
        [self resolveDataInPayOnlineWithPage:@"1" delete:weakSelf.pageView.location statue:0];
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

//左侧返回按钮点击事件
- (void)backInPayOnline{
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark ========   UITableViewDataSource/UITableViewDelegate   ========
//分区数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

//单个分区cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //获取key
    NSString *key = [NSString stringWithFormat:@"%ld",tableView.tag - 87890];
    
    //获取数据对象
    NSMutableDictionary *data = self.dict[key];
    
    //数据
    NSArray *array = data[@"array"];
    
    return array.count;
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

    
    //获取key
    NSString *key = [NSString stringWithFormat:@"%ld",tableView.tag - 87890];
    
    //获取数据对象
    NSMutableDictionary *data = self.dict[key];
    
    //数据
    NSArray *array = data[@"array"];
    
    OrderModel *model = [array objectAtIndex:indexPath.row];
    
    
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
    cell.goodsInfo.text = [NSString stringWithFormat:@"名称: %@; 件数: %ld件; 重量: %.3f吨; 体积: %.3fm³",model.productName,model.goodsNum.integerValue,model.weight.doubleValue,model.volume.doubleValue];
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

    //获取key
    NSString *key = [NSString stringWithFormat:@"%ld",tableView.tag - 87890];
    
    //获取数据对象
    NSMutableDictionary *data = self.dict[key];
    
    //数据
    NSArray *array = data[@"array"];
    
    OrderModel *model = [array objectAtIndex:indexPath.row];
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
