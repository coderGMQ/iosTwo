//
//  MyDispatchViewController.m
//  WLDS
//
//  Created by han chen on 2018/3/11.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "MyDispatchViewController.h"
#import "MessageDetailsController.h"
#import "HttpDataRequest.h"
#import "MyDispatchCell.h"
#import "PagesView.h"
#import "MJRefresh.h"
#import "MenuSelect.h"


@interface MyDispatchViewController (){
    int pageNum;

    //接收类型
    NSString *isAcceptStr;
}
@property (weak, nonatomic) IBOutlet UITableView *myDispatchTable;
@property (weak, nonatomic) IBOutlet UIButton *selectDispatchsBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dipatchControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlLayoutHeight;

@property (weak, nonatomic) IBOutlet UILabel *lineLab;

@property (nonatomic,retain) NSMutableArray *myDispatchAry;

@property (nonatomic,strong) MenuSelect *menu;


//筛选运单号
@property (nonatomic,strong) NSString *orderCode;
//筛选开始时间
@property (nonatomic,strong) NSString *startTime;
//筛选结束时间
@property (nonatomic,strong) NSString *endTime;


@end

@implementation MyDispatchViewController
/* * * * * * * * * *
 *
 * @懒加载表视图
 *
 * * * * * * * * * */
-(MenuSelect *)menu{

    if (!_menu) {

        _menu = [[MenuSelect alloc] initWithFrame:self.view.bounds items:@[@{@"name":@"全部",@"type":@""},@{@"name":@"已拒绝",@"type":@"0"},@{@"name":@"已接收",@"type":@"1"},@{@"name":@"已撤回",@"type":@"3"},@{@"name":@"已确认",@"type":@"4"},@{@"name":@"有异常",@"type":@"5"}]];
    }

    return _menu;
}

- (NSMutableArray *)myDispatchAry{

    if (!_myDispatchAry) {

        _myDispatchAry = [[NSMutableArray alloc] init];
    }
    return _myDispatchAry;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.orderCode = @"";
    self.startTime = @"";
    self.endTime = @"";
    
    isAcceptStr = @"";

    [self createNavInMyDispatch];

    [self initUI];

    [self refreshTable];
    // Do any additional setup after loading the view from its nib.
    
}

#pragma mark ========   筛选按钮   ========
- (void)rightBarButtoonInMyDispatch{
    
    CodeFiltrateViewController *vc = [[CodeFiltrateViewController alloc] init];
    //状态数据
    //    [vc.statueArray addObjectsFromArray:@[@"全部",@"提货费"]];
    vc.name = @"运单";
    WEAKSELF
    vc.codeFiltrateStatueData = ^(NSString *number, NSString *start, NSString *end, NSString *statue) {
        
        //筛选开始时间
        weakSelf.orderCode = number;
        weakSelf.startTime = [start stringByAppendingString:@" 00:00:00"];
        weakSelf.endTime = [end stringByAppendingString:@" 23:59:59"];
        
        pageNum = 1;
        
        [weakSelf.myDispatchAry removeAllObjects];
        
        [weakSelf.myDispatchTable reloadData];
        
        [weakSelf networkRequest];
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

    //创建导航栏
- (void)createNavInMyDispatch{

        //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInMyDispatch)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
    //右侧按钮
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtoonInMyDispatch)];
    [rightBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kTitFont,NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBar;
    rightBar.tintColor = kWhiteColor;
}

    //左侧返回按钮点击事件
- (void)backInMyDispatch{

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initUI{
    if (self.myDispatchMark == 2) {
        self.dipatchControl.hidden = YES;
        self.lineLab.hidden = YES;
        self.controlLayoutHeight.constant = 0;
    }
    else{
        [self.dipatchControl changeSelectedColor:kMainColor unSelectedColor:kHexColor(0x333333) titleFont:11];
    }

    self.selectDispatchsBtn.layer.cornerRadius = 5;

    self.selectDispatchsBtn.layer.masksToBounds=YES;

    self.selectDispatchsBtn.layer.borderColor=[kHexColor(0x999999) CGColor];

    self.selectDispatchsBtn.layer.borderWidth= 1;
}

-(IBAction)changeControl:(UISegmentedControl *)sender{

    WEAKSELF

    [UIView animateWithDuration:0.3 animations:^{
            //修改中心点
        weakSelf.lineLab.center = CGPointMake(kWidth / sender.numberOfSegments / 2 + sender.selectedSegmentIndex * (kWidth / sender.numberOfSegments), weakSelf.lineLab.center.y);
    }];

    if (![isAcceptStr isEqualToString:@""]) {
        if ([self.menu.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [self.menu.tableView.delegate tableView:self.menu.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
    }
    else{
        [self.myDispatchTable headerBeginRefreshing];
    }
}


- (IBAction)chooseStatue:(UIButton *)sender{

        //展示视图
    [self.menu showTableViewByView:sender offset:0 again:NO];

    WEAKSELF;
    self.menu.chooseMenuSelect = ^(NSInteger index, NSDictionary *message) {
        isAcceptStr = message[@"type"];

        [sender setTitle:[NSString stringWithFormat:@"    %@",message[@"name"]] forState:UIControlStateNormal];
        
        [weakSelf.myDispatchTable headerBeginRefreshing];
    };
}


#pragma mark-- 刷新
- (void)refreshTable
{
    [self.myDispatchTable addHeaderWithCallback:^{

        pageNum = 1;

        [self.myDispatchAry removeAllObjects];

        [self.myDispatchTable reloadData];

         [self networkRequest];
    }];

    [self.myDispatchTable addFooterWithCallback:^{

        pageNum++;

        [self networkRequest];
    }];

    [self.myDispatchTable headerBeginRefreshing];
}

#pragma mark 网络数据请求
- (void)networkRequest{

    NSDictionary *n_pTempDic;
    if ([self.title isEqualToString:@"已完成订单"]){
        n_pTempDic = @{@"page":[NSString stringWithFormat:@"%d",pageNum],@"start":[NSString stringWithFormat:@"%ld",self.myDispatchAry.count],@"limit":@"10",@"orderCode":self.orderCode,@"startTime":self.startTime,@"endTime":self.endTime};
    }
    else{

        n_pTempDic = @{@"isAccept":isAcceptStr,@"page":[NSString stringWithFormat:@"%d",pageNum],@"start":[NSString stringWithFormat:@"%ld",self.myDispatchAry.count],@"limit":@"10",@"payStatus":[NSString stringWithFormat:@"%ld",(long)self.dipatchControl.selectedSegmentIndex + 1],@"orderCode":self.orderCode,@"startTime":self.startTime,@"endTime":self.endTime};
    }

    [HttpDataRequest askListByPage:n_pTempDic pageTitle:self.title
                       requestData:^(BOOL isSuccess, NSDictionary *dic) {
                           if (isSuccess) {
                               NSArray *dataAry = dic[@"data"][@"items"];

                               if (dataAry.count > 0) {
                                   
                                   for (NSDictionary *obj in dataAry) {
                                       
                                       OrderModel *model = [OrderModel shareOrderModelWithDictionary:[NSMutableDictionary nullDic:obj]];
                                       
                                       [self.myDispatchAry addObject:model];
                                   }
                                   
//                                   [self.myDispatchAry addObjectsFromArray:dataAry];
                               }
                               else{
                                   ;
                               }
                           }
                        

                           [self.myDispatchTable reloadData];

                           [self.myDispatchTable headerEndRefreshing];

                           [self.myDispatchTable footerEndRefreshing];

//                           [SVProgressHUD dismiss];
                       }];
}


#pragma mark ========   UITableViewDataSource/UITableViewDelegate   ========
//分区数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
}

//单个分区cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.myDispatchAry.count;
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
    
    
    OrderModel *model = [self.myDispatchAry objectAtIndex:indexPath.row];;
    
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
    OrderModel *model = [self.myDispatchAry objectAtIndex:indexPath.row];

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

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return self.myDispatchAry.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 45;
//}
//
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    NSDictionary *n_pTempDic;
//
//    if (self.myDispatchAry.count > section) {
//        n_pTempDic = self.myDispatchAry[section];
//    }
//
//    UIView *n_pBackGrounView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 65)];
//    n_pBackGrounView.backgroundColor = [UIColor clearColor];
//
//    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 45)];
//    titleLab.backgroundColor = [UIColor whiteColor];
//    titleLab.textColor = kHexColor(0x999999);
//    titleLab.font = [UIFont systemFontOfSize:13];
//    titleLab.text = [NSString stringWithFormat:@"    订单号：%@",n_pTempDic[@"orderCode"]];
//
//    [n_pBackGrounView addSubview:titleLab];
//
//        //时间
//    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(kWidth - 210, 0, 200, 45)];
//    timeLab.backgroundColor = [UIColor clearColor];
//    timeLab.textColor = kHexColor(0x999999);
//    timeLab.font = [UIFont systemFontOfSize:13];
//
//    timeLab.textAlignment = NSTextAlignmentRight;
//
////    if ((self.dipatchControl.selectedSegmentIndex == 0) && (self.myDispatchMark != 2)) {
////        timeLab.text = n_pTempDic[@"createTime"];
////    }
////    else{
//        timeLab.text = [NSString stringWithFormat:@"运单号：%@",n_pTempDic[@"waybillCode"]];
////    }
//
//    [n_pBackGrounView addSubview:timeLab];
//
//    return n_pBackGrounView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
////    if ((self.dipatchControl.selectedSegmentIndex == 0) && (self.myDispatchMark != 2)) {
////        return 20;
////    }
////    else
//        return 65.0f;
//}
//
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
////    if ((self.dipatchControl.selectedSegmentIndex == 0) && (self.myDispatchMark != 2)) {
////            return nil;
////    }
////    else{
//        NSDictionary *n_pTempDic;
//
//        if (self.myDispatchAry.count > section) {
//            n_pTempDic = self.myDispatchAry[section];
//        }
//
//        UIView *n_pBackGrounView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 65)];
//        n_pBackGrounView.backgroundColor = [UIColor clearColor];
//
//        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 45)];
//        titleLab.backgroundColor = [UIColor whiteColor];
//        titleLab.textColor = kHexColor(0x999999);
//        titleLab.font = [UIFont systemFontOfSize:13];
//        titleLab.text = [NSString stringWithFormat:@"    下单时间：%@",n_pTempDic[@"createTime"]];
//
//        [n_pBackGrounView addSubview:titleLab];
//
//            //时间
//        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(kWidth - 70, 10, 60, 25)];
//
//        timeLab.font = [UIFont systemFontOfSize:12];
//
//        timeLab.textAlignment = NSTextAlignmentCenter;
//
//        timeLab.text = n_pTempDic[@"isAccept"];
//
//        timeLab.layer.cornerRadius = 5;
//
//        timeLab.layer.masksToBounds=YES;
//
//        timeLab.layer.borderWidth= 1;
//
//        [UITools changeBackground:timeLab];
//        
//        [n_pBackGrounView addSubview:timeLab];
//
//        return n_pBackGrounView;
////    }
//}
//
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    MyDispatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegisterCell"];
//
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyDispatchCell" owner:self options:nil] objectAtIndex:0];
//    }
//
//    if (indexPath.section < self.myDispatchAry.count) {
//        NSDictionary *n_pTempDic = self.myDispatchAry[indexPath.section];
//
//        NSString *volume = @"";
//
//        NSString *volumeStr = [NSString stringWithFormat:@"%@",n_pTempDic[@"volume"]];
//
//        if (!STRING_ISNIL(volumeStr)) {
//            volume = [NSString stringWithFormat:@"%@m³",volumeStr];
//        }
//
//        cell.goodsMsgLab.text = [NSString stringWithFormat:@"名称：%@；件数：%@件；重量：%@g；体积：%@",n_pTempDic[@"productName"],n_pTempDic[@"goodsNum"],n_pTempDic[@"weight"],volume];
//
//        NSString *phoneNum = @"";
//
//        NSString *tel = [NSString stringWithFormat:@"%@",n_pTempDic[@"receivingPhon"]];
//
//        if (!STRING_ISNIL(tel)) {
//            phoneNum = tel;
//        }
//        cell.addressMsgLab.text = [NSString stringWithFormat:@"收件人：%@；收件人电话：%@\n收件地址：%@",n_pTempDic[@"receivingName"],phoneNum,n_pTempDic[@"receivingAddress"]];
//
////        if ((self.dipatchControl.selectedSegmentIndex == 0) && (self.myDispatchMark != 2)) {
////            cell.myDispatchState.hidden = NO;
////
////                //订单状态
////            cell.myDispatchState.text = n_pTempDic[@"isAccept"];
////
////            [self changeBackground:cell.myDispatchState];
////        }
////        else{
////            cell.myDispatchState.hidden = YES;
////        }
//    }
//
//        // Configure the cell...
//
//    return cell;
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    MessageDetailsController *vc = [[MessageDetailsController alloc] init];
//    vc.title = @"订单详情";
//    NSDictionary *n_pTempDic = self.myDispatchAry[indexPath.section];
//    vc.orderCode = n_pTempDic[@"orderCode"];
//    //回调请求数据
//    vc.backMessageBlock = ^(BOOL success) {
//        
//    };
//    [self.navigationController pushViewController:vc animated:YES];
//
//}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
