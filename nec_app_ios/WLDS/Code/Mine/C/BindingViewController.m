//
//  BindingViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/4/24.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "BindingViewController.h"


#import "BindingCheckViewController.h"

@interface BindingViewController ()

//参数字典
@property (nonatomic,strong) NSMutableDictionary *request;

@end

@implementation BindingViewController

/* * * * * * * * * *
 *
 * @ 懒加载字典参数
 *
 * * * * * * * * * */
- (NSMutableDictionary *)request{
    
    if (!_request) {
        _request = [[NSMutableDictionary alloc] init];
    }
    return _request;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"查询运力"];
    
    [self createNavInBinding];
}

//创建导航栏
- (void)createNavInBinding{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInBinding)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}

//绑定手势
- (IBAction)tapInBinding:(UITapGestureRecognizer *)sender {
    
    NSInteger index = sender.view.tag - 100;
    
    WriteShipAddressViewController *vc = [[WriteShipAddressViewController alloc] init];

    
    WEAKSELF
    vc.writeAddressBlock = ^(NSDictionary *data) {
        
        UILabel *label = (UILabel *)sender.view;
        
        label.text = [NSString stringWithFormat:@"%@%@%@%@%@",data[@"Province"],data[@"City"],data[@"Region"],data[@"Street"],data[@"Address"]];
        
        NSString *prefix = @"f";
        
        switch (index) {
                
            case 2:{
                
                prefix = @"d";

            }
                
                break;
                
            default:
                break;
        }
        
        //发货地址
        for (NSString *key in data.allKeys) {
            
            //获取值
            NSString *value = data[key];
            
           if ([key isEqualToString:@"CityId"]){
                
                [weakSelf.request setObject:value forKey:[prefix stringByAppendingString:@"scode"]];
            }else if ([key isEqualToString:@"RegionId"]){
                
                [weakSelf.request setObject:value forKey:[prefix stringByAppendingString:@"xcode"]];
            }else if ([key isEqualToString:@"StreetId"]){
                
                [weakSelf.request setObject:value forKey:[prefix stringByAppendingString:@"jcode"]];
            }
        }
    };

    switch (index) {
            
        case 1:{
            //发货地址
            vc.title = @"发货地址";
        }
            break;
        case 2:{
            //收货地址
            vc.title = @"收货地址";
        }
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}


//左侧返回按钮点击事件
- (void)backInBinding{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//查询绑定
- (IBAction)checkBinding:(UIButton *)sender {
    
    //第1地址
    UILabel *label1 = (UILabel *)[self.view viewWithTag:101];
    
    if ([label1.text isContainString:@"请选择"]) {
        
        [self waringShow:label1.text];
        return;
    }
    
    //第二地质
    UILabel *label2 = (UILabel *)[self.view viewWithTag:102];
    
    if ([label2.text isContainString:@"请选择"]) {
        
        [self waringShow:label2.text];
        return;
    }
    
    WEAKSELF
    //请求数据
    [NetRequestManger POST:@"base/line/findSysOrgByLine" params:self.request success:^(id response) {
        
        //数据转换
        NSDictionary *dictionary = (NSDictionary *)response;
        
        //数据请求值
        BOOL success = [dictionary[@"success"] boolValue];
        
        //判断是否请求成功
        if (success == YES) {
            
            NSArray *array = dictionary[@"data"];
            
            if (array.count > 0) {
                
                BindingCheckViewController *vc = [[BindingCheckViewController alloc] init];
                [vc.array addObjectsFromArray:array];
                [weakSelf.navigationController pushViewController:vc animated:YES];
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
