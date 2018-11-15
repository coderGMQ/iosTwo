//
//  ClaimResultViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/20.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "ClaimResultViewController.h"

#import "ClaimResultCell.h"

@interface ClaimResultViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//数据集合
@property (nonatomic,strong) NSMutableArray *dataArray;

//页数
@property (nonatomic) NSInteger page;

//分页总数
@property (nonatomic) NSInteger totle;

@end

@implementation ClaimResultViewController

/* * * * * * * * * *
 *
 * @
 *
 * * * * * * * * * */
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark ========   视图加载完成   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = self.tableView.backgroundColor= kLikeColor;
    
    //默认第一页
    self.page = 1;
    
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"处理回复结果"];
    [self createNavInClaimResult];
    //键盘回收
    [self.view recycleKeyBoardWithDelegate:self];
    
    
    //创建加载和刷新
    [self.tableView createHeaderAction:@selector(refreshDataInClaimResult) footerAction:@selector(loadDataDataInClaimResult) target:self];
    
    //获取数据
    [self gainDataInClaimResult];
    
}

#pragma mark ========   刷新页面   ========
- (void)refreshDataInClaimResult{
    
    self.page = 1;
    
    //获取数据
    [self gainDataInClaimResult];
    
}

#pragma mark ========   加载页面   ========
- (void)loadDataDataInClaimResult{
    
    //页数判断
    if (self.page < self.totle) {
        
        //获取当前展示视图
        self.tableView.footerRefreshingText = @"加载数据";
        
        self.page = self.page + 1;
        
        [self gainDataInClaimResult];
        
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
#pragma mark ========   获取数据   ========
- (void)gainDataInClaimResult{
    
    WEAKSELF
    [NetRequestManger POST:@"base/orderComplain/findOrderComplain" params:@{@"page":[NSString stringWithFormat:@"%ld",weakSelf.page],@"limit":@"10"} success:^(id response) {
        
        //数据转换
        NSDictionary *dictionary = (NSDictionary *)response;
        //数据请求值
        BOOL success = [dictionary[@"success"] boolValue];
        
        //判断是否请求成功
        if (success == YES) {
            
            NSDictionary *data = dictionary[@"data"];
            
            //分页总数
            weakSelf.totle = [data[@"pages"] integerValue];
            
            if (weakSelf.page == 1) {
                
                //移除所有数据
                [weakSelf.dataArray removeAllObjects];
            }
            
            //获取数据
            NSArray *items = data[@"items"];
 
            for (NSDictionary *obj in items) {
                
                [weakSelf.dataArray addObject:obj];
            }
            
            if (weakSelf.page == 1){
                
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
            //刷新页面
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
//创建导航栏
- (void)createNavInClaimResult{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInClaimResult)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}

//左侧返回按钮点击事件
- (void)backInClaimResult{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ========   UITableViewDataSource/UITableViewDelegate   ========
//分区数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

//单个分区cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
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

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 173;
}

//返回cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"ClaimResultCellID";
    
    ClaimResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClaimResultCell" owner:self options:nil] objectAtIndex:0];
    }
    
    //获取数据对象
    NSDictionary *obj = [self.dataArray objectAtIndex:indexPath.row];

    cell.code.text = [obj stringWithKey:@"code"];
    cell.orgName.text = [obj stringWithKey:@"orgName"];
    cell.price.text = [NSString stringWithFormat:@"￥%.2f",[obj[@"claimAmount"] doubleValue]];
    //处理状态
    NSString *auditType = [obj stringWithKey:@"auditType"];
    cell.statue.textColor = kGrayColor;

    //2运力同意3运力拒绝
    if ([auditType isEqualToString:@"0"]) {
        cell.statue.text = @"处理中";
        cell.statue.textColor = kRedColor;
    }else if ([auditType isEqualToString:@"1"]){
        cell.statue.text = @"运力同意";
        cell.statue.textColor = kGreenColor;
    }else if ([auditType isEqualToString:@"2"]){
        cell.statue.text = @"运力拒绝";
        cell.statue.textColor = kGrayColor;
    }
    
    return cell;
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
