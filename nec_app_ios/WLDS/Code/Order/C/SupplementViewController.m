//
//  SupplementViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/16.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "SupplementViewController.h"

#import "SureOrderViewController.h"

@interface SupplementViewController ()

//货物描述信息
@property (weak, nonatomic) IBOutlet UITextView *msg;

//输入文本备注信息
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SupplementViewController

/* * * * * * * * * *
 *
 * @
 *
 * * * * * * * * * */
- (NSMutableDictionary *)data{
    
    if (!_data) {
        _data = [[NSMutableDictionary alloc] init];
        [_data setObject:@"1" forKey:@"payMethod"];
    }
    return _data;
}

#pragma mark ========   更改按钮状态   ========
- (void)changeButtonStatueInSupplement:(NSArray *)array{
    
    for (NSNumber *number in array) {
        
        NSInteger tag = number.integerValue;
        
        //原来按钮
        UIButton *button = (UIButton *)[self.view viewWithTag:tag];
        button.selected = NO;
        [button setImage:kSetImage(@"dianxuan_un@2x") forState:(UIControlStateNormal)];
    }
}
#pragma mark ========   按钮点击   ========
- (IBAction)buttonClickInSupplement:(UIButton *)sender {
    
    if (sender.selected == YES) {
        return;
    }else{
        sender.selected = !sender.selected;
    }
    
    //图片设置
    [sender setImage:kSetImage(@"dianxuan_m@2x") forState:(UIControlStateNormal)];
    
    switch (sender.tag) {
            //付款方式
        case 207:{
            //改变图片
            [self changeButtonStatueInSupplement:@[@208,@209,@210,@211,@212,@213]];
            [self.data setObject:@"1" forKey:@"payMethod"];
        }
            break;
        case 208:{
            //改变图片
            [self changeButtonStatueInSupplement:@[@207,@209,@210,@211,@212,@213]];
            [self.data setObject:@"2" forKey:@"payMethod"];
        }
            break;
        case 209:{
            //改变图片
            [self changeButtonStatueInSupplement:@[@207,@208,@210,@211,@212,@213]];
            [self.data setObject:@"3" forKey:@"payMethod"];
        }
            break;
        case 210:{
            //改变图片
            [self changeButtonStatueInSupplement:@[@207,@208,@209,@211,@212,@213]];
            [self.data setObject:@"4" forKey:@"payMethod"];
        }
            break;
        case 211:{
            //改变图片
            [self changeButtonStatueInSupplement:@[@207,@208,@209,@210,@212,@213]];
            [self.data setObject:@"5" forKey:@"payMethod"];
        }
            break;
        case 212:{
            //改变图片
            [self changeButtonStatueInSupplement:@[@207,@208,@209,@210,@211,@213]];
            [self.data setObject:@"6" forKey:@"payMethod"];
        }
            break;
        case 213:{
            //改变图片
            [self changeButtonStatueInSupplement:@[@207,@208,@209,@210,@211,@212]];
            [self.data setObject:@"7" forKey:@"payMethod"];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ========   确认信息   ========
- (IBAction)submitButton:(UIButton *)sender {
    
    UITextField *tf1 = (UITextField *)[self.view viewWithTag:100];
    if (tf1.text.length == 0) {
        [self waringShow:@"请填写发货人姓名"];
        return;
    }
    //存储发货人姓名
    [self.data setObject:tf1.text forKey:@"deliveryName"];
    
    UITextField *tf2 = (UITextField *)[self.view viewWithTag:101];
    if (tf2.text.length == 0) {
        [self waringShow:@"请填写发货人手机号"];
        return;
    }
    //存储发货人手机号
    [self.data setObject:tf2.text forKey:@"deliveryPhone"];
    
    UITextField *tf3 = (UITextField *)[self.view viewWithTag:200];
    if (tf3.text.length == 0) {
        [self waringShow:@"请填写收货人姓名"];
        return;
    }
    //存储收货人姓名
    [self.data setObject:tf3.text forKey:@"receivingName"];
    
    UITextField *tf4 = (UITextField *)[self.view viewWithTag:201];
    if (tf4.text.length == 0) {
        [self waringShow:@"请填写发货人手机号"];
        return;
    }
    
    //委托单号
    UITextField *tf5 = (UITextField *)[self.view viewWithTag:300];
    [self.data setObject:tf5.text forKey:@"entrustCode"];
    
    //存储收货人手机号
    [self.data setObject:tf4.text forKey:@"receivingPhone"];
    
    //输入货物描述信息
    [self.data setObject:self.msg.text forKey:@"goodsMsg"];
    
    //输入备注信息
    [self.data setObject:self.textView.text forKey:@"remark"];
    
    SureOrderViewController *vc = [[SureOrderViewController alloc] init];
    //继承数据
    [vc.data setValuesForKeysWithDictionary:self.data];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark ========   视图加载   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"收发人信息"];
    
    [self.view recycleKeyBoardWithDelegate:nil];
        
    [self createNavInSupplement];
    
    self.tableView.tableHeaderView = self.headerView;
    //用户信息展示
    [self userTypeInSupplement];
}


#pragma mark ========   区分用户 - 隐藏按钮   ========
- (void)userTypeInSupplement{
    
    if ([HelperSingle shareSingle].isLogin == YES) {
        
        NSDictionary *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"lgdata"];
        NSString *userType = [data stringWithKey:@"userType"];
        
        if ([userType isEqualToString:@"4"]) {
            //个人用户：支付方式现付和到付展示，其他隐藏
            for (int i = 0; i < 5; i++) {
                
                UIButton *button = (UIButton *)[self.view viewWithTag:209 + i];
                button.hidden = YES;
                
                //文本
                UILabel *label = (UILabel *)[self.view viewWithTag:button.tag + 100];
                label.hidden = button.hidden;
            }
            
        }else{
            //非个人用户：全部展示
            for (int i = 0; i < 5; i++) {
                UIButton *button = (UIButton *)[self.view viewWithTag:209 + i];
                button.hidden = NO;
                //文本
                UILabel *label = (UILabel *)[self.view viewWithTag:button.tag + 100];
                label.hidden = button.hidden;
            }
        }
        
    }else{
        
        //非个人用户：全部展示
        for (int i = 0; i < 5; i++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:209 + i];
            button.hidden = NO;
            //文本
            UILabel *label = (UILabel *)[self.view viewWithTag:button.tag + 100];
            label.hidden = button.hidden;
        }
    }
}

//创建导航栏
- (void)createNavInSupplement{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInSupplement)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}

//左侧返回按钮点击事件
- (void)backInSupplement{
    
    [self.navigationController popViewControllerAnimated:YES];
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
