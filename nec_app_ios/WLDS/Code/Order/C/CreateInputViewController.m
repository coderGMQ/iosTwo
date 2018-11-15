//  CreateInputViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/17.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "CreateInputViewController.h"

#import "InfoCell.h"

#import "InfoChooseCell.h"

#import "InfoOptionsCell.h"

@interface CreateInputViewController ()<UITableViewDelegate,UITableViewDataSource,InputViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//预置集合
@property (nonatomic,strong) NSMutableArray *array;

//底部视图
@property (nonatomic,strong) UIView *footerView;

@property (nonatomic,strong) InputView *putView;

@end

@implementation CreateInputViewController

/* * * * * * * * * *
 *
 * @ 懒加载数据对象
 *
 * * * * * * * * * */
- (NSMutableDictionary *)request{
    
    if (!_request) {
        _request = [[NSMutableDictionary alloc] init];
    }
    return _request;
}

/* * * * * * * * * *
 *
 * @ 懒加载底部视图
 *
 * * * * * * * * * */
- (UIView *)footerView{
    
    if (!_footerView) {
        _footerView = [[UIView alloc] init];

        //记录坐标位置
        CGFloat y = 0;
        
        //获取备注信息
        NSString *msg = [self.request stringWithKey:@"remark"];
        
        if (self.type == 3) {
            
            _footerView.frame = CGRectMake(0, 0, kWidth, kFitW(180));
            
        }else if (self.type == 4){
            
            _footerView.frame = CGRectMake(0, 0, kWidth, kFitW(260));
            
            //宽度
            CGFloat width = (kWidth - 25 * 2 - 20 * 2) / 3;
            
            NSArray *array = @[@"防潮",@"勿倒置",@"勿重压",@"小心装卸",@"轻拿轻放"];
            //循环创建
            for (int i = 0; i < array.count; i++) {
                
                int low = i / 3;
                
                int row = i % 3;
                
                //按钮创建
                UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
                button.titleLabel.font = kFontSize(16);
                [_footerView addSubview:button];
                //设置标签
                button.tag = 100 + i;
                button.frame = CGRectMake(25 + row * (width + 20) , 15 + low * 55 ,width,40);
                
                //图片
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(button.w - 10, -5,15, 15)];
                [button addSubview:iv];
                iv.tag = 200 + i;
                iv.backgroundColor = kWhiteColor;
                iv.image = kSetImage(@"gouxuan@2x");
                iv.hidden = YES;
                [iv cropLayer:3];
                [iv borderCutWithColor:kLikeColor width:1];
                [button setTitleColor:KTEXT_COLOR forState:(UIControlStateNormal)];
                button.backgroundColor = kLikeColor;
                
                //获取标题
                NSString *title = [array objectAtIndex:i];
                
                if ([msg isContainString:title]) {
                    
                    //设置颜色
                    [button setTitleColor:kMainColor forState:(UIControlStateNormal)];
                    
                    //删除标题
                    msg = [msg deleteSpecial:[title stringByAppendingString:@"、"]];
                    //删除标题
                    msg = [msg deleteSpecial:[title stringByAppendingString:@";"]];
                    //删除标题
                    msg = [msg deleteSpecial:[NSString stringWithFormat:@"、%@",title]];
                    iv.hidden = NO;
                    button.selected = YES;
                }
                
                [button setTitle:title forState:(UIControlStateNormal)];
                
                //添加监听事件
                [button addTarget:self action:@selector(clickButtonInPut:) forControlEvents:(UIControlEventTouchUpInside)];
                
                //判断位置
                if (i == array.count - 1) {
                    
                    //记录位置
                    y = button.v;
                }
            }
        }
        
        //输入框
        _putView = [[InputView alloc] initWithFrame:CGRectMake(0,y, kWidth, kFitW(150))];
        //预置500字
        _putView.count = 500;
        if (self.type == 3) {
            _putView.title = @"货物详情内容:";
            _putView.text = @"请输入您其他的货物详情内容，500字以内";
            _putView.preinstall = [self.request stringWithKey:@"goodsMsg"];
        }else if (self.type == 4){
            _putView.title = @"备注内容:";
            _putView.text = @"请输入您要备注的信息，500字以内";
            _putView.preinstall = msg;
        }

        _putView.delegate = self;
        [_footerView addSubview:_putView];
    }
    return _footerView;
}

#pragma mark ========   按钮点击事件   ========
- (void)clickButtonInPut:(UIButton *)button{
    
    //状态取反
    button.selected = !button.selected;
    
    //图片展示或者隐藏
    UIImageView *iv = (UIImageView *)[button viewWithTag:button.tag + 100];
    if (button.selected == YES) {
        
        iv.hidden = NO;
        [button setTitleColor:kMainColor forState:(UIControlStateNormal)];
        
    }else{
        iv.hidden = YES;
        [button setTitleColor:KTEXT_COLOR forState:(UIControlStateNormal)];
    }
    
}

/* * * * * * * * * *
 *
 * @ 懒加载预置参数对象
 *
 * * * * * * * * * */
- (NSMutableArray *)array{
    
    if (!_array){
        _array = [[NSMutableArray alloc] init];

        if (0 == self.type) {
            
            //货物信息
            for (int i = 0; i < 4; i++) {
                
                RequestModel *model = [[RequestModel alloc] init];
                
                //设置0为输入型cell
                model.type = 0;
                
                switch (i) {
                    case 0:{
                        //必须验证字段
                        model.must = YES;
                        model.title = @"货物名称";
                        model.field = @"productName";
                        model.keyboardType = 0;
                    }
                        break;
                    case 1:{
                        model.title = @"货物件数";
                        model.field = @"goodsNum";
                        model.keyboardType = 4;
                    }
                        break;
                    case 2:{
                        //必须验证字段
                        model.title = @"货物体积";
                        model.field = @"volume";
                        model.placeholder = @"请输入货物体积（m³）";
                        model.keyboardType = 8;
                    }
                        break;
                    case 3:{
                        //必须验证字段
                        model.must = YES;
                        model.title = @"货物重量";
                        model.field = @"weight";
                        model.placeholder = @"请输入货物重量（吨）";
                        model.keyboardType = 8;
                    }
                        break;
                        
                    default:
                        break;
                }
                
                //赋值操作
                model.data = model.data = [self.request stringWithKey:model.field];
                
                //添加数据
                [_array addObject:model];
            }
            
        }else if (1 == self.type){
            
            //服务信息
            for (int i = 0; i < 7; i++) {
                
                RequestModel *model = [[RequestModel alloc] init];
                
                switch (i) {
                    case 0:{
                        //必须验证字段
                        model.must = YES;
                        model.type = 2;
                        model.title = @"是否提货";
                        model.field = @"pickGoodsMethod";
                        model.data = [self.request stringWithKey:model.field];
                        if ([model.data isEqualToString:@"1"]) {
                            model.text = @"是";
                        }else if ([model.data isEqualToString:@"0"]) {
                            model.text = @"否";
                        }
                    }
                        break;
                    case 1:{
                        //必须验证字段
                        model.must = YES;
                        model.type = 2;
                        model.title = @"是否送货";
                        model.field = @"deliveryMethod";
                        model.data = [self.request stringWithKey:model.field];
                        if ([model.data isEqualToString:@"0"]) {
                            model.text = @"是";
                        }else if ([model.data isEqualToString:@"1"]) {
                            model.text = @"否";
                        }

                    }
                        break;
                    case 2:{
                        //必须验证字段
                        model.type = 1;
                        model.title = @"回单类型";
                        model.field = @"receiptType";
                        
                        model.data = [self.request stringWithKey:model.field];
                        if ([model.data isEqualToString:@"0"]) {
                            model.text = @"厂单";
                        }else if ([model.data isEqualToString:@"1"]) {
                            model.text = @"回执";
                        }else if ([model.data isEqualToString:@"2"]) {
                            model.text = @"面单";
                        }else if ([model.data isEqualToString:@"3"]) {
                            model.text = @"收条";
                        }
                    }
                        break;
                    case 3:{
                        //必须验证字段
                        model.type = 0;
                        model.title = @"回单份数";
                        model.field = @"theReceipt";
                        model.data = model.text = [self.request stringWithKey:model.field];
                        model.keyboardType = 4;
                    }
                        break;
                    case 4:{
                        //必须验证字段
                        model.must = YES;
                        model.type = 1;
                        model.title = @"付款方式";
                        model.field = @"payMethod";
                        model.data = [self.request stringWithKey:model.field];
                       
                        if ([model.data isEqualToString:@"1"]) {
                            model.text = @"现付";
                        }else if ([model.data isEqualToString:@"2"]) {
                            model.text = @"到付";
                        }else if ([model.data isEqualToString:@"3"]) {
                            model.text = @"回付";
                        }else if ([model.data isEqualToString:@"5"]) {
                            model.text = @"30天付";
                        }else if ([model.data isEqualToString:@"6"]) {
                            model.text = @"60天付";
                        }else if ([model.data isEqualToString:@"7"]) {
                            model.text = @"90天付";
                        }
                    }
                        break;
                    case 5:{
                        //必须验证字段
                        model.must = YES;
                        model.type = 0;
                        model.title = @"委托单号";
                        model.field = @"entrustCode";
                        model.data = model.text = [self.request stringWithKey:model.field];
                        model.keyboardType = 0;
                    }
                        break;
                    case 6:{
                        
                        model.type = 0;
                        model.ban = YES;
                        model.title = @"预约发货时间";
                        model.field = @"makeTime";
                        model.data = model.text = [self.request stringWithKey:model.field];
                        model.keyboardType = 0;
                    }
                        break;
                        
                    default:
                        break;
                }
                
                //添加数据
                [_array addObject:model];
            }
        }else if (2 == self.type){
            
            //附加服务
            for (int i = 0; i < 7; i++) {
                
                RequestModel *model = [[RequestModel alloc] init];
                
                model.type = 2;
                
                switch (i) {
                    case 0:{
                        //必须验证字段
                        model.must = YES;
                        model.title = @"代收货款";
                        model.type = 0;
                        model.field = @"collectionMoney";
                        model.data = model.text = [self.request stringWithKey:model.field];
                        model.keyboardType = 8;
                    }
                        break;
                    case 1:{
                        //必须验证字段
                        model.title = @"是否投保";
                        model.field = @"";
                        model.text = @"否";
                        [_array addObject:model];
                        //获取数据
                        NSString *value = [self.request stringWithKey:@"declaredValue"];
                        
                        if (value.doubleValue > 0) {
                            
                            model.text = @"是";
                            //新建model
                            RequestModel *ot = [[RequestModel alloc] init];
                            
                            //必须验证字段
                            ot.type = 0;
                            ot.title = @"投保金额";
                            ot.field = @"declaredValue";
                            ot.data = ot.text = value;
                            ot.keyboardType = 8;
                            
                            [_array addObject:ot];
                        }
                    }
                        break;
                    case 2:{
                        //必须验证字段
                        model.title = @"是否含税";
                        model.field = @"isTaxes";
                        //是否含税金
                        model.data = [self.request stringWithKey:model.field];
                        
                        if ([model.data isEqualToString:@"0"]){
                            model.text = @"否";
                        }else if ([model.data isEqualToString:@"1"]){
                            model.text = @"是";
                        }

                    }
                        break;
                    case 3:{
                        //必须验证字段
                        model.title = @"是否异形件";
                        model.field = @"isRule";
                        model.data = [self.request stringWithKey:model.field];
                        if ([model.data isEqualToString:@"0"]) {
                            model.text = @"否";
                        }else if ([model.data isEqualToString:@"1"]) {
                            model.text = @"是";
                        }

                    }
                        break;
                    case 4:{
                        //必须验证字段
                        model.title = @"搬货上楼";
                        model.field = @"serviceTypeSl";
                        model.data = [self.request stringWithKey:model.field];
                        [_array addObject:model];
                        if ([model.data isEqualToString:@"0"]) {
                            model.text = @"否";
                            
                        }else if ([model.data isEqualToString:@"1"]) {
                            
                            model.text = @"是";
                            
                            //获取数据
                            NSString *value = [self.request stringWithKey:@"lineUpWeightType"];
                            
                            //新建model
                            RequestModel *lineUpWeightType = [[RequestModel alloc] init];
                            
                            //必须验证字段
                            lineUpWeightType.type = 2;
                            lineUpWeightType.title = @"大小件";
                            lineUpWeightType.field = @"lineUpWeightType";
                            lineUpWeightType.data = value;
                            [_array addObject:lineUpWeightType];
                            
                            //获取数据
                            value = [self.request stringWithKey:@"lineUpType"];
                            
                            //新建model
                            RequestModel *lineUpType = [[RequestModel alloc] init];
                            //必须验证字段
                            lineUpType.type = 2;
                            lineUpType.title = @"电梯";
                            lineUpType.field = @"lineUpType";
                            lineUpType.data = value;
                            
                            [_array addObject:lineUpType];
                            
                            if ([value isEqualToString:@"1"]) {
                                
                                lineUpType.text = @"是";                                
                            }else{
                                lineUpType.text = @"否";
                                //新建model
                                RequestModel *ot2 = [[RequestModel alloc] init];
                                //必须验证字段
                                ot2.type = 2;
                                ot2.title = @"楼层";
                                ot2.field = @"startUp";
                                ot2.data = [self.request stringWithKey:@"startUp"];
                                [_array addObject:ot2];
                                //1表示5-8层，0表示1-4层
                            }
                        }
                    }
                        break;
                    case 5:{
                        //必须验证字段
                        model.title = @"带人装货";
                        model.field = @"serviceTypeZh";
                        model.data = [self.request stringWithKey:model.field];
                        if ([model.data isEqualToString:@"0"]) {
                            model.text = @"否";
                        }else if ([model.data isEqualToString:@"1"]) {
                            model.text = @"是";
                        }
                        
                    }
                        break;
                    case 6:{
                        //必须验证字段
                        model.title = @"带人卸货";
                        model.field = @"serviceTypeXh";
                        model.data = [self.request stringWithKey:model.field];
                        if ([model.data isEqualToString:@"0"]) {
                            model.text = @"否";
                        }else if ([model.data isEqualToString:@"1"]) {
                            model.text = @"是";
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
                
                //非特殊情况
                if (i != 4 && i != 1) {
                    //添加数据
                    [_array addObject:model];
                }
               
            }
        }
        
    }
    return _array;
}


#pragma mark ========   视图加载完成   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:self.title];
    [self createNavInCreateInput];
    
    if (self.type == 3 || self.type == 4) {

        //设置底部视图
        self.tableView.tableFooterView = self.footerView;
    }
    
    //键盘回收
    [self.view recycleKeyBoardWithDelegate:self];
}

//创建导航栏
- (void)createNavInCreateInput{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInCreateInput)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}

//左侧返回按钮点击事件
- (void)backInCreateInput{
    
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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 60)];
    view.backgroundColor = kWhiteColor;
    
    //图片
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, (view.h - 25)/2, 25, 25)];
    iv.image = kSetImage(@"fuwuxiangmu");
    [view addSubview:iv];
    
    //文本信息
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iv.l + 10, 0, view.w - (iv.l + 10 * 2),view.h)];
    label.textColor = KTEXT_COLOR;
    label.font = kFontSize(17);
    label.text = self.title;
    [view addSubview:label];
    
    //底部细线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,view.v - 1.0, kWidth, 1.0)];
    [view addSubview:line];
    line.backgroundColor = kLikeColor;
    return view;

}
//表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
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
    
    //获取model
    RequestModel *model = [self.array objectAtIndex:indexPath.row];
    
    NSInteger index = model.type;
    
    if (index == 0) {
        
        static NSString *identifier = @"InfoCellID";
        
        InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"InfoCell" owner:self options:nil] objectAtIndex:0];
        }
        
        cell.title.text = model.title;
        cell.tf.keyboardType = model.keyboardType;
        cell.tf.enabled = !model.ban;
        cell.tf.text = model.data;
        
        //判断是否存在占位文本
        if (model.placeholder.length > 0) {
            cell.tf.placeholder = model.placeholder;
        }else{
            cell.tf.placeholder = [NSString stringWithFormat:@"请输入%@",model.title];
        }
        
        //输入完成后的数据
        cell.endPutBlock = ^(NSString *value) {
            
            //数据文本记录
            model.data = model.text = value;
        };
        
        return cell;
        
    }else if (index == 1){
        
        static NSString *identifier = @"InfoChooseCellID";
        
        InfoChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"InfoChooseCell" owner:self options:nil] objectAtIndex:0];
        }
        //标题数据
        cell.title.text = model.title;
        //变化的子标题数据
        cell.sub.text = model.text;
        
        return cell;
        
    }else{
        
        static NSString *identifier = @"InfoOptionsCellID";
        
        InfoOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"InfoOptionsCell" owner:self options:nil] objectAtIndex:0];
        }
        
        //标题数据
        cell.title.text = model.title;
        
        
        //位置
        NSArray *array = @[@"是",@"否"];
        
        if ([model.title isEqualToString:@"大小件"]) {
            
            array = @[@"0-30kg",@"200k以上"];
            
            NSInteger loction = 0;
            
            if ([model.data isEqualToString:@"1"]) {
                loction = 1;
            }

            //位置信息
            [cell witdth:100 titles:array index:loction];
        }else if ([model.title isEqualToString:@"楼层"]) {
            array = @[@"1-4层",@"5-8层"];
            NSInteger loction = 0;
            if ([model.data isEqualToString:@"1"]) {
                loction = 1;
            }
            //位置信息
            [cell witdth:100 titles:array index:loction];
        }else{
            
            [cell witdth:70 titles:array index:3];
            [cell chooseWithTitle:model.text];
        }
        
        
        WEAKSELF
        //回传
        cell.chooseBlock = ^(NSInteger index) {
            
            //选中后的赋值
            if (index == 1) {
                
                model.text = [array firstObject];
                
                if ([model.title isEqualToString:@"楼层"] || [model.title isEqualToString:@"大小件"] || [model.title isEqualToString:@"是否送货"]) {
                    model.data = @"0";
                }else{

                    model.data = @"1";
                }

            }else{
                model.text = [array lastObject];;
                
                if ([model.title isEqualToString:@"楼层"] || [model.title isEqualToString:@"大小件"] || [model.title isEqualToString:@"是否送货"]) {
                    model.data = @"1";
                }else{
                    model.data = @"0";
                }
            }

            //判断是否税金
            if ([model.title isEqualToString:@"是否投保"]) {
                
                //删除或者增加
                [weakSelf addOrDelete:index title:@"投保金额" index:indexPath.row];
                
            }else if ([model.title isEqualToString:@"搬货上楼"]) {
                
                //增加
                [weakSelf addOrDelete:1 title:@"楼层" index:indexPath.row];
                
                //删除或者增加
                [weakSelf addOrDelete:index title:@"电梯" index:indexPath.row];
                
                //删除或者增加
                [weakSelf addOrDelete:index title:@"大小件" index:indexPath.row];
                
            }else if ([model.title isEqualToString:@"电梯"]) {
                
                if (index == 1) {
                    //删除
                    [weakSelf addOrDelete:0 title:@"楼层" index:indexPath.row];

                }else{
                    //增加
                    [weakSelf addOrDelete:1 title:@"楼层" index:indexPath.row];
                }
                
            }
        };
        
        return cell;
        
    }
}

//删除或者新增
- (void)addOrDelete:(NSInteger)add title:(NSString *)title index:(NSInteger)index{
    
    if (1 == add) {
        
        //遍历数组集合
        for (int i = 0; i < self.array.count; i++) {
            //新建model
            RequestModel *ot = [self.array objectAtIndex:i];
            
            if ([ot.title isEqualToString:title]) {
                
                //不需要再添加
                add = 0;

                break;
            }
        }
        
        if (add == 1) {
            
            //新建model
            RequestModel *ot = [[RequestModel alloc] init];
            
            //必须验证字段
            
            if ([title isEqualToString:@"大小件"] || [title isEqualToString:@"电梯"]  || [title isEqualToString:@"楼层"]) {
                //cell样式
                ot.type = 2;
//                ot.data = @"1";
                if ([title isEqualToString:@"楼层"]) {
                    ot.field = @"startUp";
                    ot.data = @"1";
                }else if ([title isEqualToString:@"电梯"]){
                    ot.field = @"lineUpType";
                    ot.data = @"0";
                }else if ([title isEqualToString:@"大小件"]){
                    ot.field = @"lineUpWeightType";
                    ot.data = @"1";
                }
                
            }else if ([title isEqualToString:@"投保金额"]){
                ot.type = 0;
                ot.field = @"declaredValue";
                ot.data = ot.text = @"";
            }
            
            ot.title = title;
            
            ot.keyboardType = 8;
            
            //插入数据
            [self.array insertObject:ot atIndex:index+1];
        }
        
    }else{
        
        //遍历数组集合
        for (int i = 0; i < self.array.count; i++) {
            
            //新建model
            RequestModel *ot = [self.array objectAtIndex:i];
            
            //删除指定目标对象
            if ([ot.title isEqualToString:title]) {

                //删除数据
                [self.array removeObject:ot];
            }
        }
        
        //判断删除的是否为电梯选项
        if ([title isEqualToString:@"电梯"]) {
            
            //遍历数组集合
            for (int i = 0; i < self.array.count; i++) {
                
                //新建model
                RequestModel *ot = [self.array objectAtIndex:i];
                
                //处理特殊楼层问题
                if ([ot.title isEqualToString:@"楼层"]) {
                    
                    //删除数据
                    [self.array removeObject:ot];
                }
            }
        }
    }
    
    //刷新页面
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    kKeyBoardHiden;
    
    //获取model
    RequestModel *model = [self.array objectAtIndex:indexPath.row];
    
    NSInteger index = model.type;
    
    //多选样式
    if (index == 1) {
        
        //获取cell
        InfoChooseCell *cell =  (InfoChooseCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if ([model.title isEqualToString:@"回单类型"]) {
            
            [cell showWithItems:@[@"厂单",@"回执",@"面单",@"收条"]];
            
            cell.chooseValueBlock = ^(NSInteger index, NSString *title) {
                
                //展示文本
                model.text = title;
                
                if ([title isEqualToString:@"厂单"]) {
                    //提交数据
                    model.data = @"0";
                    
                }else if ([title isEqualToString:@"回执"]){
                    //提交数据
                    model.data = @"1";

                }else if ([title isEqualToString:@"面单"]){
                    //提交数据
                    model.data = @"2";
                }else if ([title isEqualToString:@"收条"]){
                    //提交数据
                    model.data = @"3";
                }
            };
            
        }else if ([model.title isEqualToString:@"付款方式"]) {

            //获取数据
            NSArray *array = @[@"现付",@"到付",@"回付",@"30天付",@"60天付",@"90天付"];
            
            if ([HelperSingle shareSingle].isLogin == YES) {
                
                //获取用户角色信息
                NSDictionary *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"lgdata"];
                NSString *userType = [data stringWithKey:@"userType"];
                
                if ([userType isEqualToString:@"4"]) {
                    //个人用户：支付方式现付和到付展示，非个人用户：全部展示
                    array = @[@"现付",@"到付"];
                }
            }
            //展示
            [cell showWithItems:array];
            cell.chooseValueBlock = ^(NSInteger index, NSString *title) {
                
                //展示文本
                model.text = title;
                
                if ([title isEqualToString:@"现付"]) {
                    //提交数据
                    model.data = @"1";
                }else if ([title isEqualToString:@"到付"]){
                    //提交数据
                    model.data = @"2";
                }else if ([title isEqualToString:@"回付"]){
                    //提交数据
                    model.data = @"3";
                }else if ([title isEqualToString:@"30天付"]){
                    //提交数据
                    model.data = @"5";
                }else if ([title isEqualToString:@"60天付"]){
                    //提交数据
                    model.data = @"6";
                }else if ([title isEqualToString:@"90天付"]){
                    //提交数据
                    model.data = @"7";
                }
            };
        }
        
    }else if (0 == index){
        
        //判断是否为禁止输入
        if (model.ban == YES) {
            
            if ([model.title isEqualToString:@"预约发货时间"]) {
                
                //时间显示
                XHDateStyle dateStyle = DateStyleShowYearMonthDay;
                //时间样式
                NSString *format = @"yyyy-MM-dd";
                
                //获取时间
                NSDate *date = [NSDate date];
                
                //判断是否存在文本信息
                if (model.text.length > 0) {
                    
                    date = [NSDate gainDateWithString:model.text];
                }
                
                XHDatePickerView *pickerView = [[XHDatePickerView alloc] initWithCurrentDate:date CompleteBlock:^(NSDate *startDate, NSDate *endDate) {
                    
                    if (startDate) {
                        
                        //获取数据
                        model.data = model.text = [startDate stringWithFormat:format];
                        //刷新页面
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
                    }
                }];
                
                pickerView.datePickerStyle = dateStyle;
                pickerView.dateType = DateTypeStartDate;
                pickerView.minLimitDate = [NSDate date:@"2018-1-1" WithFormat:@"yyyy-MM-dd"];
                pickerView.maxLimitDate = [NSDate date:@"2100-12-31" WithFormat:@"yyyy-MM-dd"];
                [pickerView show];
            }
            
        }
    }
    
}

//保存信息
- (IBAction)saveInfo:(UIButton *)sender {
    
    //构造回传数据
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];

    //判断是否为输入型数据
    if (self.type == 3 || self.type == 4) {

        if (self.type == 3) {
            //货物详情描述
            [data setObject:self.putView.value forKey:@"goodsMsg"];
            
        }else if (self.type == 4){
            
            //预置值为空
            NSString *remark = @"";
            
            //遍历数据
            for (int i = 0; i < 5; i++) {
                
                UIButton *button = (UIButton *)[self.footerView viewWithTag:100+i];
                
                if (button.selected == YES) {
                    
                    if (remark.length == 0) {
                        remark = button.titleLabel.text;
                    }else{
                        remark = [NSString stringWithFormat:@"%@、%@",remark,button.titleLabel.text];
                    }
                }
            }
            
            //判断是否存在选项备注信息
            if (remark.length == 0) {
                remark = self.putView.value;
            }else{
                remark = [NSString stringWithFormat:@"%@;%@",remark,self.putView.value];
            }
            //赋值回传
            [data setObject:remark forKey:@"remark"];
        }
        
    }else{
        
        //判断数据填写类型
        for (RequestModel *model in self.array) {
            
            if (model.field.length > 0) {
                
                if (model.data.length == 0) {
                    model.data = @"";
                }
                //获取数据
                [data setObject:model.data forKey:model.field];
            }
        }
    }

    
    //回调
    if (self.dataBlock) {
        self.dataBlock(data);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
