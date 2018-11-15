//
//  NegotiateViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/7/23.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "NegotiateViewController.h"

@interface NegotiateViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *number;

@property (weak, nonatomic) IBOutlet UITextField *tf;
@property(retain,nonatomic) NSIndexPath *selectIndex;

//图片字典
@property (nonatomic,strong) NSMutableDictionary *imageDict;

//上传成功数量
@property (nonatomic) NSInteger count;

@end

@implementation NegotiateViewController

/* * * * * * * * * *
 *
 * @ 懒加载数据
 *
 * * * * * * * * * */
- (NSMutableDictionary *)imageDict{
    
    if (!_imageDict) {
        _imageDict = [[NSMutableDictionary alloc] init];
    }
    return _imageDict;
}

/* * * * * * * * * *
 *
 * @ 懒加载数据
 *
 * * * * * * * * * */
- (NSMutableDictionary *)obj{
    
    if (!_obj) {
        _obj = [[NSMutableDictionary alloc] init];
    }
    return _obj;
}

#pragma mark ========   视图加载完成   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationController.navigationBar.translucent = NO;
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"通过平台协商处理"];
    [self createNavInNegotiate];
    
    [self.view recycleKeyBoardWithDelegate:self];
    
    self.tableView.tableHeaderView = self.headerView;
    
    //订单号
    self.number.text = [self.obj stringWithKey:@"code"];
    
    self.tf.QJBlock = ^(NSString *before, NSString *value) {
        
    };
    
    //数据实时变化监听
    __weak typeof(self.tf) afterCell = self.tf;
    
    self.tf.QJBlock = ^(NSString *before, NSString *value) {
        
        __strong typeof(afterCell) stongify = afterCell;
        
        //判断变化的字符是否为@"."，且变化前是不是存在@"."
        if ([value isEqualToString:@"."] && [before isContainString:@"."]) {
            
            stongify.text = before;
            return;
        }
    };
}

//创建导航栏
- (void)createNavInNegotiate{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInNegotiate)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}

//左侧返回按钮点击事件
- (void)backInNegotiate{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ========   UITableViewDataSource/UITableViewDelegate   ========
//分区数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

//单个分区cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (0 == section) {
        return 2;
    }
    return 1;
}

//表头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    view.backgroundColor = kWhiteColor;
    //顶部细线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,0, kWidth, 8.0)];
    [view addSubview:line];
    line.backgroundColor = kLikeColor;
    
    //文本信息
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,line.v, kWidth - 20, view.h - line.v)];
    label.textColor = KTEXT_COLOR;
    label.font = kFontSize(15);
    [view addSubview:label];
    
    if (0 == section) {
        label.text = @"提供证据，(货物照片或者回单异常签收照片)";
    }else{
        label.text = @"要有异常货物价值的证明，须有公章";
    }
    
    return view;
}
//表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
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

    return kFitW(180);
}

//返回cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"ChooseImageCellID";
    
    ChooseImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"ChooseImageCell" owner:self options:nil].lastObject;
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.title.text = @"上传货物照片";
        }else{
            cell.title.text = @"上传回单异常签收照片";
        }
    }else{
        cell.title.text = @"上传证明";
    }

    
    return cell;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //回收键盘
    kKeyBoardHiden;
    
    //记录分区
    self.selectIndex = indexPath;
    
    WEAKSELF
    //选择框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        // 如果有系统相机  BOOL值
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = weakSelf; // 设置代理
            picker.allowsEditing = YES;//允许进行修改布局 进行编辑
            
            // 指定数据的来源,图片的数据来源
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //模态弹出
            [weakSelf presentViewController:picker animated:YES completion:nil];
            
        }else {
            
            // 如果没有相机,提醒用户当前设备没有相机
            [weakSelf waringShow:@"您的设备没有摄像头"];
        }
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.delegate = weakSelf;
            
            picker.allowsEditing = YES;
            
            // 指定数据来源为系统相册
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            // 模态弹出
            [weakSelf presentViewController:picker animated:YES completion:nil];
        }
        
    }]];
    
    //取消操作
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDestructive) handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark ========   拍摄完成或从相册中选择完成之后执行的方法   ========
//标记 归类 (#pragma mark)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    ChooseImageCell *cell = [self.tableView cellForRowAtIndexPath:self.selectIndex];
    
    UIImage *selectImg = [info objectForKey:UIImagePickerControllerEditedImage];
    cell.IM.image = selectImg;

    //记录位置数据
    if (self.selectIndex.section == 0) {
        
        if (self.selectIndex.row ==0) {
            
            [self.imageDict setObject:selectImg forKey:@"goodsPicture"];
            
        }else{
            [self.imageDict setObject:selectImg forKey:@"receiptPicture"];
        }
        
    }else{
        
        [self.imageDict setObject:selectImg forKey:@"provePicture"];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


//保存信息
- (IBAction)submitInfo:(UIButton *)sender {
    
    if (self.tf.text.length == 0) {
        [self waringShow:@"请检查是否输入索赔金额"];
        return;
    }
    //记录索金额数据
    [self.obj setObject:self.tf.text forKey:@"claimAmount"];
    
    BOOL next = NO;
    //判断是否允许上传条件
    if ([self.imageDict includeTheKey:@"provePicture"] && ([self.imageDict includeTheKey:@"goodsPicture"] || [self.imageDict includeTheKey:@"receiptPicture"])) {
        next = YES;
    }else{
        
        [self waringShow:@"您需要上传货物照片与回单异常图片其中之一，证明图片需要上传"];
        return;
    }
    
    //默认记录为0
    self.count = 0;
    
    ///绑定通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overAndSumit:) name:@"uploadOverInNegotiate" object:nil];
    
    //循环上传
    for (NSString *key in self.imageDict) {
        
        //获取图片 
        UIImage *image = self.imageDict[key];
        
        [NetRequestManger UPLOADIMAGE:@"api/upload/android" params:nil uploadImage:image success:^(id response) {
            
            //数据转换
            NSDictionary *dictionary = (NSDictionary *)response;
            
            //数据请求值
            BOOL success = [dictionary[@"success"] boolValue];
            
            //判断是否请求成功
            if (success == YES) {
                
                NSArray *data = dictionary[@"data"];
                
                if (data.count > 0) {
                    
                    //通知数据
                    NSDictionary *dic = [data firstObject];
                    
                    //发送通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadOverInNegotiate" object:@{@"data":dic[@"ossUrl"],@"key":key}];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
        }];
        
    }

}

#pragma mark ========   接收数据   ========
- (void)overAndSumit:(NSNotification *)info{
    
    //通知传递过来的数据
    NSDictionary *obj = (NSDictionary *)info.object;
    
    //数据赋值
    [self.obj setObject:obj[@"data"] forKey:obj[@"key"]];
    
    //数据累加
    self.count = self.count + 1;
    
    //条件满足
    if (self.count == self.imageDict.allKeys.count) {

        //满足条件后移除监听
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"uploadOverInNegotiate" object:nil];
        
        //获取数据
        [NetRequestManger POST:@"base/orderComplain/insertOrderComplainpt" params:self.obj success:^(id response) {
            
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
                
                //观察状态
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backSVPInNegotiate) name:@"SVProgressHUDDidDisappearNotification" object:nil];
                [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dictionary[@"msg"]];
            }else{
                [SVProgressHUD showImage:kSetImage(@"fail@2x") status:dictionary[@"msg"]];
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

//成返回
- (void)backSVPInNegotiate{
    
    //执行
    for (UIViewController *temp in self.navigationController.viewControllers) {
        
        //判断是否
        if ([temp isKindOfClass:[ClaimViewController class]]||[temp isKindOfClass:[MessageDetailsController class]]) {
            
            [self.navigationController popToViewController:temp animated:YES];
            
            break;
        }
    }

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
