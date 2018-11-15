
//
//  BindingCheckViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/4/24.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "BindingCheckViewController.h"

#import "BindingCheckCell.h"


@interface BindingCheckViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BindingCheckViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"绑定运力"];
    
    [self createNavInBindingCheck];
    
    [self.tableView reloadData];
}

//创建导航栏
- (void)createNavInBindingCheck{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInBindingCheck)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}

//左侧返回按钮点击事件
- (void)backInBindingCheck{
    
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
    
    return nil;
}
//表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000000001;
}


//表尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
}

//预估高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

- (NSString *)lineStatus:(NSString *)status{
    
    if ([status isEqualToString:@"1"]) {
        //客户发起
        status = @"绑定中";
        
    }else if ([status isEqualToString:@"2"]) {
        //运力公司发起
        status = @"绑定中";
        
    }else if ([status isEqualToString:@"3"]) {
        //确立关系
        status = @"确认绑定";
        
    }else if ([status isEqualToString:@"4"]) {
        //解除关系
        status = @"再次绑定";
        
    }else if ([status isEqualToString:@"4"]) {
        //客户拒绝
        status = @"再次绑定";
        
    }else if ([status isEqualToString:@"6"]) {
        //运力公司拒绝
        status = @"再次绑定";
        
    }else{
        
        status = @"绑定";
    }
    
    
    return status;
}

//返回cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"BindingCheckCellID";
    
    BindingCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BindingCheckCell" owner:self options:nil] objectAtIndex:0];
        
    }
    

    NSDictionary *dict = [self.array objectAtIndex:indexPath.section];
    
    cell.orgName.text = [dict stringWithKey:@"orgName"];
    
    cell.principal.text = [@"联系人: " stringByAppendingString:[dict stringWithKey:@"principal"]];
    
    cell.phone.text = [@"联系电话: " stringByAppendingString:[dict stringWithKey:@"phone"]];
    
    
    [cell.address fitHeightWithX:cell.address.x Y:cell.address.y width:cell.address.w font:cell.address.font Text:[NSString stringWithFormat:@"线路类型: %@",[dict stringWithKey:@"lineType"]]];
    
    
    [cell.bindBtn setTitle:[self lineStatus:[dict stringWithKey:@"status"]] forState:(UIControlStateNormal)];
    
    __weak typeof(cell) afterCell = cell;
    
    //绑定按钮
    cell.bindingBlock = ^{
        
        __strong typeof(afterCell) stongify = afterCell;
        
        [NetRequestManger POST:@"base/clientTransportationRelation/bindingTransportation" params:@{@"orgId":dict[@"orgId"]} success:^(id response) {
            
            
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
                
                [stongify.bindBtn setTitle:@"待通过" forState:(UIControlStateNormal)];
                
                [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dictionary[@"msg"]];
                
                //回调函数
//                BLOCK_EXEC(weakSelf.updateBindingBlock,YES);
                
            }else{
                
                [SVProgressHUD showImage:kSetImage(@"fail@2x") status:dictionary[@"msg"]];
            }

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    };
    
    
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
