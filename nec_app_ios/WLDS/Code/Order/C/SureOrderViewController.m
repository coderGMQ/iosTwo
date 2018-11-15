//
//  SureOrderViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/15.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "SureOrderViewController.h"
#import "MessageDetailsTableViewCell.h"

#import "ChoosePayViewController.h"
//创建运单
#import "CreateOrderViewController.h"
//时效查询
#import "AgingViewController.h"

#import "RuleViewController.h"

#import "DiscountsTableViewController.h"

@interface SureOrderViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//优惠信息
@property (weak, nonatomic) IBOutlet UILabel *couponLB;

//底部视图
@property (strong, nonatomic) IBOutlet UIView *footerView;


@property (weak, nonatomic) IBOutlet UILabel *castLB;

//是否接收统一
@property (nonatomic) BOOL isAccept;

@end

@implementation SureOrderViewController

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

#pragma mark ========   协议内容   ========
- (IBAction)theOrderRule:(UITapGestureRecognizer *)sender {
    
    RuleViewController *vc = [[RuleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ========   接收协议   ========
- (IBAction)acceptTheRule:(UIButton *)sender {
    
    self.isAccept = sender.selected = !sender.selected;
    
    if (sender.selected == YES) {
                
        [sender setImage:kSetImage(@"dianxuan_m@2x") forState:(UIControlStateNormal)];
        
    }else{
        
        [sender setImage:kSetImage(@"dianxuan_un@2x") forState:(UIControlStateNormal)];
    }
}

#pragma mark ========   选择优惠   ========
- (IBAction)chooseDiscounts:(UITapGestureRecognizer *)sender {
    
    DiscountsTableViewController *vc = [[DiscountsTableViewController alloc] init];
    
    WEAKSELF

    vc.chooseDataBlock = ^(NSDictionary *obj) {
  
        //赋值操作
        weakSelf.couponLB.text = [obj stringWithKey:@"specialOfferName"];
        
        NSString *Id = [obj stringWithKey:@"specialOfferId"];
        //请求参数
        [weakSelf.data setObject:Id forKey:@"specialOfferId"];
        
        //计算优惠费用
        [NetRequestManger POST:@"base/orderSpecialOffer/countPrice" params:@{@"specialOfferId":Id,@"cast":[weakSelf.data stringWithKey:@"cast"]} success:^(id response) {
            
            //数据转换
            NSDictionary *dictionary = (NSDictionary *)response;
            
            //数据请求值
            BOOL success = [dictionary[@"success"] boolValue];
            
            //判断是否请求成功
            if (success == YES) {
                
                //划线文本
                weakSelf.castLB.attributedText = [NSString changeLineColor:kRedColor string:@"需支付 " change:[NSString stringWithFormat:@" ￥%.2f ",[weakSelf.data[@"cast"] doubleValue]] last:[NSString stringWithFormat:@" %.2f",[dictionary[@"data"] doubleValue]]];
            }

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark ========   按钮点击实现   ========
- (IBAction)clickButtonInSureOrder:(UIButton *)sender {
    
    if (sender.tag == 100) {
      //撤销订单
        [self backSVPInSureOrder];
        
    }else if (sender.tag == 101){
        
        if (self.isAccept == NO) {
            
            [self waringShow:@"请阅读并同意用户下单协议"];
            return;
        }
        
        [NetRequestManger POST:@"lxzy/order/addOrder" params:self.data success:^(id response) {
            
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
                
                [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dictionary[@"msg"]];
                
                //发送创单成功通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"createSuccess" object:nil];
                //观察状态
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backSVPInSureOrder) name:@"SVProgressHUDDidDisappearNotification" object:nil];
                
            }else{
                
                [SVProgressHUD showImage:kSetImage(@"fail@2x") status:dictionary[@"msg"]];
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];

    }
}

#pragma mark ========   下单成功   ========
- (void)backSVPInSureOrder{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        
        //判断是否
        if ([temp isKindOfClass:[CreateOrderViewController class]] || [temp isKindOfClass:[AgingViewController class]]) {
            
            [self.navigationController popToViewController:temp animated:YES];
            
            break;
        }
    } 
}

#pragma mark ========   视图加载   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"确认订单"];
    
    [self createNavInSureOrder];
    
    //底部视图
    self.tableView.tableFooterView = self.footerView;
    //总费用
    NSString *cast = [self.data stringWithKey:@"cast"];
    self.castLB.text = [NSString stringWithFormat:@"需支付￥%.2f",cast.doubleValue];
    
    
    
}

//创建导航栏
- (void)createNavInSureOrder{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInSureOrder)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}

//左侧返回按钮点击事件
- (void)backInSureOrder{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ========   UITableViewDataSource/UITableViewDelegate   ========
//分区数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 5)];
    view.backgroundColor = kLikeColor;
    return view;
}
//表尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //    @ 一高度:178 四：197 二、三、五：动态高度
    
    if (indexPath.section == 0) {
        
        return 212;
        
    }else if (indexPath.section == 1) {
        
        return 178;
        
    }else{
        
        return UITableViewAutomaticDimension;
    }
}

//预估高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//返回cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageDetailsTableViewCell *cell = [MessageDetailsTableViewCell messageDetailsTableViewCellWith:tableView indexPath:indexPath data:self.data];
    
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
