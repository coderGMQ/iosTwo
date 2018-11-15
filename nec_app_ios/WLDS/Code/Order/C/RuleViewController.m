//
//  RuleViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/4/17.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "RuleViewController.h"

#import "RuleCell.h"

@interface RuleViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"下单协议内容"];
    
    [self createNavInRule];
}

//创建导航栏
- (void)createNavInRule{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInRule)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}

//左侧返回按钮点击事件
- (void)backInRule{
    
    [self.navigationController popViewControllerAnimated:YES];
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
    
    static NSString *ID = @"RuleCell";
    
    RuleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RuleCell" owner:self options:nil] objectAtIndex:0];
        
    }
    
    [cell.title fitHeightWithX:cell.title.x Y:cell.title.y width:cell.title.w font:cell.title.font Text:@"     欢迎您使用笨鸟智运网络服务平台，为维护您的自身权益请仔细阅读本条款，如您点击“同意并继续”按钮后，本条款即对您具有法律约束力。如您不同意本条款或对本条款有任何异议，您应当立即停止下单发货或承接货物。\n\n     一、本网络服务平台的运输单以电子版本订立，自发货人下单发货，承运人接单后生效，对发货人及承运人双方均具有约束力。本网络服务平台并非运输单中任何相对一方；\n\n     二、发货人与承运人均应当遵守运输单中的约定及本条款的规定；\n\n     三、发货人应当根据运输单约定的价格及付款时间及时支付运费；\n\n     四、发货人保证如实填写发运货物的品名、吨位、体积等基本事项，保证其不在国家法律、法规所规定的禁运之列，否则发生不良后果将由发货人负责；\n\n     五、发货人应将发运的货物自行妥善包装好，且包装必须符合物品安全运输的要求，对特殊性质的物品（如易燃易爆、易挥发、有毒物品、重要物品，易碎品、易损坏的物品等），发货人应做好特殊包装处理，同时须在该运单的备注栏中给予特别注明。否则发生一切不良后果将由发货人负责。\n\n     六、发货人或其指定的收货人应当于收到通知之日起三日内提取货物，否则由此产生的相关费用由发货人自行承担。\n\n     七、承运人应当具有法律、法规规定的运输资质。如国家法律、法规对运输特殊货物有特殊规定的，承运人应当符合相应特殊规定，否则发生一切不良后果将由承运人负责。\n\n     八、承运人须按照发货人的要求对承运货物清点无误后，在确保承运货物安全的前提下按时运至指定的地点交货。\n\n     九、承运人必须做好货物的防雨、防潮措施，并根据货物实际情况做好其它防护措施。\n\n     十、承运人在运输过程中导致货物污染、受潮、包装损坏、货物短少、货物非自然损伤以及货物灭失的，由承运人承担责任，并赔偿损失。但遇自然灾害等不可抗力除外。\n\n     十一、承运人在承运过程中，出现交通事故或者其他工伤等事故，由此引起的损失及相应的赔偿责任，均由承运人承担。\n\n     十二、运输途中受阻，承运人务必通过电话、网络等方式通发货人、收货人。\n\n     十三、承运人应当依法开具运输发票交付发货人。\n\n\n\n     十四、发货人、承运人双方任何一方违反或拒不履行运输单约定的事项或本运输条款的规定，即构成违约，均应依法承担相应的法律责任。\n\n     十五、因运输过程中有关的任何争议，发货人与承运人双方应友好协商解决；也可交由本网络平台协调解决，协商或协调不成的，任何一方均可向有管辖权的人民法院提起诉讼。\n\n     十六、如果本承运条款中的任何条款无效，其余条款仍应有效并且有约束力。\n\n     十七、发货人与承运人可另行订立承运协议，如果另行订立的承运协议与本承运条款不一致的，以另行订立的承运协议为准。\n\n     十八、本网络平台有权随时根据有关法律、法规的变化以及运输市场的调整等原因修改本条款，而无需另行单独通知用户，但本网络平台将在条款修改前通过本网络平台向用户公示，用户可随时通过网站浏览最新条款。当发生有关争议时，以最新的条款文本为准。如果不同意本网络平台对本条款所做的修改，用户有权停止使用本网络服务。如果用户继续使用本网络服务，则视为用户接受本网络平台对相关条款所做的修改。"];
    
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
