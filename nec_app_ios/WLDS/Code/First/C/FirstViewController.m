//
//  FirstViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/2/26.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "FirstViewController.h"

//在线支付
#import "PayOnlineViewController.h"
#import "MyDispatchViewController.h"

//服务项目
#import "ServeCollectionViewController.h"

//价格时效
#import "AgingViewController.h"

//投诉建议
#import "ClaimViewController.h"
//货物追踪
#import "CargoTrackingViewController.h"

//我要收货
#import "TakeGoodsViewController.h"


#import "FirstBottomCell.h"


@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *topView;

//下一步数据
@property (nonatomic,strong) NSMutableDictionary *nextDict;

//数据集合
@property (nonatomic,strong) NSMutableArray *array;


@end

@implementation FirstViewController

/* * * * * * * * * *
 *
 * @ 数据集合
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
- (NSMutableDictionary *)nextDict{
    
    if (!_nextDict) {
        _nextDict = [[NSMutableDictionary alloc] init];
    }
    return _nextDict;
}

/* * * * * * * * * *
 *
 * @ 懒加载表视图
 *
 * * * * * * * * * */
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -TOP_HEIGHT, kWidth, kHeight)style:(UITableViewStyleGrouped)];
        _tableView.separatorStyle = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.showsVerticalScrollIndicator = NO;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
/* * * * * * * * * *
 *
 * @ 懒加载顶部视图
 *
 * * * * * * * * * */
- (UIView *)topView{
    
    if (!_topView) {
        
        _topView = [[UIView alloc] init];
        
        //底部细线
        UILabel *lineT = [[UILabel alloc] initWithFrame:CGRectMake(0,0, kWidth, 30.0)];
        [_topView addSubview:lineT];
        lineT.backgroundColor = kMainColor;
        
        //顶部图片位置
        UIImageView *picIV = [[UIImageView alloc] initWithFrame:CGRectMake(0,lineT.v, kWidth, kWidth / (540.00 / 308))];
        picIV.contentMode = UIViewContentModeScaleAspectFit;
        [_topView addSubview:picIV];
        //打开交互
        picIV.userInteractionEnabled = YES;
        picIV.image = kSetImage(@"beijing@2x");
        
        //按钮创建
        UIButton *messageBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_topView addSubview:messageBtn];
        messageBtn.frame = CGRectMake(kWidth - 35,picIV.y + 15, 25, 25);
        messageBtn.backgroundColor = kMainColor;
        [messageBtn setNormal:kSetImage(@"f_saoyisao@2x")];
        //添加监听事件
        [messageBtn addTarget:self action:@selector(toMessage:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        //按钮创建
        UIButton *serviceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_topView addSubview:serviceBtn];
        serviceBtn.frame = CGRectMake(10,messageBtn.y,messageBtn.w, messageBtn.h);
        serviceBtn.backgroundColor = kMainColor;
        [serviceBtn setNormal:kSetImage(@"f_service@2x")];

        
        //搜索背景
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(serviceBtn.l + 10,messageBtn.y - 5, messageBtn.x - (serviceBtn.l + 20), messageBtn.h + 5 *2)];
        back.backgroundColor = kWhiteColor;
        [back cropLayer:3];
        [_topView addSubview:back];
        //添加手势
        [back clickWithDelegate:nil target:self action:@selector(goSearch)];
        
        //顶部图片位置
        UIImageView *searchIV = [[UIImageView alloc] initWithFrame:CGRectMake(back.w - back.h,0,back.h,back.h)];
        searchIV.contentMode = UIViewContentModeScaleAspectFit;
        [back addSubview:searchIV];
        searchIV.image = kSetImage(@"search_m@2x");
        
        //文本信息
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kWidth - kFitW(60),back.h)];
        label.textColor = kLightGrayColor;
        label.font = kFontSize(14);
        label.text = @"请输入您的订单号进行查询";
        [back addSubview:label];
        
        
        //宽度计算
        CGFloat w = kWidth - FIRST_LEFT*2;
        
        //按钮操作
        UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(FIRST_LEFT, picIV.v - 10,w, w/4)];
        [menuView cropLayer:5];
        [_topView addSubview:menuView];
        menuView.backgroundColor = kWhiteColor;
        
        for (int i = 0; i < 5; i++) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*w/5, 0, w/5, menuView.h)];
            view.tag = 1020 + i;
            [menuView addSubview:view];
            
            //添加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseMenuInFirst:)];
            [view addGestureRecognizer:tap];
            
            //蹄片
            UIImageView *IV = [[UIImageView alloc] initWithFrame:CGRectMake(view.w * 0.25,kFitW(15), view.w * 0.5,view.w * 0.5)];
            IV.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:IV];
            
            //文本信息
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,IV.v,view.w, kFitW(20))];
            label.textColor = KTEXT_COLOR;
            label.font = kFontSize(14);
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            
            switch (i) {
                case 0:{
                    
                    label.text = @"价格时效";
                    IV.image = kSetImage(@"jiageshixiao@2x");
                }
                    break;
                case 1:{
                    label.text = @"在线支付";
                    IV.image = kSetImage(@"zaixianzhifu@2x");
                }
                    break;
                case 2:{
                    label.text = @"服务项目";
                    IV.image = kSetImage(@"fuwuxiangmu@2x");
                }
                    break;
                case 3:{
                    label.text = @"我要收货";
                    IV.image = kSetImage(@"woyaoshouhuo@2x");
                }
                    break;
                case 4:{
                    label.text = @"投诉建议";
                    IV.image = kSetImage(@"tousujianyi@2x");
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        //填写视图
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(menuView.x, menuView.v + 8,menuView.w, kFitW(180))];
        [_topView addSubview:view];
        view.backgroundColor = kWhiteColor;

        //文本信息
        UILabel *orderLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view.w - 10*2, kFitW(45))];
        orderLB.textColor = KTEXT_COLOR;
        orderLB.font = kFontSize(15);
        orderLB.text = @"我要下单";
        [view addSubview:orderLB];
        
        //添加手势
        [orderLB clickWithDelegate:nil target:self action:@selector(toCreateOrder)];
        
        //下一个页面
        UIImageView *nextIV = [[UIImageView alloc] initWithFrame:CGRectMake(orderLB.w - kFitW(15), (orderLB.h - kFitW(15)) / 2, kFitW(15), kFitW(15))];
        [orderLB addSubview:nextIV];
        nextIV.image = kSetImage(@"you_r@2x");
        [nextIV cropLayer:nextIV.h/2];

        //视图背景
        view.frame = CGRectMake(menuView.x, menuView.v + 8,menuView.w, orderLB.v);
        [view cropLayer:5];
        
        //背景视图
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(view.x,view.v + 8, view.w, kFitW(44))];
        backView.backgroundColor = kWhiteColor;
        [_topView addSubview:backView];
        //剪半边
        [backView cornerWithSize:5];
        
        //文本信息
        UILabel *footprint = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, backView.w - 10*2, backView.h)];
        footprint.textColor = KTEXT_COLOR;
        footprint.font = kFontSize(15);
        footprint.text = @"货物跟踪";
        [backView addSubview:footprint];
        
        [footprint clickWithDelegate:nil target:self action:@selector(goodsInfo)];
        
        //下一个页面
        UIImageView *nextIV1 = [[UIImageView alloc] initWithFrame:CGRectMake(footprint.w - kFitW(15), (footprint.h - kFitW(15)) / 2, kFitW(15), kFitW(15))];
        [footprint addSubview:nextIV1];
        nextIV1.image = kSetImage(@"you_r@2x");
        [nextIV1 cropLayer:nextIV1.h/2];
        
        _topView.frame = CGRectMake(0, 0, kWidth, backView.v);
    }
    return _topView;
}

#pragma mark ========   去往搜索页面   ========
- (void)goSearch{
    
    //输入单号
    SearchOrderViewController *vc = [[SearchOrderViewController alloc] init];
    vc.undoPage = @"首页";
    if ([HelperSingle shareSingle].isLogin == NO) {

        WEAKSELF
        [self toLogin:^(BOOL response) {
            //跳转至搜索页面
            [weakSelf pushToVC:vc];
        }];
    }else{
        //跳转至搜索页面
        [self pushToVC:vc];
    }
}
#pragma mark ========   去往消息页面   ========
- (void)toMessage:(UIButton *)button{

    //我要代收
    QJScanViewController *vc = [[QJScanViewController alloc] init];
    vc.title = @"查单";
    if ([HelperSingle shareSingle].isLogin == YES) {
        [self pushToVC:vc];
    }else{
        
        WEAKSELF
        [self toLogin:^(BOOL response) {
            
            [weakSelf pushToVC:vc];
        }];
    }
}

#pragma mark ========   货物信息   ========
- (void)goodsInfo{

    CargoTrackingViewController *vc = [[CargoTrackingViewController alloc] init];
    
    if ([HelperSingle shareSingle].isLogin == NO) {
        
        WEAKSELF
        [self toLogin:^(BOOL response) {
            
            [weakSelf pushToVC:vc];
        }];
        
    }else{
        
        [self pushToVC:vc];
    }
    
}

#pragma mark ========   运单信息   ========
- (void)orderTrackingMsg{
    
    //判断是否登录
    if ([HelperSingle shareSingle].isLogin == NO) {
        
        //删除数据，隐藏视图
        [self.array removeAllObjects];
        [self.tableView reloadData];
        return;
    }
    
    WEAKSELF
    [NetRequestManger POST:@"biz/waybillTracking/findNewOrderTrackingMsg" params:nil success:^(id response) {
        
        //数据转换
        NSDictionary *dictionary = (NSDictionary *)response;
        
        //数据请求值
        BOOL success = [dictionary[@"success"] boolValue];
        
        //判断是否请求成功
        if (success == YES) {
            
            //移除所有数据
            [weakSelf.array removeAllObjects];
            
            if ([dictionary includeTheKey:@"data"]) {
                
                NSDictionary *data =dictionary[@"data"];
                
                //获取数据
                NSMutableDictionary *needDidct = [[NSMutableDictionary alloc] init];
                
                //赋值操作
                [needDidct setValuesForKeysWithDictionary:data];
                
                //获取数据
                NSArray *waybillTrackingList = data[@"waybillTrackingList"];
                
                for (int i = 0; i < waybillTrackingList.count; i++) {
                    
                    if (i == waybillTrackingList.count - 1) {
                        
                        //获取所需要的数据对象
                        NSDictionary *obj = [waybillTrackingList objectAtIndex:i];
                        
                        [needDidct setObject:[obj stringWithKey:@"logDate"] forKey:@"logTime"];
                        
                        //展示信息
                        [needDidct setObject:[NSString stringWithFormat:@"%@\n\n  %@",[obj stringWithKey:@"logTitle"],[obj stringWithKey:@"logContext"]] forKey:@"logMessage"];
                    }
                }
                
                //添加数据
                [weakSelf.array addObject:needDidct];
            }
            
            //刷新页面
            [weakSelf.tableView reloadData];
        }
        
    } failure:nil];
}

#pragma mark ========   去下单   ========
- (void)toCreateOrder{
    CreateOrderViewController *vc = [[CreateOrderViewController alloc] init];
    vc.type = 1;
    [self pushToVC:vc];
}

#pragma mark ========   四个菜单功能   ========
- (void)chooseMenuInFirst:(UITapGestureRecognizer *)tap{
    
    switch (tap.view.tag - 1020) {
        case 0:{
            //价格时效
            AgingViewController *vc = [[AgingViewController alloc] init];
            [self pushToVC:vc];
        }
            break;
        case 1:{
            //在线支付
            PayOnlineViewController *vc = [[PayOnlineViewController alloc] init];
            //判断是否登录
            if ([HelperSingle shareSingle].isLogin == NO) {
                
                WEAKSELF
                [self toLogin:^(BOOL response) {
                   
                    //跳转页面
                    [weakSelf pushToVC:vc];
                }];
                
            }else{
                //跳转页面
                [self pushToVC:vc];
            }
        }
            break;
        case 2:{
            //服务项目
            ServeCollectionViewController *vc = [[ServeCollectionViewController alloc] init];
            [self pushToVC:vc];
        }
            break;
        case 3:{
            //我要收货
            TakeGoodsViewController *vc = [[TakeGoodsViewController alloc] init];
            [self pushToVC:vc];

        }
            break;
        case 4:{
            //货物理赔
            ClaimViewController *vc = [[ClaimViewController alloc] init];
            [self pushToVC:vc];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark ========   视图加载   ========
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kLikeColor;

    self.tableView.tableHeaderView = self.topView;

    //获取数据信息
    [self orderTrackingMsg];
    //标签切换绑定通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBarInFirst:) name:@"tabBarItemChange" object:nil];
    
    //添加监听
    [[HelperSingle shareSingle] addObserver:self forKeyPath:@"isLogin" options:NSKeyValueObservingOptionNew context:nil];
}

//监听变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    //获取数据
    [self orderTrackingMsg];
}
//标签切换绑定通知
- (void)changeBarInFirst:(NSNotification *)info{
    
    NSString *title = (NSString *)info.object;
    
    if ([title isEqualToString:@"首页"]) {
        //滑动到顶部
        [self.tableView setContentOffset:CGPointMake(0,self.tableView.y) animated:NO];
        
        //获取数据
        [self orderTrackingMsg];
    }
}

#pragma mark ========   UITableViewDataSource/UITableViewDelegate   ========
//分区数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.array.count;
}

//单个分区cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
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

//预估高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

//返回cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"FirstBottomCellID";
    
    FirstBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FirstBottomCell" owner:self options:nil] objectAtIndex:0];
    }
    
    
    NSDictionary *obj = [self.array objectAtIndex:indexPath.section];
    
    cell.order.text = [obj stringWithKey:@"orderCode" prefix:@"订单编号:"];
    
    //时间剪切
    cell.createTime.text = [NSDate calculateChineseWeek:[obj stringWithKey:@"orderCreateTime"]];
    
    cell.logTime.text = [obj stringWithKey:@"logTime"];
    
    cell.logMessage.text = [obj stringWithKey:@"logMessage"];

    WEAKSELF
    cell.tapCodeBlock = ^{
      
        WebViewController *web = [[WebViewController alloc] init];
        web.url = [@"pages/locate.html?" stringByAppendingString:[obj stringWithKey:@"orderCode"]];
        web.title = @"订单跟踪";
        [weakSelf pushToVC:web];
    };

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *obj = [self.array objectAtIndex:indexPath.section];
    
    NodeInfoViewController *vc = [[NodeInfoViewController alloc] init];
    [vc.data setValuesForKeysWithDictionary:obj];
    [self pushToVC:vc];
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
