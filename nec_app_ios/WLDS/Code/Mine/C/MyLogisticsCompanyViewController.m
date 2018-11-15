//
//  MyLogisticsCompanyViewController.m
//  WLDS
//
//  Created by han chen on 2018/3/22.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "MyLogisticsCompanyViewController.h"
#import "MyLogisticsCompanyCell.h"
#import "CellHeaderView.h"
#import "HttpDataRequest.h"
#import "BindingViewController.h"


@interface MyLogisticsCompanyViewController ()<MyLogisticsComDelegate>
{
    int pageNum;
}

@property (nonatomic,retain) NSMutableArray *myLogisticsAry;

@end

@implementation MyLogisticsCompanyViewController
- (NSMutableArray *)myLogisticsAry{
    if (!_myLogisticsAry) {
        _myLogisticsAry = [[NSMutableArray alloc] init];
    }

    return _myLogisticsAry;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNavInMyLogisticsCompany];

//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1)];

    self.tableView.rowHeight = 60;

    [self refreshTable];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

    //创建导航栏
- (void)createNavInMyLogisticsCompany{

        //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInMyLogisticsCompany)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    //右侧按钮
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"绑定" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtoonInMyLogisticsCompany)];
    [rightBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kTitFont,NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBar;
    rightBar.tintColor = kWhiteColor;
    
}

- (void)rightBarButtoonInMyLogisticsCompany{

    BindingViewController *vc = [[BindingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

    //左侧返回按钮点击事件
- (void)backInMyLogisticsCompany{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-- 刷新
- (void)refreshTable
{
    WEAKSELF
    [self.tableView addHeaderWithCallback:^{

        pageNum = 1;

        [weakSelf.myLogisticsAry removeAllObjects];

        [weakSelf.tableView reloadData];

        [weakSelf networkRequest];
    }];

    [self.tableView addFooterWithCallback:^{

        pageNum++;

        [weakSelf networkRequest];
    }];

    [self.tableView headerBeginRefreshing];
}

#pragma mark 解绑
- (void)unbundlingBtn:(UIButton *)sender{

    [self unbundlingRequest:self.myLogisticsAry[sender.tag][@"relationId"] deleteIndex:sender.tag];
}


#pragma mark 获取我的物流公司
- (void)networkRequest{
        //开loading
        //    WEAKSELF
    [HttpDataRequest askListByPage: @{@"page":[NSString stringWithFormat:@"%d",pageNum],@"start":[NSString stringWithFormat:@"%ld",self.myLogisticsAry.count],@"limit":@"10",@"status":@"3"} pageTitle:self.title
                       requestData:^(BOOL isSuccess, NSDictionary *dic) {
                           if (isSuccess) {
                               NSArray *dataAry = dic[@"data"][@"items"];

                               if (dataAry.count > 0) {
                                   [self.myLogisticsAry addObjectsFromArray:dataAry];
                               }
                               else{
                                   ;
                               }
                           }
                           

                           [self.tableView reloadData];

                           [self.tableView headerEndRefreshing];

                           [self.tableView footerEndRefreshing];

                               // [self hideHud];
                       }];
}


#pragma mark 解绑操作
- (void)unbundlingRequest:(NSString *)relationId deleteIndex:(NSInteger)index{

    [NetRequestManger cancelRequst];
        //开loading
        //    [self showHudInView:(UIView*)[UIApplication sharedApplication].delegate.window hint:@"加载中."];

        //    WEAKSELF
    [HttpDataRequest askListByPage: @{@"relationId":relationId} pageTitle:@"解绑"
                       requestData:^(BOOL isSuccess, NSDictionary *dic) {
                           if (isSuccess) {

                               [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
                                   //展示风火轮时，禁止其他操作
                               [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
                               [SVProgressHUD setBackgroundColor:kLikeColor];
                               [SVProgressHUD setForegroundColor:KTEXT_COLOR];
                               [SVProgressHUD dismissWithDelay:1.0];

                               [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dic[@"msg"]];

                               if ([dic[@"success"] boolValue]) {
                                   [self.myLogisticsAry removeObjectAtIndex:index];

                                   [self.tableView reloadData];
                               }
                           }
                           
                            // [self hideHud];
                       }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.myLogisticsAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 90;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

//    UIView *cellHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 120)];

//    cellHeaderView.backgroundColor = [UIColor redColor];
//    CellHeaderView *cellHeaderView = [[CellHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 120)];

     CellHeaderView *cellHeaderView = [CellHeaderView initStanceView];
//
//    CGRect headerFrame = cellHeaderView.frame;
//
//    headerFrame.size.width = kWidth;
//
//    [cellHeaderView setFrame:headerFrame];
    
//    CellHeaderView *cellHeaderView = [[CellHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 120)];

//    cellHeaderView.frame = CGRectMake(0, 0, kWidth, 10);

    return cellHeaderView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MyLogisticsCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyLogisticsCompanyCell"];

    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyLogisticsCompanyCell" owner:self options:nil] objectAtIndex:0];
    }

    cell.myLogisticsdelegate = self;

    if (indexPath.row < self.myLogisticsAry.count) {
        NSDictionary *n_pTempDic = self.myLogisticsAry[indexPath.row];

        cell.name.text = n_pTempDic[@"orgName"];
    }

    cell.Unbundlingbtn.tag = indexPath.row;


//    cell.textLabel.textColor = kGrayColor;

        // Configure the cell...

    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
