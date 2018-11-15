//
//  HaulageOperatorTableViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/8.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "HaulageOperatorTableViewController.h"

#import "HaulageOperatorCell.h"

#import "CarrierProductViewController.h"

@interface HaulageOperatorTableViewController ()



@end

@implementation HaulageOperatorTableViewController

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


#pragma mark ========   视图加载   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"承运公司"];

    //创建导航栏
    [self createNavInHaulageOperator];
    
    //查询运力回传
    if (self.array.count == 0) {
        //获取数据
        [self gainDataInHaulageOperator];
    }
    
}

//获取数据
- (void)gainDataInHaulageOperator{
    
    WEAKSELF
    [NetRequestManger POST:@"base/line/findLineSysOrg" params:self.data success:^(id response) {
        
        //数据转换
        NSDictionary *dictionary = (NSDictionary *)response;
        
        //数据请求值
        BOOL success = [dictionary[@"success"] boolValue];
        
        //判断是否请求成功
        if (success == YES) {
            
            //获取数据
            NSArray *data = dictionary[@"data"];
            
            //是否存在数据
            if (data.count > 0) {
                
                //删除数据
                [weakSelf.array removeAllObjects];
                
                for (NSDictionary *obj in data) {
                    
                    //添加数据
                    [weakSelf.array addObject:obj];
                }
                //刷新数据
                [weakSelf.tableView reloadData];
            }else{
                
                [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
                //展示风火轮时，禁止其他操作
                [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
                [SVProgressHUD setBackgroundColor:kLikeColor];
                [SVProgressHUD setForegroundColor:KTEXT_COLOR];
                [SVProgressHUD dismissWithDelay:1.0];
                
                [SVProgressHUD showImage:kSetImage(@"fail@2x") status:@"该线路暂未查询到更多承运公司"];
            }
            
        }else{
            
            [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
            //展示风火轮时，禁止其他操作
            [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
            [SVProgressHUD setBackgroundColor:kLikeColor];
            [SVProgressHUD setForegroundColor:KTEXT_COLOR];
            [SVProgressHUD dismissWithDelay:1.0];
            
            [SVProgressHUD showImage:kSetImage(@"fail@2x") status:dictionary[@"msg"]];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
//创建导航栏
- (void)createNavInHaulageOperator{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInHaulageOperator)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
}

- (void)backInHaulageOperator{
    
    [self.navigationController popViewControllerAnimated:YES];
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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    view.backgroundColor = kLikeColor;
    return view;
}
//表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
    
    return 50;
}

//返回cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"HaulageOperatorCellID";
    
    HaulageOperatorCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HaulageOperatorCell" owner:self options:nil] objectAtIndex:0];
    }
    
    NSDictionary *obj = [self.array objectAtIndex:indexPath.section];
    
    cell.title.text = obj[@"orgName"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取数据
    NSDictionary *obj = [self.array objectAtIndex:indexPath.section];
    if (self.chooseOrgBlock) {
        
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//        [dict setObject:[obj stringWithKey:@"orgId"] forKey:@"capacityId"];
//        [dict setObject:[obj stringWithKey:@"orgName"] forKey:@"orgName"];
        self.chooseOrgBlock(obj);
        [self.navigationController popViewControllerAnimated:YES];
    
    }else{
        
        CarrierProductViewController *vc = [[CarrierProductViewController alloc] init];
        
        //继承数据
        [vc.data setValuesForKeysWithDictionary:self.data];

        [vc.data setObject:[obj stringWithKey:@"orgId"] forKey:@"capacityId"];
        [vc.data setObject:[obj stringWithKey:@"orgName"] forKey:@"orgName"];
        [vc.data setObject:[obj stringWithKey:@"lineId"] forKey:@"lineId"];
        
        //    [vc.data setObject:obj[@"orgId"] forKey:@"capacityId"];
        //    [vc.data setObject:obj[@"orgName"] forKey:@"orgName"];
        //    [vc.data setObject:obj[@"lineId"] forKey:@"lineId"];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
