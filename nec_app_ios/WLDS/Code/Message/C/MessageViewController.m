//
//  MessageViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/5.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "MessageViewController.h"

#import "MessageTableViewCell.h"

#import "MessageDetailsController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *array;

//页数
@property (nonatomic) NSInteger page;

//分页总数
@property (nonatomic) NSInteger totle;

@end

@implementation MessageViewController


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

#pragma mark ========   视图加载   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.translucent = NO;
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"消息"];
    
    //注册登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotificationInMessage:) name:@"loginNotification" object:nil];
    
    //标签切换绑定通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBarInMessage:) name:@"tabBarItemChange" object:nil];
    //默认值
    self.page = 1;
    //创建加载和刷新
    [self.tableView createHeaderAction:@selector(refreshDataInMessage) footerAction:@selector(loadDataDataInMessage) target:self];
    
    //判断是否已经登录
    if ([HelperSingle shareSingle].isLogin == YES) {
        
        //获取数据
        [self gainDataInMessage];
    }    
    
}

#pragma mark ========   刷新页面   ========
- (void)refreshDataInMessage{
    
    self.page = 1;
    
    //获取数据
    [self gainDataInMessage];
    
}

#pragma mark ========   加载页面   ========
- (void)loadDataDataInMessage{
    
    //页数判断
    if (self.page < self.totle) {
        
        //获取当前展示视图
        self.tableView.footerRefreshingText = @"加载数据";
        
        self.page = self.page + 1;
        
        [self gainDataInMessage];
        
    }else {
        
        //获取当前展示视图
        self.tableView.footerRefreshingText = @"暂无更多数据";
        
        WEAKSELF
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //结束刷新状态
            [weakSelf.tableView footerEndRefreshing];
            
        });
    }
}


//获取货物跟踪列表数据
- (void)gainDataInMessage{
    
    WEAKSELF
    [NetRequestManger POST:@"push/sysNotification/findSysNotificationByPage" params:@{@"page":[NSString stringWithFormat:@"%ld",weakSelf.page],@"limit":@"10"} success:^(id response) {
        
        //数据转换
        NSDictionary *dictionary = (NSDictionary *)response;
        
        //数据请求值
        BOOL success = [dictionary[@"success"] boolValue];
        
        //判断是否请求成功
        if (success == YES) {
            
            NSDictionary *data = dictionary[@"data"];
            
            if (weakSelf.page == 1) {
                
                //移除所有数据
                [weakSelf.array removeAllObjects];
            }
            
            //分页总数
            weakSelf.totle = [data[@"pages"] integerValue];
            
            for (NSDictionary *obj in data[@"items"]) {
                
                //添加数据
                [weakSelf.array addObject:obj];
            }
            
            if (weakSelf.page == 1){
                
                //结束加载并且刷新页面
                
                // 2.2秒后刷新表格UI
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //结束刷新状态
                    [weakSelf.tableView headerEndRefreshing];
                });
                
            }else{
                //结束刷新并且刷新页面
                // 2.2秒后刷新表格UI
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    //结束刷新状态
                    [weakSelf.tableView footerEndRefreshing];
                    
                    if ([weakSelf.tableView.footerRefreshingText isContainString:@"无"]) {
                        
                        weakSelf.tableView.footerRefreshingText = @"正在加载数据";
                    }
                });
            }
            
            //刷新数据
            [weakSelf.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (weakSelf.page == 1){
            
            //结束加载并且刷新页面
            
            // 2.2秒后刷新表格UI
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //结束刷新状态
                [weakSelf.tableView headerEndRefreshing];
            });
            
        }else{
            //结束刷新并且刷新页面
            // 2.2秒后刷新表格UI
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //结束刷新状态
                [weakSelf.tableView footerEndRefreshing];
                
                if ([weakSelf.tableView.footerRefreshingText isContainString:@"无"]) {
                    
                    weakSelf.tableView.footerRefreshingText = @"正在加载数据";
                }
            });
        }
        
    }];
}

//标签切换绑定通知
- (void)changeBarInMessage:(NSNotification *)info{
    
    NSString *title = (NSString *)info.object;
    
    if ([title isEqualToString:@"消息"]) {
        //滑动到顶部
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        
        if ([HelperSingle shareSingle].isLogin == NO) {
            
            WEAKSELF
            [self toLogin:^(BOOL response) {
                weakSelf.page = 1;
                //获取数据方法
                [weakSelf gainDataInMessage];
            }];
        }else{
            self.page = 1;
            //获取数据方法
            [self gainDataInMessage];
        }
    }
}

//通知处理方法
- (void)loginNotificationInMessage:(NSNotification *)info{
    
    NSString *string = (NSString *)info.object;
    
    if ([string isEqualToString:@"0"]) {
        //退出登录,清除所有数据，刷新页面
        [self.array removeAllObjects];
        [self.tableView reloadData];
        
    }else if ([string isEqualToString:@"1"]){
        
        self.page = 1;
        //成功登录
        [self gainDataInMessage];
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
    return 8;
}

//表尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 8)];
    
    return view;
}
//表尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000000001;
}

//预估高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

//返回cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"MessageTableViewCellID";
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    NSDictionary *obj = [self.array objectAtIndex:indexPath.section];
    
    NSString *bizCode = [obj stringWithKey:@"bizCode"];
//    82订单已接受83订单已确认81订单被拒84订单异常
    if ([bizCode isEqualToString:@"81"]) {
        
        bizCode = @"订单被拒";
        
        cell.picture.image = kSetImage(@"yijujue_me@2x");
        
    }else if ([bizCode isEqualToString:@"82"]){
        
        bizCode = @"订单已接收";
        cell.picture.image = kSetImage(@"yijieshou_me@2x");
    }else if ([bizCode isEqualToString:@"83"]){
        
        bizCode = @"订单已确认";
        cell.picture.image = kSetImage(@"queren_me@2x");
    }else if ([bizCode isEqualToString:@"84"]){
        
        bizCode = @"订单异常";
        cell.picture.image = kSetImage(@"yichang_me@2x");
    }
    //状态赋值
    cell.statue.text = bizCode;
    //时间
    cell.time.text = [obj stringWithKey:@"createTime"];
    
    //适配高度
    [cell.message fitHeightWithText:[NSString stringWithFormat:@"订单信息: %@",obj[@"goodsMessage"]]];

    //订单编号
    cell.orderCode.text = [obj stringWithKey:@"batch" prefix:@"订单号:"];
    
    //运单编号
    cell.code.text = [obj stringWithKey:@"code" prefix:@"运单号:"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageDetailsController *vc = [[MessageDetailsController alloc] init];
    vc.title = @"消息详情";
    NSDictionary *obj = [self.array objectAtIndex:indexPath.section];
    vc.orderCode = obj[@"batch"];
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
