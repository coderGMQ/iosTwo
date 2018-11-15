//
//  CargoTrackingViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/10.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "CargoTrackingViewController.h"

#import "CargoTrackingCell.h"

@interface CargoTrackingViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *array;
@property (weak, nonatomic) IBOutlet UITextField *tf;

//页数
@property (nonatomic) NSInteger page;

//分页总数
@property (nonatomic) NSInteger totle;

@end

@implementation CargoTrackingViewController

#pragma mark ========   查询运单   ========
- (IBAction)checkOrder:(UIButton *)sender {
    
    if (self.tf.text.length == 0) {
        
        [self waringShow:@"请输入追踪货物单号"];
        return;
    }
    
    //判断本地是否有数据
    if (self.array.count > 0) {
        
        //查询条件
        NSString *check = [NSString stringWithFormat:@"orderCode = %@",self.tf.text];
        
        //谓词创建
        NSPredicate *predicate = [NSPredicate predicateWithFormat:check];

        //谓词查询结果
        NSArray *array = [self.array filteredArrayUsingPredicate:predicate];
        
        //判断有无查询结果
        if (array.count > 0) {
            
            //删除原数据，添加新数据，刷新页面
            [self.array removeAllObjects];
            [self.array addObjectsFromArray:array];
            [self.tableView reloadData];
        }else{
            
            //查询
            [self gainDataInCargoTracking:self.tf.text];
        }
         
    }else{
        
        //查询
        [self gainDataInCargoTracking:self.tf.text];
    }
    
}

/* * * * * * * * * *
 *
 * @
 *
 * * * * * * * * * */
- (NSMutableArray *)array{
    
    if (!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
}

#pragma mark ========   视图加载完成   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationController.navigationBar.translucent = NO;
    
    //手势
    [self.view recycleKeyBoardWithDelegate:self];
    
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"货物追踪"];
    
    [self createNavInCargoTracking];
    
    //默认第一页面
    self.page = 1;
    
    //获取货物跟踪列表数据
    [self gainDataInCargoTracking:@""];
    
    //创建加载和刷新
    [self.tableView createHeaderAction:@selector(refreshDataInCargoTracking) footerAction:@selector(loadDataDataInCargoTracking) target:self];
    
}

#pragma mark ========   刷新页面   ========
- (void)refreshDataInCargoTracking{
    
    self.page = 1;
    
    //获取数据
    [self gainDataInCargoTracking:@""];
    
}

#pragma mark ========   加载页面   ========
- (void)loadDataDataInCargoTracking{
    
    //页数判断
    if (self.page < self.totle) {
        
        //获取当前展示视图
        self.tableView.footerRefreshingText = @"加载数据";
        
        self.page = self.page + 1;
        
        [self gainDataInCargoTracking:@""];
        
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
- (void)gainDataInCargoTracking:(NSString *)orderCode{
    
    WEAKSELF
    [NetRequestManger POST:@"lxzy/order/goodsTrackList" params:@{@"orderCode":orderCode,@"page":[NSString stringWithFormat:@"%ld",weakSelf.page],@"limit":@"10"} success:^(id response) {
        
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

//创建导航栏
- (void)createNavInCargoTracking{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInCargoTracking)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}
//左侧返回按钮点击事件
- (void)backInCargoTracking{
    
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
    
    static NSString *ID = @"CargoTrackingCellID";
    
    CargoTrackingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CargoTrackingCell" owner:self options:nil] objectAtIndex:0];
        
        cell.bottomIV.image = [UIImage changeImage:kSetImage(@"show_b@2x") color:kLikeColor];
    }    
    
    //获取数据对象
    NSDictionary *obj = [self.array objectAtIndex:indexPath.row];
    
    //订单编号
    cell.number.text = [NSString stringWithFormat:@"订单编号:%@",[obj stringWithKey:@"orderCode"]];
    
    //送货区
    cell.startPerson.text = [obj stringWithKey:@"deliveryRegion"];
    //收货区
    cell.receivePerson.text = [obj stringWithKey:@"receivingRegion"];
    
    //送货城市
    cell.forwardingStation.text = [obj stringWithKey:@"deliveryCity"];
    //收货城市
    cell.endStation.text = [obj stringWithKey:@"receivingCity"];
    
    //运单状态
    NSString *value = [obj stringWithKey:@"waybillStatus"];
    
    if ([value isEqualToString:@"运输中"]) {
        
        cell.midView.hidden = cell.midPoint.hidden = cell.transitLB.hidden = NO;
        cell.statue.hidden = YES;
        cell.grayLine.backgroundColor = kLikeColor;
        cell.describeLB.text = [NSString stringWithFormat:@"您的订单运输中，正在发往%@",cell.endStation.text];

    }else{
        
        cell.midView.hidden = cell.midPoint.hidden = cell.transitLB.hidden = YES;
        cell.statue.hidden = NO;
        cell.grayLine.backgroundColor = kMainColor;
        cell.describeLB.text = @"您的订单已签收，感谢您的使用";
        //运单状态
        cell.statue.text = value;
    }
    
    cell.rightIV.image = [UIImage changeImage:kSetImage(@"dianxuan_m@2x") color:cell.grayLine.backgroundColor];
    
    //创建时间
    cell.time.text = [NSDate calculateChineseWeek:[obj stringWithKey:@"createTime"]];
    //跟踪时间时间
    cell.timeDetails.text = [obj stringWithKey:@"trackTime"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取数据对象
    NSDictionary *obj = [self.array objectAtIndex:indexPath.row];
    
    NodeInfoViewController *vc = [[NodeInfoViewController alloc] init];
    [vc.data setValuesForKeysWithDictionary:obj];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ========   UITextFieldDelegate   ========
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //搜索
    [self checkOrder:nil];
    
    return [textField resignFirstResponder];
}

#pragma mark ========   UIScrollViewDelegate   ========
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    kKeyBoardHiden;
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
