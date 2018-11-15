//
//  WriteShipAddressViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/7.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "WriteShipAddressViewController.h"

#import "AddressChooseViewController.h"

#import "AreaViewController.h"
#import "WriteModel.h"

@interface WriteShipAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

//地址Id
@property (nonatomic,strong) NSString *ID;

//填写收发货人信息
@property (strong, nonatomic) IBOutlet UIView *headerView;

//名字标题
@property (weak, nonatomic) IBOutlet UILabel *nameLB;

@property (weak, nonatomic) IBOutlet UITextField *personTF;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;



//保存选择按钮
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet UILabel *typeLB;


@property (weak, nonatomic) IBOutlet UITextView *putTV;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *footerView;


@property (nonatomic,strong) NSMutableArray *array;

//选择位置记录
@property (nonatomic) NSInteger index;


@property (nonatomic,strong) UILabel *placeholderLB;

//省级ID
@property (nonatomic,strong) NSString *one;
//市级ID
@property (nonatomic,strong) NSString *two;
//区级ID
@property (nonatomic,strong) NSString *three;
//街道ID
@property (nonatomic,strong) NSString *four;

@property (nonatomic,strong) ShowView *showView;

@end

@implementation WriteShipAddressViewController

/* * * * * * * * * *
 *
 * @ 懒加载窗口视图
 *
 * * * * * * * * * */
- (ShowView *)showView{
    
    if (!_showView) {
        _showView = [[ShowView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,kHeight, kWidth,0)];
        backView.backgroundColor = kRedColor;
        [_showView addSubview:backView];
        
        //按钮创建
        UIButton *overBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        overBtn.titleLabel.font = kFontSize(kFitW(15));
        [backView addSubview:overBtn];
        overBtn.frame = CGRectMake(backView.w - kFitW(60),0,kFitW(60), kFitW(30));
        [overBtn cropLayer:5];
        [overBtn setTitle:@"完成" forState:(UIControlStateNormal)];
        [overBtn setTitleColor:kMainColor forState:(UIControlStateNormal)];
        
        
        for (int i = 0; i < 4; i++) {
            
            //按钮创建
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.titleLabel.font = kFontSize(12);
            [backView addSubview:button];
            button.frame = CGRectMake(i*(kWidth / 4),overBtn.v, kWidth/4, kFitW(40));
            [button cropLayer:5];
            
            button.backgroundColor = kOrangeColor;
            [button setTitle:@"确定" forState:(UIControlStateNormal)];
            [button setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
            //添加监听事件
            //            [button addTarget:self action:@selector(clickButtonIn:) forControlEvents:(UIControlEventTouchUpInside)];
            
            if (3 == i) {
                
                UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, button.v, kWidth, kFitW(40 * 10)) style:(UITableViewStylePlain)];
                [backView addSubview:tableView];
                tableView.separatorStyle = 0;
                tableView.delegate = self;
                tableView.dataSource = self;
                
                backView.frame = CGRectMake(0, kHeight - tableView.v, kWidth, tableView.v);
            }
            
        }
        
        
        //添加监听事件
        //            [button addTarget:self action:@selector(clickButtonIn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _showView;
}

#pragma mark ========   UITableViewDataSource/UITableViewDelegate   ========
//分区数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

//单个分区cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 30;
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
    
    return kFitW(40);
}

//返回cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld ——%ld",indexPath.section+1,indexPath.row+1];
    
    cell.backgroundColor = kRandomColor;
    
    return cell;
}

#pragma mark ========   跳转至选择地址页面   ========
- (IBAction)toChooseAddress:(UITapGestureRecognizer *)sender {

//    self.showView.hidden = NO;
    AddressChooseViewController *vc = [[AddressChooseViewController alloc] init];

    if (self.info.allKeys.count > 0) {
        //修改编辑信息
        [vc.info setValuesForKeysWithDictionary:self.info];
    }

    vc.title = self.title;

    WEAKSELF

    vc.chooseOverBlock = ^(NSDictionary *data) {

        //赋值操作
        [weakSelf.info setValuesForKeysWithDictionary:data];
        //修改数据
        [weakSelf changeDetails];
    };

    [self.navigationController pushViewController:vc animated:NO];
}

/* * * * * * * * * *
 *
 * @ 传递数据信息
 *
 * * * * * * * * * */
- (NSMutableDictionary *)info{
    
    if (!_info) {
        
        _info = [[NSMutableDictionary alloc] init];
    }
    return _info;
}

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

#pragma mark ========   是否保存地址按钮  ========
- (IBAction)saveOrNo:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected == YES) {
        
        [sender setImage:kSetImage(@"dianxuan_m@2x") forState:(UIControlStateNormal)];
    }else{
        [sender setImage:kSetImage(@"dianxuan_un@2x") forState:(UIControlStateNormal)];
    }
}
#pragma mark ========   提交地址   ========
- (IBAction)submitAddress:(UIButton *)sender {
    
    //获取省级ID
    self.one = [self.info stringWithKey:@"provinceId"];
    
    if (self.one.length == 0) {
        
        [self waringShow:@"请选择省级地址"];
        return;
    }
    
    //获取市级ID
    self.two = [self.info stringWithKey:@"cityId"];
    if (self.two.length == 0) {

        [self waringShow:@"请选择市级地址"];
        return;
    }
    
    //获取县/区级ID
    self.three = [self.info stringWithKey:@"regionId"];

    //获取街道ID
    self.four = [self.info stringWithKey:@"streetId"];

    //判断是否只读地址,无联系人
    if ([self.title isContainString:@"地址"]) {
        
        //回传填写信息
        if (self.writeAddressBlock) {
            
            NSDictionary *dict = @{@"Province":[self.info stringWithKey:@"province"],@"ProvinceId":self.one,@"City":[self.info stringWithKey:@"city"],@"CityId":self.two,@"Region":[self.info stringWithKey:@"region"],@"RegionId":self.three,@"Street":[self.info stringWithKey:@"street"],@"StreetId":self.four,@"Address":[self removeDetails]};
            
            self.writeAddressBlock(dict);

        }
        
        //返回上一页面
        [self backInWriteShipAddress];
        
        return;
        
    }else{
        
        //信息修改
        if (self.personTF.text.length == 0) {
            [self waringShow:@"请填写姓名"];
            return;
        }
        
        if (self.phoneTF.text.length == 0) {
            [self waringShow:@"请填写手机号"];
            return;
            
        }else if (self.phoneTF.text.length != 11){
            
            [self waringShow:@"请填写正确的手机号"];
            return;
        }
        
        //判断是否为修改
        if ([self.title isContainString:@"修改"]) {
            
            //保存信息数据请求
            [self saveOrChange];

        }else{
            
            //否则为新增
            //是否执行保存操作
            if (self.saveBtn.selected == NO) {
                
                //回传信息
                if (self.writeInfoBlock) {

                    NSDictionary *dict = @{@"Province":[self.info stringWithKey:@"province"],@"ProvinceId":self.one,@"City":[self.info stringWithKey:@"city"],@"CityId":self.two,@"Region":[self.info stringWithKey:@"region"],@"RegionId":self.three,@"Street":[self.info stringWithKey:@"street"],@"StreetId":self.four,@"Address":[self removeDetails],@"Name":self.personTF.text,@"Phone":self.phoneTF.text};
                    self.writeInfoBlock(dict);
                }
                
                //返回上一页面
                [self backInWriteShipAddress];
                
            }else{
                
                WEAKSELF
                
                if ([HelperSingle shareSingle].isLogin == NO) {
                    
                    //登录回调
                    [self toLogin:^(BOOL response) {

                        //保存信息数据请求
                        [weakSelf saveOrChange];
        
                    }];
                    
                }else{

                    //保存信息数据请求
                    [self saveOrChange];
                }
            }
        }
    }
}

//保存或者修改信息
- (void)saveOrChange{

    //默认新增
    NSString *url = @"base/orderSf/add";
    
    //设置默认新增和修改都是发货人类型 1 发货人    2 收货人
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"name":self.personTF.text,@"phone":self.phoneTF.text,@"province":[self.info stringWithKey:@"province"],@"provinceId":self.one,@"city":[self.info stringWithKey:@"city"],@"cityId":self.two,@"region":[self.info stringWithKey:@"region"],@"regionId":self.three,@"street":[self.info stringWithKey:@"street"],@"streetId":self.four,@"addressMsg":[self removeDetails],@"type":@"1",@"tel":@"",@"":@""}];
    
    if ([self.title isContainString:@"收货人"]) {
        
        [dict setObject:@"2" forKey:@"type"];
    }
    
    if (self.ID.length > 0) {
        
        //修改
        url = @"base/orderSf/update";
        
        [dict setObject:self.ID forKey:@"id"];
    }
    
    WEAKSELF
    //数据请求
    [NetRequestManger POST:url params:dict success:^(id response) {
        
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
            
            //回调数据
            BLOCK_EXEC(weakSelf.updateBlock,YES);
        }else{
            
            [SVProgressHUD showImage:kSetImage(@"fail@2x") status:dictionary[@"msg"]];
        }
        
        //观察状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveInfoBack) name:@"SVProgressHUDDidDisappearNotification" object:nil];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

#pragma mark ========   保存地址信息   ========
- (void)saveInfoBack{

    //回传信息
    if (self.writeInfoBlock) {

        NSDictionary *dict = @{@"Province":[self.info stringWithKey:@"province"],@"ProvinceId":self.one,@"City":[self.info stringWithKey:@"city"],@"CityId":self.two,@"Region":[self.info stringWithKey:@"region"],@"RegionId":self.three,@"Street":[self.info stringWithKey:@"street"],@"StreetId":self.four,@"Address":[self removeDetails],@"Name":self.personTF.text,@"Phone":self.phoneTF.text};
        
        self.writeInfoBlock(dict);

    }

    //返回上一页面
    [self backInWriteShipAddress];
}
#pragma mark ========   视图加载完成   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationController.navigationBar.translucent = NO;
    
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:self.title];
    [self createNavInWriteShipAddress];
    
    //键盘回收
    [self.view recycleKeyBoardWithDelegate:self];
    
    //添加视图
    self.tableView.tableFooterView = self.footerView;
    
    self.putTV.layer.masksToBounds = YES;
    self.putTV.layer.cornerRadius = 5;
    [self.putTV borderCutWithColor:kLikeColor width:1.0];
    //文字边距设设置
    self.putTV.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 10);//设置页边距
    
    self.putTV.textAlignment = NSTextAlignmentNatural; // 设置字体对其方式
    self.putTV.font = [UIFont systemFontOfSize:16]; // 设置字体大小
    self.putTV.textColor = kBlackColor; // 设置文字颜色
    [self.putTV setEditable:YES]; // 设置时候可以编辑
    
    
    //其次在UITextView上面覆盖个UILable,UILable设置为全局变量。
    _placeholderLB = [[UILabel alloc] init];
    _placeholderLB.numberOfLines = 0;
    _placeholderLB.text = @"请输入详细地址信息(精确到门牌号)\n例:江苏省南京市鼓楼区幕府东路199号";
    _placeholderLB.font = self.putTV.font;
    
    _placeholderLB.enabled = NO;//lable必须设置为不可用
    _placeholderLB.backgroundColor = [UIColor clearColor];
    [self.footerView addSubview:_placeholderLB];
    _placeholderLB.frame =CGRectMake(self.putTV.frame.origin.x + 12, self.putTV.frame.origin.y + 10, self.putTV.frame.size.width - 24, self.putTV.frame.size.height - 20);
    [UILabel adjustThePositionForLabel:_placeholderLB withLineSpacing:5];
    
    //改变固定显示
    if ([self.title isEqualToString:@"发货地址"]) {
        
        self.saveBtn.hidden = self.typeLB.hidden = YES;
    }else if ([self.title isEqualToString:@"收货地址"]){
        
        self.saveBtn.hidden = self.typeLB.hidden = YES;
        
    }else{

        if ([self.title isContainString:@"发货人"]){
            
            //添加顶部视图
            self.tableView.tableHeaderView = self.headerView;
            
            self.nameLB.text = @"发货人";
            self.personTF.placeholder = @"请填写发货人姓名";
            self.phoneTF.placeholder = @"请填写发货人手机号";
            self.typeLB.text = @"保存为新发货人";

        }else if ([self.title isContainString:@"收货人"]){
            //添加顶部视图
            self.tableView.tableHeaderView = self.headerView;
            self.nameLB.text = @"收货人";
            self.personTF.placeholder = @"请填写收货人姓名";
            self.phoneTF.placeholder = @"请填写收货人手机号";
            self.typeLB.text = @"保存为新收货人";
        }
        
        if ([self.title isContainString:@"修改"]) {
            
            //隐藏视图
            self.saveBtn.hidden = self.typeLB.hidden = YES;
            
        }else if ([self.title isContainString:@"新增"]) {
            
            //确认保存按钮选中，且关闭交互
            self.saveBtn.selected = YES;
            self.saveBtn.userInteractionEnabled = NO;
        }
        
        if (self.info.allKeys.count > 0) {
            
            //地址Id
            self.ID = [self.info stringWithKey:@"id"];
            //姓名
            self.personTF.text = [self.info stringWithKey:@"name"];
            //电话
            self.phoneTF.text = [self.info stringWithKey:@"phone"];
            
            //省
            self.one = [self.info stringWithKey:@"provinceId"];
            //市
            self.two = [self.info stringWithKey:@"cityId"];
            //区
            self.three = [self.info stringWithKey:@"regionId"];
            //街道
            self.four = [self.info stringWithKey:@"streetId"];
            
            //详细地址
            [self changeDetails];
        }
    }
}

//处理详细信息数据
- (void)changeDetails{

    //获取详细地址信息
    NSString *addressMsg = [self.info stringWithKey:@"addressMsg"];
    
    //获取省级名称
    NSString *province = [self.info stringWithKey:@"province"];
    //删除包含省的信息
    addressMsg = [addressMsg deleteSpecial:province];
    //获取市级名称
    NSString *city = [self.info stringWithKey:@"city"];
    //删除包含市的信息
    addressMsg = [addressMsg deleteSpecial:city];
    //获取县、区名称
    NSString *region = [self.info stringWithKey:@"region"];
    //删除包含县、区的信息
    addressMsg = [addressMsg deleteSpecial:region];
    //获取街道名称
    NSString *street = [self.info stringWithKey:@"street"];
    //删除包含街道信息
    addressMsg = [addressMsg deleteSpecial:street];
    
    //修改清除后的数据
    [self.info setObject:addressMsg forKey:@"addressMsg"];
    
    //详细地址
    self.putTV.text = [NSString stringWithFormat:@"%@%@%@%@%@",province,city,region,street,addressMsg];
    //判断是否存在文本信息
    if (self.putTV.text.length > 0) {
        self.placeholderLB.hidden = YES;
    }
}

//删除后的数据
- (NSString *)removeDetails{
    
    //获取详细地址信息
    NSString *addressMsg = self.putTV.text;
    
    //获取省级名称
    NSString *province = [self.info stringWithKey:@"province"];
    //删除包含省的信息
    addressMsg = [addressMsg deleteSpecial:province];
    //获取市级名称
    NSString *city = [self.info stringWithKey:@"city"];
    //删除包含市的信息
    addressMsg = [addressMsg deleteSpecial:city];
    //获取县、区名称
    NSString *region = [self.info stringWithKey:@"region"];
    //删除包含县、区的信息
    addressMsg = [addressMsg deleteSpecial:region];
    //获取街道名称
    NSString *street = [self.info stringWithKey:@"street"];
    //删除包含街道信息
    addressMsg = [addressMsg deleteSpecial:street];

    return addressMsg;
}

//创建导航栏
- (void)createNavInWriteShipAddress{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInWriteShipAddress)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}
//左侧返回按钮点击事件
- (void)backInWriteShipAddress{
    
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


#pragma mark == UITextView Delegate ==
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    kKeyBoardHiden;
    
    return YES;
}


//变化文本信息
-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        
        self.placeholderLB.hidden = NO;
        
    }else{
        self.placeholderLB.hidden = YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (range.location >= 500) {
        //控制输入文本的长度
        return  NO;
    }
    
    if ([text isEqualToString:@"\n"]) {
        //禁止输入换行
        kKeyBoardHiden;
        return NO;
        
    } else {
        
        return YES;
    }
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
