//
//  NodeInfoViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/6.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "NodeInfoViewController.h"

#import "NodeInfoTableViewCell.h"

@interface NodeInfoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UILabel *number;

@property (weak, nonatomic) IBOutlet UILabel *time;

//数据集合
@property (nonatomic,strong) NSMutableArray *array;

@end

@implementation NodeInfoViewController

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

/* * * * * * * * * *
 *
 * @
 *
 * * * * * * * * * */
- (NSMutableDictionary *)data{
    
    if (!_data) {
        _data = [[NSMutableDictionary alloc] init];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationController.navigationBar.translucent = NO;
    
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"货物详细信息"];
    
    self.tableView.tableHeaderView = self.headerView;
    
    [self createNavInNodeInfo];
    
    //收货地址
    self.address.text = [NSString stringWithFormat:@"%@%@%@%@",[self.data stringWithKey:@"receivingProvince"],[self.data stringWithKey:@"receivingCity"],[self.data stringWithKey:@"receivingRegion"],[self.data stringWithKey:@"receivingAddress"]];
    //订单编号
    self.number.text = [@"订单编号: " stringByAppendingString:[self.data stringWithKey:@"orderCode"]];
    
    //点击按钮
    [self.number clickWithDelegate:nil target:self action:@selector(tapNumber)];
    
    //时间
    self.time.text = [NSDate calculateChineseWeek:[self.data stringWithKey:@"createTime"]];
    
    if (self.time.text.length == 0) {
        
        self.time.text = [NSDate calculateChineseWeek:[self.data stringWithKey:@"orderCreateTime"]];
    }
    
    //获取数据
    [self gainDataInNodeInfo];
}

//点击按钮
- (void)tapNumber{
    
    WebViewController *web = [[WebViewController alloc] init];
    web.url = [@"pages/locate.html?" stringByAppendingString:[self.data stringWithKey:@"orderCode"]];
    web.title = @"订单跟踪";
    [self.navigationController pushViewController:web animated:YES];
}
//获取数据
- (void)gainDataInNodeInfo{
    
    //获取订单编号
    NSString *orderCode = [self.data stringWithKey:@"orderCode"];
    
    if (orderCode.length == 0) {
        return;
    }
    WEAKSELF
    [NetRequestManger POST:@"biz/waybillTracking/findTrackingMsg" params:@{@"orderCode":orderCode} success:^(id response) {
        
        //数据转换
        NSDictionary *dictionary = (NSDictionary *)response;
        
        //数据请求值
        BOOL success = [dictionary[@"success"] boolValue];
        
        //判断是否请求成功
        if (success == YES) {
            
            //移除数据
            [weakSelf.array removeAllObjects];
            
            //获取数据
            NSDictionary *data = dictionary[@"data"];
            
            for (NSDictionary *obj in data[@"waybillTrackingList"]) {
                
                [weakSelf.array addObject:obj];
            }
            
            //刷新页面
            [weakSelf.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//创建导航栏
- (void)createNavInNodeInfo{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInNodeInfo)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}
//左侧返回按钮点击事件
- (void)backInNodeInfo{
    
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

//返回cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"NodeInfoTableViewCellID";
    
    NodeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NodeInfoTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    NSDictionary *obj = [self.array objectAtIndex:indexPath.row];
    
    NSString *value = [obj stringWithKey:@"logDate"];
    [cell.time fitHeightWithX:cell.time.x Y:cell.time.y width:cell.time.w font:cell.time.font Text:value];
    //修改高度约束
    cell.timeH.constant = cell.time.h+2;
    
    [cell.statue fitHeightWithX:cell.statue.x Y:cell.statue.y width:cell.statue.w font:cell.statue.font Text:[obj stringWithKey:@"logTitle"]];
    //修改高度约束
    cell.statueH.constant = cell.statue.h;
    
    //节点描述
    cell.info.text = [obj stringWithKey:@"logContext"];

    if (indexPath.row == 0) {
        
        cell.picture.image = kSetImage(@"dianxuan_m@2x");
        cell.statue.textColor = kMainColor;
        cell.time.textColor = kMainColor;
    
    }else{
        cell.picture.image = kSetImage(@"");
        cell.statue.textColor = KTEXT_COLOR;
        cell.time.textColor = kGrayColor;
    }
    
    if (indexPath.row + 1 == self.array.count) {
        
        cell.bottom.hidden = NO;
    }else{
        
        cell.bottom.hidden = YES;
    }
    
    cell.info.textColor = cell.statue.textColor;
    return cell;

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
