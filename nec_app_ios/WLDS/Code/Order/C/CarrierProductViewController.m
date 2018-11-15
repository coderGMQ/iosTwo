//
//  CarrierProductViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/8.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "CarrierProductViewController.h"

#import "CarrierProductTableViewCell.h"

#import "SureOrderViewController.h"

#import "SupplementViewController.h"

@interface CarrierProductViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *orgName;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *array;


@end

@implementation CarrierProductViewController

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

#pragma mark ========  视图加载  ========
- (void)viewDidLoad {
    [super viewDidLoad];

    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"承运产品"];
    [self createNavInCarrierProduct];

    //数据参数转换
    [self.data setObject:[self.data stringWithKey:@"deliveryCityId"] forKey:@"fscode"];
    [self.data setObject:[self.data stringWithKey:@"deliveryRegionId"] forKey:@"fxcode"];
    [self.data setObject:[self.data stringWithKey:@"deliveryStreetId"] forKey:@"fjcode"];
    
    [self.data setObject:[self.data stringWithKey:@"receivingCityId"] forKey:@"dscode"];
    [self.data setObject:[self.data stringWithKey:@"receivingRegionId"] forKey:@"dxcode"];
    [self.data setObject:[self.data stringWithKey:@"receivingStreetId"] forKey:@"djcode"];
    
    //获取数据
    [self gainDataInCarrierProduct];
    
    //运力公司名称
    NSString *orgName = self.data[@"orgName"];
    
    if (orgName.length > 0) {
        
        self.orgName.text = orgName;
    }
 
}

//获取数据
- (void)gainDataInCarrierProduct{
    
    WEAKSELF
    [NetRequestManger POST:@"lxzy/order/getLineOrgList" params:self.data success:^(id response) {
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
- (void)createNavInCarrierProduct{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInCarrierProduct)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
}

- (void)backInCarrierProduct{
    
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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1)];
    view.backgroundColor = kLikeColor;
    return view;
}
//表尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 54;
}

//返回cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"CarrierProductTableViewCellID";
    
    CarrierProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CarrierProductTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    //获取数据对象
    NSDictionary *obj = [self.array objectAtIndex:indexPath.row];
    
    cell.number.text = kDictString(obj, @"lineOrgId");
    cell.fee.text = kDictString(obj, @"transFee");
    cell.insurance.text = kDictString(obj, @"insurance");
//    cell.aging.text = kDictString(obj, @"workTime");
    cell.aging.text = [obj stringWithKey:@"workTime"];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    
//    JQWarningView *view = [[JQWarningView alloc] init];
//    view.title = @"是否选择此产品下单？";
//
//    WEAKSELF
//    //获取数据对象
//    NSDictionary *obj = [self.array objectAtIndex:indexPath.row];
//
//    view.buttonBlock = ^(NSString *title) {
//
//        if ([title isEqualToString:@"确定"]) {
//
//            if ([HelperSingle shareSingle].isLogin == NO) {
//
//                //跳转至登录页面
//                [weakSelf toLogin:^(BOOL response) {
//                    //跳转至下一个页面
//                    [weakSelf nextPageWithId:obj];
//                }];
//
//            }else{
//
//                //跳转至下一个页面
//                [weakSelf nextPageWithId:obj];
//            }
//        }
//    };

}

//跳转至下一个页面
- (void)nextPageWithId:(NSDictionary *)obj{
    
    NSString *deliveryName = [self.data stringWithKey:@"deliveryName"];
    
    NSString *receivingName = [self.data stringWithKey:@"receivingName"];
    
    //无收发货人信息时间
    if (deliveryName.length == 0 || receivingName.length == 0) {
        
        SupplementViewController *vc = [[SupplementViewController alloc] init];
        //继承数据
        [vc.data setValuesForKeysWithDictionary:self.data];
        //添加新数据
        [vc.data setValue:obj[@"lineOrgId"] forKey:@"productId"];
        [vc.data setValue:obj[@"priceId"] forKey:@"priceId"];
        [vc.data setValue:obj[@"cast"] forKey:@"cast"];
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    SureOrderViewController *vc = [[SureOrderViewController alloc] init];
    //继承数据
    [vc.data setValuesForKeysWithDictionary:self.data];
    //添加新数据
    [vc.data setValue:obj[@"lineOrgId"] forKey:@"productId"];
    [vc.data setValue:obj[@"priceId"] forKey:@"priceId"];
    [vc.data setValue:obj[@"cast"] forKey:@"cast"];
    
    [self.navigationController pushViewController:vc animated:YES];
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
