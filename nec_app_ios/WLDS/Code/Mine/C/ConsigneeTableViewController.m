//
//  ConsigneeTableViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/9.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "ConsigneeTableViewController.h"

#import "ConsigneeCell.h"

@interface ConsigneeTableViewController ()


@property (nonatomic,strong) NSMutableArray *array;


//页数
@property (nonatomic) NSInteger page;

//分页总数
@property (nonatomic) NSInteger totle;


@end

@implementation ConsigneeTableViewController

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
    
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:self.title];
    [self createNavInConsignee];
    
    
    self.page = 1;
    
    //创建加载和刷新
    [self.tableView createHeaderAction:@selector(refreshDataInConsignee) footerAction:@selector(loadDataDataInConsignee) target:self];
    
    //获取数据
    [self gainDataInConsignee];
    
    //右侧按钮
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtoonInConsignee)];
    [rightBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kTitFont,NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBar;
    rightBar.tintColor = kWhiteColor;
}

#pragma mark ========   刷新页面   ========
- (void)refreshDataInConsignee{
    
    self.page = 1;
    
    //获取数据
    [self gainDataInConsignee];
    
}

#pragma mark ========   加载页面   ========
- (void)loadDataDataInConsignee{
    
    //页数判断
    if (self.page < self.totle) {
        
        //获取当前展示视图
        self.tableView.footerRefreshingText = @"加载数据";
        
        self.page = self.page + 1;
        
        [self gainDataInConsignee];
        
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

//右侧按钮
- (void)rightBarButtoonInConsignee{
    
    WriteShipAddressViewController *vc = [[WriteShipAddressViewController alloc] init];
    
    if ([self.title isContainString:@"收货人"]) {
        vc.title = @"新增收货人";
    }else{
        vc.title = @"新增发货人";
    }
    
    WEAKSELF
    vc.writeInfoBlock = ^(NSDictionary *data) {

        //获取数据
        [weakSelf gainDataInConsignee];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

//获取数据
- (void)gainDataInConsignee{
    
    NSString *type = @"1";
    
    if ([self.title isContainString:@"收货人"]) {
        type = @"2";
    }
    
    WEAKSELF
    [NetRequestManger POST:@"base/orderSf/find" params:@{@"page":[NSString stringWithFormat:@"%ld",weakSelf.page],@"limit":@"10",@"type":type} success:^(id response) {
        
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
                [weakSelf.array addObject:[NSMutableDictionary nullDic:obj]];
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
- (void)createNavInConsignee{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInConsignee)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}
//左侧返回按钮点击事件
- (void)backInConsignee{
    
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

//cell高度
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return kFitW(150);
//}

//返回cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"ConsigneeCellID";
    
    ConsigneeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
       cell = [[[NSBundle mainBundle] loadNibNamed:@"ConsigneeCell" owner:self options:nil] objectAtIndex:0];
    }

    
    CGFloat height = [@"地址" gainHeightWithFont:cell.before.font width:cell.before.w];
    
    //修改高度约束
    cell.beforeH.constant = height+5;
    
    NSDictionary *obj = [self.array objectAtIndex:indexPath.row];
    
    cell.name.text = obj[@"name"];
    cell.phone.text = obj[@"phone"];
    cell.address.text = obj[@"address"];

    return cell;
}
//预估高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.chooseConsigneeBlock) {
                
        NSDictionary *dict = [self.array objectAtIndex:indexPath.row];
        self.chooseConsigneeBlock(dict);
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        WriteShipAddressViewController *vc = [[WriteShipAddressViewController alloc] init];
        
        NSDictionary *obj = [self.array objectAtIndex:indexPath.row];
        //继承数据
        [vc.info setValuesForKeysWithDictionary:obj];
        if ([self.title isContainString:@"发货人"]) {
            vc.title = @"修改发货人";
        }else{
            
            vc.title = @"修改收货人";
        }
        
        WEAKSELF
        vc.updateBlock = ^(BOOL success) {
            //刷新数据
            [weakSelf gainDataInConsignee];
        };
        
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //获取数据对象
    NSDictionary *dict = [self.array objectAtIndex:indexPath.row];
    
    WEAKSELF
    
    [NetRequestManger POST:@"base/orderSf/delete" params:@{@"id":dict[@"id"]} success:^(id response) {
        
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
            
            // 从数据源中删除
            [weakSelf.array removeObjectAtIndex:indexPath.row];
            // 从列表中删除
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dictionary[@"msg"]];
            
        }else{
            [SVProgressHUD showImage:kSetImage(@"fail@2x") status:dictionary[@"msg"]];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
