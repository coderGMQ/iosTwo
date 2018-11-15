//
//  AddressChooseViewController.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/13.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressChooseViewController : UIViewController

//数据结构
@property (nonatomic,strong) NSMutableDictionary *info;


//区域Id
@property (nonatomic,strong) NSString *Id;

//更新前页数据
@property (nonatomic,copy) void (^chooseOverBlock) (NSDictionary *data);

@end


////
////  AddressChooseViewController.m
////  WLDS
////
////  Created by zhiyundaohe on 2018/7/13.
////  Copyright © 2018年 zhiyundaohe. All rights reserved.
////
//
//#import "AddressChooseViewController.h"
//
//#import "WriteModel.h"
//
//@interface AddressChooseViewController ()
//
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
//
//
////字典数据
//@property (nonatomic,strong) NSMutableDictionary *dict;
//
////关键字
//@property (nonatomic,strong) NSMutableArray *keys;
//
////记录获取数据位置
//@property (nonatomic) NSInteger index;
//@property (weak, nonatomic) IBOutlet UIView *backView;
//@property (strong, nonatomic) UILabel *line;
//
//
//@end
//
//@implementation AddressChooseViewController
//
///* * * * * * * * * *
// *
// * @
// *
// * * * * * * * * * */
//- (UILabel *)line{
//
//    if (!_line) {
//
//        //省级按钮
//        UIButton *province = (UIButton *)[self.view viewWithTag:100];
//
//        //底部细线
//        _line = [[UILabel alloc] initWithFrame:CGRectMake(province.x,province.v + 8,(kWidth - 10 * 2 - 3 * 5) / 4, 2)];
//        _line.backgroundColor = kMainColor;
//    }
//    return _line;
//}
//
///* * * * * * * * * *
// *
// * @ 懒加载字典key
// *
// * * * * * * * * * */
//- (NSMutableArray *)keys{
//
//    if (!_keys) {
//        _keys = [[NSMutableArray alloc] init];
//    }
//    return _keys;
//}
//
///* * * * * * * * * *
// *
// * @ 懒加载字典
// *
// * * * * * * * * * */
//- (NSMutableDictionary *)info{
//
//    if (!_info) {
//
//        _info = [[NSMutableDictionary alloc] init];
//    }
//
//    return _info;
//}
//
///* * * * * * * * * *
// *
// * @ 懒加载字典
// *
// * * * * * * * * * */
//- (NSMutableDictionary *)dict{
//
//    if (!_dict) {
//
//        _dict = [[NSMutableDictionary alloc] init];
//    }
//
//    return _dict;
//}
//
////按钮点击类型
//- (IBAction)chooseType:(UIButton *)sender {
//
//    //记录位置
//    self.index = sender.tag - 100;
//
//    //获取数据
//    [self gainDataInAddressChoose];
//
//    WEAKSELF
//    [UIView animateWithDuration:0.3 animations:^{
//
//        //细线位置
//        weakSelf.line.center = CGPointMake(sender.center.x, weakSelf.line.center.y);
//    }];
//
//}
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    //设置标题
//    [self setFont:kTitFont color:kWhiteColor title:self.title];
//
//    //创建导航栏
//    [self createNavInAddressChoose];
//
//    //添加底部视图
//    [self.backView addSubview:self.line];
//    //判断获取情况
//    if (self.info.allValues.count > 0) {
//        //初始赋值
//        [self beginningValue];
//    }
//
//    //获取数据
//    [self gainDataInAddressChoose];
//}
//
////根据上页数据初始化按钮
//- (void)beginningValue{
//
//    //获取省Id
//    NSString *ID = [self.info stringWithKey:@"provinceId"];
//
//    //省级按钮
//    UIButton *province = (UIButton *)[self.view viewWithTag:100];
//
//    if (ID.length == 0) {
//
//        return;
//    }
//    //获取省级地址
//    ID = [self.info stringWithKey:@"province"];
//
//    [province setTitle:ID forState:(UIControlStateNormal)];
//
//    //市级按钮
//    UIButton *city = (UIButton *)[self.view viewWithTag:101];
//    city.hidden = NO;
//
//    self.line.frame = CGRectMake(self.line.l+5,self.line.y, self.line.w, self.line.h);
//    //细线停留位置
//    self.index = 1;
//
//    //获取市Id
//    ID = [self.info stringWithKey:@"cityId"];
//    if (ID.length == 0) {
//
//        return;
//    }
//
//    //获取城市地址
//    ID = [self.info stringWithKey:@"city"];
//    //当前按钮
//    [city setTitle:ID forState:(UIControlStateNormal)];
//
//    //县/区按钮
//    UIButton *region = (UIButton *)[self.view viewWithTag:102];
//    region.hidden = NO;
//
//    self.line.frame = CGRectMake(self.line.l+5,self.line.y, self.line.w, self.line.h);
//
//    //细线停留位置
//    self.index = 2;
//
//    NSLog(@" ==执行了 == 154代码");
//    //获取区/县Id
//    ID = [self.info stringWithKey:@"regionId"];
//
//    if (ID.length == 0) {
//
//        return;
//    }
//
//    //获取取县/区地址
//    ID = [self.info stringWithKey:@"region"];
//    //当前按钮
//    UIButton *button = (UIButton *)[self.view viewWithTag:102];
//    [button setTitle:ID forState:(UIControlStateNormal)];
//
//    //街道按钮
//    UIButton *street = (UIButton *)[self.view viewWithTag:103];
//    street.hidden = NO;
//    self.line.frame = CGRectMake(self.line.l+5,self.line.y, self.line.w, self.line.h);
//
//    //细线停留位置
//    self.index = 3;
//
//    //获取街道Id
//    ID = [self.info stringWithKey:@"streetId"];
//    if (ID.length > 0) {
//
//        //获取街道地址
//        ID = [self.info stringWithKey:@"street"];
//        //当前按钮
//        [street setTitle:ID forState:(UIControlStateNormal)];
//    }
//}
//
//#pragma mark ========   按钮重新赋值操作   ========
//- (void)buttonValue:(NSString *)value location:(NSInteger)location next:(BOOL)next{
//
//    for (NSInteger i = location; i < 4; i++) {
//
//        UIButton *button = (UIButton *)[self.view viewWithTag:100+i];
//
//        if (i == location) {
//
//            [button setTitle:value forState:(UIControlStateNormal)];
//
//        }else{
//
//            [button setTitle:@"请选择" forState:(UIControlStateNormal)];
//            //隐藏下一个按钮
//            button.hidden = YES;
//
//            //判断是否
//            if (next == YES) {
//
//                if (i == location + 1) {
//
//                    //展示下一个按钮
//                    button.hidden = NO;
//
//                    //移除所有数据兑现
//                    [self.dict removeAllObjects];
//                    //移除keys
//                    [self.keys removeAllObjects];
//
//                    //刷新列表
//                    [self.tableView reloadData];
//
//                    //更新记录位置信息
//                    self.index = i;
//                    //获取数据
//                    [self gainDataInAddressChoose];
//
//                    WEAKSELF
//                    [UIView animateWithDuration:0.3 animations:^{
//                        //细线位置
//                        weakSelf.line.center = CGPointMake(button.center.x, weakSelf.line.center.y);
//
//                    }];
//                }
//            }
//        }
//    }
//}
//
//#pragma mark ========   查询数据   ========
//- (void)gainDataInAddressChoose{
//
//    //ID为空(默认请求一级省级数据)
//    switch (self.index) {
//
//        case 1:{
//            //请求二级市级数据，ID取省级
//            self.Id = [self.info objectForKey:@"provinceId"];
//        }
//            break;
//        case 2:{
//            //请求三级区/县级数据，ID取市级
//            self.Id = [self.info objectForKey:@"cityId"];
//        }
//            break;
//        case 3:{
//            //请求四级街道数据，ID取区级
//            self.Id = [self.info objectForKey:@"regionId"];
//            //streetId街道
//        }
//            break;
//
//        default:{
//            //默认数据为空
//            self.Id = @"";
//        }
//            break;
//    }
//
//    WEAKSELF
//    [NetRequestManger POST:@"base/sysCity/selectCityById" params:@{@"id":self.Id} success:^(id response) {
//
//        //数据转换
//        NSDictionary *dictionary = (NSDictionary *)response;
//
//        //数据请求值
//        BOOL success = [dictionary[@"success"] boolValue];
//
//        //判断是否请求成功
//        if (success == YES) {
//            //获取数据
//            NSDictionary *data = dictionary[@"data"];
//
//            //移除所有数据兑现
//            [weakSelf.dict removeAllObjects];
//            //移除keys
//            [weakSelf.keys removeAllObjects];
//
//            //数据
//            for (NSDictionary *obj in data[@"items"]) {
//
//                //提取首字母
//                NSString *key = [NSString firstCharactor:obj[@"areaname"]];
//
//                NSMutableArray *array = self.dict[key];
//
//                WriteModel *model = [WriteModel shareWriteModelWithDictionary:obj];
//
//                if (array == nil) {
//
//                    array = [[NSMutableArray alloc] initWithObjects:model, nil];
//
//                    [weakSelf.dict setObject:array forKey:key];
//
//                }else{
//
//                    [array addObject:model];
//                }
//            }
//            //添加数据字段
//            NSArray *values = [weakSelf.dict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
//
//                return [obj1 compare:obj2 options:NSNumericSearch];
//
//            }];
//
//            //添加数据
//            [weakSelf.keys addObjectsFromArray:values];
//
//            //刷新数据
//            [weakSelf.tableView reloadData];
//
//        }
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//    }];
//
//}
//
////创建导航栏
//- (void)createNavInAddressChoose{
//
//    //左侧返回按钮
//    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInAddressChoose)];
//    self.navigationItem.leftBarButtonItem = leftBar;
//    leftBar.tintColor = kWhiteColor;
//
//}
//
////左侧返回按钮点击事件
//- (void)backInAddressChoose{
//
//    [self.navigationController popViewControllerAnimated:YES];
//}
//#pragma mark ========   UITableViewDataSource/UITableViewDelegate   ========
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//
//    return self.keys.count;  //返回26个字母
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//    NSArray *array = [self.dict objectForKey:[self.keys objectAtIndex:section]];
//
//    return array.count;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return kFitW(40);
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    static NSString *ID = @"cell";
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//
//    if (cell == nil) {
//
//        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
//    }
//
//    cell.selectionStyle = 0;
//
//    NSArray *array = [self.dict objectForKey:[self.keys objectAtIndex:indexPath.section]];
//    //数据展示
//    WriteModel *model = [array objectAtIndex:indexPath.row];
//    cell.textLabel.text = model.areaname;
//
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return 0.00000001;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    return nil;
//}
//
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//
//    return self.keys;  //返回26个字母
//}
//
////表尾视图
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//    return nil;
//}
////表尾高度
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//
//    return 3;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
////    if (self.chooseAreaBlock) {
////
////        NSArray *array = [self.dict objectForKey:[self.keys objectAtIndex:indexPath.section]];
////        //数据展示
////        WriteModel *model = [array objectAtIndex:indexPath.row];
////
////        //数据展示
////        self.chooseAreaBlock(model.areaname,[NSString stringWithFormat:@"%@",model.Id]);
////        [self.navigationController popViewControllerAnimated:YES];
////    }
//
//    //数据展示
//    NSArray *array = [self.dict objectForKey:[self.keys objectAtIndex:indexPath.section]];
//    WriteModel *model = [array objectAtIndex:indexPath.row];
//    //记录Id
//    self.Id = [NSString stringWithFormat:@"%@",model.Id];
//
//    //ID为空(默认请求一级省级数据)
//
//    switch (self.index) {
//
//        case 0:{
//            //存储省级数据ID
//            [self.info setObject:self.Id forKey:@"provinceId"];
//        }
//            break;
//        case 1:{
//
//            //存储省级数据ID
//            [self.info setObject:self.Id forKey:@"cityId"];
//        }
//            break;
//        case 2:{
//            //存储区级数据ID
//            [self.info setObject:self.Id forKey:@"regionId"];
//        }
//            break;
//        case 3:{
//            //存储区级数据ID
//            [self.info setObject:self.Id forKey:@"streetId"];
//        }
//            break;
//    }
//
//    [self buttonValue:model.areaname location:self.index next:YES];
//}
//
//#pragma mark ========   确认选择   ========
//- (IBAction)sureChoose:(UIButton *)sender {
//
//
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
