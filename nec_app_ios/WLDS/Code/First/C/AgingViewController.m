//
//  AgingViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/1.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "AgingViewController.h"

#import "HaulageOperatorTableViewController.h"

#import "PriceCheckTableViewCell.h"

@interface AgingViewController ()

//投保金额文本输入框
@property (weak, nonatomic) IBOutlet UITextField *insureTF;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;


@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic,strong) ChooseFloor *chooseFloor;

@end

@implementation AgingViewController

/* * * * * * * * * *
 *
 * @ 选择楼层
 *
 * * * * * * * * * */
- (ChooseFloor *)chooseFloor{
    
    if (!_chooseFloor) {
        
        
        WEAKSELF
        _chooseFloor = [[ChooseFloor alloc] initWithCompleteBlock:^(NSDictionary *data) {
            
            //加入数据
            [weakSelf.data setValuesForKeysWithDictionary:data];

        }];
    }
    return _chooseFloor;
}

/* * * * * * * * * *
 *
 * @ 懒加载数据对象
 *
 * * * * * * * * * */
- (NSMutableDictionary *)data{
    
    if (!_data) {

        //获取当前时间
        NSString *makeTime = [NSDate getCurrentTimeWithFormat:@"YYYY-MM-dd"];
        
        _data = [[NSMutableDictionary alloc] initWithDictionary:@{@"deliveryMethod":@"0",@"pickGoodsMethod":@"1",@"declaredValue":@"",@"receiptType":@"0",@"serviceType":@"0",@"isRule":@"0",@"makeTime":makeTime,@"isTaxes":@"1"}];
    }
    return _data;
}

#pragma mark ========   手势点击   ========
/* * * * * * * * * *
 *
 * @ tag == 100，为发货地址管理；tag == 101，为收货地址管理
 * @ tag == 102，为填写发货地址；tag == 103，为填写收货地址
 *
 * * * * * * * * * */
- (IBAction)tapLabelInAging:(UITapGestureRecognizer *)sender {
    
    UILabel *label = (UILabel *)sender.view;
    
    switch (sender.view.tag) {

        case 102:{
            //填写发货地址
            WriteShipAddressViewController *vc = [[WriteShipAddressViewController alloc] init];
            
            //发货地址
            vc.title = @"发货地址";

            WEAKSELF
            vc.writeAddressBlock = ^(NSDictionary *data) {
                
                //地址信息拼接
                label.text = [NSString stringWithFormat:@"%@%@%@%@%@",data[@"Province"],data[@"City"],data[@"Region"],data[@"Street"],data[@"Address"]];
                
                for (NSString *key in data.allKeys) {
                    
                    //获取值
                    NSString *value = data[key];
                    
                    [weakSelf.data setObject:value forKey:[@"delivery" stringByAppendingString:key]];

                }
            };
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 103:{
            //填写收货地址
            WriteShipAddressViewController *vc = [[WriteShipAddressViewController alloc] init];
            
            //发货地址
            vc.title = @"收货地址";
            
            WEAKSELF
            vc.writeAddressBlock = ^(NSDictionary *data) {
                
                
                //地址信息拼接
                label.text = [NSString stringWithFormat:@"%@%@%@%@%@",data[@"Province"],data[@"City"],data[@"Region"],data[@"Street"],data[@"Address"]];
                
                for (NSString *key in data.allKeys) {
                    
                    //获取值
                    NSString *value = data[key];
                    
                    [weakSelf.data setObject:value forKey:[@"receiving" stringByAppendingString:key]];
                }
            };

            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ========   价格时效按钮   ========
- (IBAction)checkPriceAging:(UIButton *)sender {
    
    //获取发站城市ID
    NSString *deliveryRegionId = self.data[@"deliveryRegionId"];
    if (deliveryRegionId.length == 0) {
        [self waringShow:@"请选择发站城市"];
        return;
    }
    //获取到站城市ID
    NSString *receivingRegionId = self.data[@"receivingRegionId"];
    if (receivingRegionId.length == 0) {
        [self waringShow:@"请选择到站城市"];
        return;
    }
    //获取货物名称
    NSString *productName = self.data[@"productName"];
    if (productName.length == 0) {
        [self waringShow:@"请填写货物名称"];
        return;
    }
    //获取货物体积
    NSString *volume = self.data[@"volume"];
    if (volume.doubleValue == 0) {
        [self waringShow:@"请填写货物体积"];
        return;
    }
    //获取货物重量
    NSString *weight = self.data[@"weight"];
    if (weight.doubleValue == 0) {
        [self waringShow:@"请填写货物重量"];
        return;
    }

    //投保金额
    [self.data setObject:self.insureTF.text forKey:@"declaredValue"];
    
    HaulageOperatorTableViewController *vc = [[HaulageOperatorTableViewController alloc] init];
    //数据继承
    [vc.data setValuesForKeysWithDictionary:self.data];
    
    //判断用户是否登录
    if ([HelperSingle shareSingle].isLogin == YES) {
        
       [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        WEAKSELF
        [self toLogin:^(BOOL response) {
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
}

#pragma mark ========   选择按钮操作   ========
/* * * * * * * * * *
 *
 * 标签值  200   201   202   203   204   205   206
 *
 * 位置    投    不投   是     否    送货   自提   等待通知
 *
 * * * * * * * * * */
- (IBAction)choosButtonInAging:(UIButton *)sender {
    
    if (sender.tag != 222 && sender.tag != 224 && sender.tag != 226) {
        
        if (sender.selected == YES) {
            return;
        }else{
            sender.selected = !sender.selected;
        }
    }
    
    //图片设置
    [sender setImage:kSetImage(@"dianxuan_m@2x") forState:(UIControlStateNormal)];
    
    switch (sender.tag) {
        case 200:{
            
            //投保金额选择为“投”
            [self changeButtonStatue:@[@201]];
            self.insureTF.enabled = NO;
            
        }
            break;
        case 201:{
            
            //投保金额选择为“不投”
            [self changeButtonStatue:@[@200]];
            self.insureTF.text = @"";
            self.insureTF.enabled = NO;
        }
            break;
        case 202:{
            
            //提货选择为“是”
            [self changeButtonStatue:@[@203]];
            [self.data setObject:@"1" forKey:@"pickGoodsMethod"];
        }
            break;
        case 203:{
            
            //提货选择为“否”
            [self changeButtonStatue:@[@202]];
            [self.data setObject:@"2" forKey:@"pickGoodsMethod"];
            
        }
            break;
        case 204:{
            
            //送货方式为“送货”
            [self changeButtonStatue:@[@206,@205]];
            [self.data setObject:@"0" forKey:@"deliveryMethod"];
        }
            break;
        case 205:{
            
            //送货方式为“自提”
            [self changeButtonStatue:@[@204,@206]];
            [self.data setObject:@"1" forKey:@"deliveryMethod"];
        }
            break;
        case 206:{
            
            //送货方式为“等待通知送货”
            [self changeButtonStatue:@[@204,@205]];
            [self.data setObject:@"2" forKey:@"deliveryMethod"];
        }
            break;
            // =====  回单类型
        case 214:{
            //厂单
            [self changeButtonStatue:@[@215,@216,@217]];
            [self.data setObject:@"0" forKey:@"receiptType"];
        }
            break;
        case 215:{
            //回执
            [self changeButtonStatue:@[@214,@216,@217]];
            [self.data setObject:@"1" forKey:@"receiptType"];
        }
            break;
        case 216:{
            //面单
            [self changeButtonStatue:@[@215,@214,@217]];
            [self.data setObject:@"2" forKey:@"receiptType"];
        }
            break;
        case 217:{
            //收条
            [self changeButtonStatue:@[@215,@216,@214]];
            [self.data setObject:@"3" forKey:@"receiptType"];
        }
            break;
            // =====  异形件
        case 218:{
            //非异形件
            [self changeButtonStatue:@[@219]];
            [self.data setObject:@"0" forKey:@"isRule"];
        }
            break;
            
        case 219:{
            //异形件
            [self changeButtonStatue:@[@218]];
            [self.data setObject:@"1" forKey:@"isRule"];
        }
            break;
            // ====预约发货时间
        case 220:{
            //今天
            [self changeButtonStatue:@[@221,@222]];
            [self.data setObject:[NSDate getCurrentTimeWithFormat:@"YYYY-MM-dd"] forKey:@"makeTime"];
        }
            break;
        case 221:{
            //明天
            [self changeButtonStatue:@[@220,@222]];
            
            [self.data setObject:[NSDate afterSineNow:1 formatter:@"YYYY-MM-dd"] forKey:@"makeTime"];
        }
            break;
        case 222:{
            //其他时间
            [self changeButtonStatue:@[@221,@220]];
            //时间显示
            XHDateStyle dateStyle = DateStyleShowYearMonthDay;
            //时间样式
            NSString *format = @"yyyy-MM-dd";
            
            WEAKSELF
            XHDatePickerView *pickerView = [[XHDatePickerView alloc] initWithCurrentDate:[NSDate date] CompleteBlock:^(NSDate *startDate, NSDate *endDate) {
                
                if (startDate) {
                    
                    //标题文本
                    UILabel *label = (UILabel *)[weakSelf.footerView viewWithTag:6757893];
                    label.text = [startDate stringWithFormat:format];
                    //时间值更改
                    [self.data setObject:[startDate stringWithFormat:format] forKey:@"makeTime"];
                }
            }];
            
            pickerView.datePickerStyle = dateStyle;
            pickerView.dateType = DateTypeStartDate;
            pickerView.minLimitDate = [NSDate date:@"2017-1-1 00:00" WithFormat:@"yyyy-MM-dd HH:mm"];
            pickerView.maxLimitDate = [NSDate date:@"2100-12-31 23:59" WithFormat:@"yyyy-MM-dd HH:mm"];
            [pickerView show];
            
        }
            break;
            // =====  附加服务
        case 223:{
            //无附加服务
            [self changeButtonStatue:@[@224,@225,@226]];
            [self.data setObject:@"0" forKey:@"serviceType"];
            //删除字段
            [self.data removeObjectsForKeys:@[@"lineUpType",@"lineUpWeightType",@"startUp"]];
        }
            break;
        case 224:{
            //上楼
            [self changeButtonStatue:@[@223,@225,@226]];
            [self.data setObject:@"1" forKey:@"serviceType"];
            [self.chooseFloor show];
        }
            break;
        case 225:{
            //装卸
            [self changeButtonStatue:@[@224,@223,@226]];
            [self.data setObject:@"2" forKey:@"serviceType"];
            
            //删除字段
            [self.data removeObjectsForKeys:@[@"lineUpType",@"lineUpWeightType",@"startUp"]];
        }
            break;
        case 226:{
            //上楼且装卸
            [self changeButtonStatue:@[@224,@225,@223]];
            [self.data setObject:@"3" forKey:@"serviceType"];
            [self.chooseFloor show];
        }
            break;
        case 227:{
            //是否含税金
            [self changeButtonStatue:@[@228]];
            [self.data setObject:@"0" forKey:@"isTaxes"];
        }
            break;
        case 228:{
            //是否含税金
            [self changeButtonStatue:@[@227]];
            [self.data setObject:@"1" forKey:@"isTaxes"];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ========   更改按钮状态   ========
- (void)changeButtonStatue:(NSArray *)array{
    
    for (NSNumber *number in array) {
        
        NSInteger tag = number.integerValue;
        
        //原来按钮
        UIButton *button = (UIButton *)[self.footerView viewWithTag:tag];
        button.selected = NO;
        [button setImage:kSetImage(@"dianxuan_un@2x") forState:(UIControlStateNormal)];
    }
}


#pragma mark ========   视图加载完成   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationController.navigationBar.translucent = NO;

    [self createNavInAging];
    
    //键盘回收
    [self.view recycleKeyBoardWithDelegate:self];
    
    self.tableView.tableHeaderView = self.headerView;
    
    self.tableView.tableFooterView = self.footerView;
    
    if (self.title.length == 0) {
        //设置标题
        [self setFont:kTitFont color:kWhiteColor title:@"价格时效查询"];
    }else{
        //设置标题
        [self setFont:kTitFont color:kWhiteColor title:self.title];
        
        //
        [self.button setTitle:@"下单" forState:(UIControlStateNormal)];
        
        //发货文本信息
        UILabel *label = (UILabel *)[self.view viewWithTag:102];
        
        label.text = [NSString stringWithFormat:@"%@%@%@%@%@",[self.data stringWithKey:@"deliveryProvince"],[self.data stringWithKey:@"deliveryCity"],[self.data stringWithKey:@"deliveryRegion"],[self.data stringWithKey:@"deliveryStreet"],[self.data stringWithKey:@"deliveryAddress"]];
        
        //收货文本信息
        UILabel *label1 = (UILabel *)[self.view viewWithTag:103];
        label1.text = [NSString stringWithFormat:@"%@%@%@%@%@",[self.data stringWithKey:@"receivingProvince"],[self.data stringWithKey:@"receivingCity"],[self.data stringWithKey:@"receivingRegion"],[self.data stringWithKey:@"receivingStreet"],[self.data stringWithKey:@"receivingAddress"]];
        
    }
    
    //注册观察键盘的变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//移动UIView
-(void)transformView:(NSNotification *)aNSNotification{
    //获取键盘弹出后的Rect
    NSValue *keyBoardEndBounds = [[aNSNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  endRect=[keyBoardEndBounds CGRectValue];
    
    //获取当前第一响应者
    UIView *view = (UIView *)[UIResponder currentFirstResponder];
    
    //获取当前响应者在窗口中的frame
    CGRect frame = [view locationInWindow];
    //比较frame差值是否被遮挡
    CGFloat value = (frame.origin.y + frame.size.height - endRect.origin.y);
    
    if (value > 0) {
        
        //在0.15s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动value的动画
        [UIView animateWithDuration:0.15f animations:^{
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - value, self.view.frame.size.width, self.view.frame.size.height)];
        }];
        
    }else{
        
        //返回原位置
        [self.view setFrame:CGRectMake(self.view.frame.origin.x,NAV_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    }
}

//创建导航栏
- (void)createNavInAging{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInAging)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}
//左侧返回按钮点击事件
- (void)backInAging{
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark ========   UITableViewDataSource/UITableViewDelegate   ========
//分区数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
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

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kFitW(40 * 6);
}

//返回cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    
    PriceCheckTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[PriceCheckTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
    
    WEAKSELF
    //位置信息
    cell.inputValueBlock = ^(NSString *text, NSInteger location) {
        
        switch (location) {
            case 0:{
                
                [weakSelf.data setObject:text forKey:@"productName"];
            }
                break;
            case 1:{
                //重量
                [weakSelf.data setObject:text forKey:@"weight"];
            }
                break;
            case 2:{
                //体积
                [weakSelf.data setObject:text forKey:@"volume"];
            }
                break;
            case 3:{
                //数量
                [weakSelf.data setObject:text forKey:@"goodsNum"];
            }
                break;
            case 4:{
                //货物货款
                [weakSelf.data setObject:text forKey:@"collectionMoney"];
            }
                break;
            case 5:{
                //回单
                [weakSelf.data setObject:text forKey:@"theReceipt"];
            }
                break;
                
            default:
                break;
        }
    };
        
    return cell;
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

#pragma mark ========   UIScrollViewDelegate   ========
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    kKeyBoardHiden;
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
