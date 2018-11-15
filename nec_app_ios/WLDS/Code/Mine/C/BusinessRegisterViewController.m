//
//  BusinessRegisterViewController.m
//  WLDS
//
//  Created by han chen on 2018/3/7.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "BusinessRegisterViewController.h"
#import "HttpDataRequest.h"
#import "UIImage+category.h"
#import "RegisterCell.h"
#import "UITools.h"


@interface BusinessRegisterViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,RegisterDelegate>
{

    //记录证件类型
    NSInteger certifiType;
}

@property (nonatomic,retain) NSMutableDictionary *selecePicDic;

@property(retain,nonatomic) NSIndexPath *selectIndex;

//数据字典
@property (nonatomic,strong) NSMutableDictionary *dataDict;

//请求参数
@property (nonatomic,strong) NSMutableDictionary *request;

@end

@implementation BusinessRegisterViewController

/* * * * * * * * * *
 *
 * @ 请求参数对象
 *
 * * * * * * * * * */
- (NSMutableDictionary *)request{
    
    if (!_request) {
        _request = [[NSMutableDictionary alloc] init];
    }
    
    return _request;
}

/*
 
 }
 
 */
/* * * * * * * * * *
 *
 * @
 *
 * * * * * * * * * */
- (NSMutableDictionary *)dataDict{
    
    if (!_dataDict) {
        _dataDict = [[NSMutableDictionary alloc] init];
        
        
        for (int i = 0; i < 4; i++) {
            
            NSString *key = [NSString stringWithFormat:@"%d",i];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];;
            switch (i) {
                case 0:{
                    
                    for (int a = 0; a < 3; a++) {
                        
                        RequestModel *model = [[RequestModel alloc] init];
                        
                        if (a == 0) {

                            model.title = @"登录名";
                            model.field = @"loginName";
                            model.placeholder = @"请输入登录名";
                            model.data = @"";
                            
                        }else if (a == 1){
                            
                            model.title = @"密码";
                            model.field = @"password";
                            model.placeholder = @"请输入密码";
                            model.data = @"";
                            
                        }else if (a == 2){
                            
                            model.title = @"重复密码";
                            model.field = @"surePassword";
                            model.placeholder = @"请再次输入密码";
                            model.data = @"";
                        }
                        
                        //添加数据
                        [array addObject:model];
                    }
                    
                }
                    break;
                case 1:{
                    
                    for (int a = 0; a < 6; a++) {
                        
                        RequestModel *model = [[RequestModel alloc] init];
                        
                        if (a == 0) {
                            
                            model.title = @"公司名称";
                            model.field = @"orgName";
                            model.placeholder = @"请输入公司名称";
                            model.data = @"";
                            
                        }else if (a == 1){
                            
                            model.title = @"法人";
                            model.field = @"legalPerson";
                            model.placeholder = @"请输入法人姓名";
                            model.data = @"";
                            
                        }else if (a == 2){
                            
                            model.title = @"证件类型";
                            model.field = @"";
                            model.placeholder = @"";
                            model.data = @"";
                        }else if (a == 3){

                            model.title = @"营业执照注册号";
                            model.field = @"licenseCode";
                            model.placeholder = @"请输入营业执照注册号";
                            model.data = @"";
                            
                        }else if (a == 4){
                            
                            model.title = @"组织机构代码";
                            model.field = @"organizationCode";
                            model.placeholder = @"请输入组织机构代码";
                            model.data = @"";
                        }else if (a == 5){
                            
                            model.title = @"税务登记证号";
                            model.field = @"taxCode";
                            model.placeholder = @"请输入税务登记证号";
                            model.data = @"";
                        }
                        
                        //添加数据
                        [array addObject:model];
                    }
                }
                    break;
                case 2:{
                    for (int a = 0; a < 5; a++) {
                        
                        RequestModel *model = [[RequestModel alloc] init];
                        
                        if (a == 0) {
                            
                            model.title = @"公司地址";
                            model.field = @"address";
                            model.placeholder = @"请输入公司地址";
                            model.data = @"";
                            
                        }else if (a == 1){
                            
                            model.title = @"公司电话";
                            model.field = @"orgPhone";
                            model.placeholder = @"请输入公司电话";
                            model.data = @"";
                            
                        }else if (a == 2){
                            
                            model.title = @"联系人";
                            model.field = @"principal";
                            model.placeholder = @"请输入联系人";
                            model.data = @"";
                        }else if (a == 3){
                            
                            model.title = @"联系电话";
                            model.field = @"phone";
                            model.placeholder = @"请输入联系电话";
                            model.data = @"";
                            
                        }else if (a == 4){
                            
                            model.title = @"联系邮箱";
                            model.field = @"eMail";
                            model.placeholder = @"请输入联系邮箱";
                            model.data = @"";
                        }
                        
                        //添加数据
                        [array addObject:model];
                    }
                    
                }
                    break;
                case 3:{
                    
                    for (int a = 0; a < 3; a++) {
                        
                        RequestModel *model = [[RequestModel alloc] init];
                        
                        if (a == 0) {

                            model.title = @"营业执照图片";
                            model.field = @"license";
                            model.placeholder = @"";
                            model.data = @"";
                            
                        }else if (a == 1){
                            
                            model.title = @"组织机构照片";
                            model.field = @"organizationCodePic";
                            model.placeholder = @"";
                            model.data = @"";
                            
                        }else if (a == 2){
                            
                            model.title = @"税务登记证照片";
                            model.field = @"taxCodePic";
                            model.placeholder = @"";
                            model.data = @"";
                        }
                        
                        //添加数据
                        [array addObject:model];
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
            //添加数据
            [_dataDict setObject:array forKey:key];
        }
    }
    return _dataDict;
}


- (NSMutableDictionary *)selecePicDic{
    if (!_selecePicDic) {
        _selecePicDic = [[NSMutableDictionary alloc] init];
    }

    return _selecePicDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"企业注册";
    certifiType = 2;
    [self createNavInMessageDetails];
}


    //创建导航栏
- (void)createNavInMessageDetails{

        //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInMessageDetails)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
}

    //左侧返回按钮点击事件
- (void)backInMessageDetails{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ========   证件类型   ========
- (void)selectCertType:(UIButton *)sender{
    
    //获取标签值
    certifiType = sender.tag;
    
    NSMutableArray *array = (NSMutableArray *)[self.dataDict objectForKey:@"1"];
    
    RequestModel *data = [array objectAtIndex:2];
    
    //最后一列数据
    NSMutableArray *lastArr = [self.dataDict objectForKey:@"3"];
    
    //存储需要删除数据
    NSMutableArray *deleteArr = [[NSMutableArray alloc] init];
    
    //删除数据
    for (NSUInteger i = 0; i < array.count; i++) {
        
        RequestModel *check = [array objectAtIndex:i];
        
        if (i > 2) {
            
            [deleteArr addObject:check];

        }

    }
    
    //删除数据
    [array removeObjectsInArray:deleteArr];
    
    //移除数据
    [lastArr removeAllObjects];
    
    //三证全
    if (sender.tag == 2) {

        data.selected = NO;
        
        //循环添加
        for (int a = 0; a < 3; a++) {
            
            RequestModel *model = [[RequestModel alloc] init];
            
            if (a == 0){
                
                model.title = @"营业执照注册号";
                model.field = @"licenseCode";
                model.placeholder = @"请输入营业执照注册号";
                model.data = @"";
                
            }else if (a == 1){
                
                model.title = @"组织机构代码";
                model.field = @"organizationCode";
                model.placeholder = @"请输入组织机构代码";
                model.data = @"";
            }else if (a == 2){
                
                model.title = @"税务登记证号";
                model.field = @"taxCode";
                model.placeholder = @"请输入税务登记证号";
                model.data = @"";
            }
            
            //删除存在的数据
            [array addObject:model];
        }
        
        
        for (int a = 0; a < 3; a++) {
            
            RequestModel *model = [[RequestModel alloc] init];
            
            if (a == 0) {
                
                model.title = @"营业执照图片";
                model.field = @"license";
                model.placeholder = @"";
                model.data = @"";
                
            }else if (a == 1){
                
                model.title = @"组织机构照片";
                model.field = @"organizationCodePic";
                model.placeholder = @"";
                model.data = @"";
                
            }else if (a == 2){
                
                model.title = @"税务登记证照片";
                model.field = @"taxCodePic";
                model.placeholder = @"";
                model.data = @"";
            }
            
            //添加数据
            [lastArr addObject:model];
        }
        
    }else{
        
        //三合一
        data.selected = YES;
        
        RequestModel *model1 = [[RequestModel alloc] init];
        model1.title = @"统一社会信用代码";
        model1.field = @"creditCode";
        model1.placeholder = @"请输入统一社会信用代码";
        model1.data = @"";
        [array addObject:model1];
        
        //最后的数据
        RequestModel *model = [[RequestModel alloc] init];
        model.title = @"三证合一照片";
        model.field = @"certificatesPic";
        model.placeholder = @"";
        model.data = @"";
        [lastArr addObject:model];
        
    }
    
    //刷新页面
    [self.tableView reloadData];
}


#pragma mark ========   拍照   ========
- (void)userTakePhoto:(UIButton *)sender{

    self.selectIndex = [NSIndexPath indexPathForRow:sender.tag inSection:3];

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
            [self waringShow:@"您的设备没有摄像头"];
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

    RegisterCell *cell = [self.tableView cellForRowAtIndexPath:self.selectIndex];

    UIImage *selectImg = [info objectForKey:UIImagePickerControllerEditedImage];
    [cell.registerImg setBackgroundImage:selectImg forState:UIControlStateNormal];
    
    //设置图片
//    [cell.registerImg setImage:selectImg forState:UIControlStateNormal];
//    //营业执照
//    [self.selecePicDic setObject:selectImg forKey:[NSString stringWithFormat:@"%ld",self.selectIndex.row]];

    if (certifiType == 2) {
        
        if (self.selectIndex.row == 0) {
            //营业执照
            [self.selecePicDic setObject:selectImg forKey:@"license"];
            [self.request removeObjectForKey:@"license"];
            
        }else if (self.selectIndex.row == 1){
                //组织机构代码照片
            [self.selecePicDic setObject:selectImg forKey:@"organizationCodePic"];
            [self.request removeObjectForKey:@"organizationCodePic"];
            
        }else if (self.selectIndex.row == 2){
                //税务登记证照
            [self.selecePicDic setObject:selectImg forKey:@"taxCodePic"];
            [self.request removeObjectForKey:@"taxCodePic"];
        }
        
    }else{

            //三证合一证件照
        [self.selecePicDic setObject:selectImg forKey:@"certificatesPic"];
        [self.request removeObjectForKey:@"certificatesPic"];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ========   接收数据   ========
- (void)overAndSumit:(NSNotification *)info{
    
    //通知传递过来的数据
    NSDictionary *obj = (NSDictionary *)info.object;
    
    //数据赋值
    [self.request setObject:obj[@"data"] forKey:obj[@"key"]];
    
    //可执行下一步
    BOOL next = YES;
    
    if (certifiType == 2) {
        
        //获取营业执照数据
        NSString *value = [self.request stringWithKey:@"license"];
        
        if (value.length == 0) {
            
            next = NO;
        }
        
        //组织机构数据
        value = [self.request stringWithKey:@"organizationCodePic"];
        
        if (value.length == 0) {
            
            next = NO;
        }
        //税务登记机构数据
        value = [self.request stringWithKey:@"taxCodePic"];

        if (value.length == 0) {
            
            next = NO;
        }
    }
    
    //条件满足
    if (next == YES) {

        //满足条件后移除监听
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"uploadOverInBusinessRegister" object:nil];
        
        //发起网络数据请求
        [self networkRequest];
    }
}
#pragma mark ========   上传图片   ========
- (void)uploadImage{

    WEAKSELF
    
    ///绑定通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overAndSumit:) name:@"uploadOverInBusinessRegister" object:nil];
    
    //遍历
    for (NSString *key in self.selecePicDic.allKeys) {
        
        UIImage *image = self.selecePicDic[key];
        
        if (image != nil) {
            
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
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadOverInBusinessRegister" object:@{@"data":dic[@"ossUrl"],@"key":key}];
                    }
                    
                }else{
                    
                    [weakSelf waringShow:@"图片上传失败"];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                
            }];
        }
    }
}

#pragma mark 注册
- (void)networkRequest{

    WEAKSELF
    [HttpDataRequest askListByPage:self.request pageTitle:self.title
                       requestData:^(BOOL isSuccess, NSDictionary *dic) {
                           [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
                               //展示风火轮时，禁止其他操作
                           [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
                           [SVProgressHUD setBackgroundColor:kLikeColor];
                           [SVProgressHUD setForegroundColor:KTEXT_COLOR];
                           [SVProgressHUD dismissWithDelay:1.0];

                           if (isSuccess) {

                               if ([dic[@"success"] boolValue]) {
                                   [SVProgressHUD showImage:kSetImage(@"gouxuan@2x") status:dic[@"msg"]];

                                       //观察状态
                                   [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(goToLoginPage) name:@"SVProgressHUDDidDisappearNotification" object:nil];
                               }
                               else{
                                   [SVProgressHUD showImage:kSetImage(@"fail@2x") status:dic[@"msg"]];
                               }
                           }
                           

    }];
}


#pragma mark ========   登录成功   ========
- (void)goToLoginPage{
    for (UIViewController *showPage in [self.navigationController viewControllers]) {
        if ([showPage isKindOfClass:[JQLoginViewController class]]) {
            JQLoginViewController *page = (JQLoginViewController *)showPage;

//            [page registSuccessLogin:@{@"loginName":self.businessRegisterDic[@"0"],@"password":self.businessRegisterDic[@"1"]}];

            [self.navigationController popToViewController:showPage animated:YES];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataDict.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = [self.dataDict objectForKey:[NSString stringWithFormat:@"%ld",section]];

    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return 60;
    }
    else
        return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return 30;
    }
    else
        return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 100.0f;
    }
    else
        return 1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.textColor = kHexColor(0x999999);
        titleLab.font = [UIFont systemFontOfSize:13];
        titleLab.text = @"    证件图片";

        return titleLab;
    }
    else
        return  nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 3) {
        UIView *n_pBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 100)];

            //登录按钮
        n_pBackView.backgroundColor = [UIColor clearColor];

        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        loginBtn.frame = CGRectMake(20, 40, kWidth - 40, 40);

        [loginBtn setTitle:@"确认提交" forState:UIControlStateNormal];

        [loginBtn addTarget:self action:@selector(sureCommitMsg) forControlEvents:UIControlEventTouchUpInside];

        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [loginBtn setBackgroundColor:kMainColor];

        loginBtn.layer.cornerRadius = 5;

        loginBtn.layer.masksToBounds=YES;

        loginBtn.layer.borderColor=[[UIColor colorWithRed:0.08 green:0.51 blue:0.86 alpha:1] CGColor];

        loginBtn.layer.borderWidth= 1;

        [n_pBackView addSubview:loginBtn];

        return n_pBackView;
    }
    else
        return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegisterCell"];
    
    
    NSArray *array = [self.dataDict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
    
    //获取数据对象
    RequestModel *model = [array objectAtIndex:indexPath.row];
    
    if (indexPath.section != 3){
        
        //三证选择
        if ([model.title isEqualToString:@"证件类型"]) {
            
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RegisterCell" owner:self options:nil] objectAtIndex:4];
            }
            
            if (model.selected == NO) {
                
                cell.togetherPicBtn1.selected = NO;
                cell.togetherPicBtn2.selected = YES;
                
            }else{
                
                cell.togetherPicBtn1.selected = YES;
                cell.togetherPicBtn2.selected = NO;
                
            }
  
        }else{
            
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RegisterCell" owner:self options:nil] objectAtIndex:0];
            }
        
        }
        
        cell.contentText.text = model.data;
        cell.contentText.placeholder = model.placeholder;
        
        //设置标签
        cell.contentText.tag = 10008 * indexPath.section + indexPath.row;
        
    
    }else{
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RegisterCell" owner:self options:nil] objectAtIndex:2];
        }
        
        cell.registerImg.tag = indexPath.row;
    }
    
    
    cell.titleLab.text = model.title;
    
    cell.registerdelegate = self;
    
    if ((indexPath.section == 3)){

        UIImage *selectImg;

        switch (indexPath.row) {
            case 0:{
                
                if (certifiType == 2) {

                    selectImg = self.selecePicDic[@"license"];

                }else{
                    selectImg = self.selecePicDic[@"certificatesPic"];
                }
            }

                break;
            case 1:{

                selectImg = self.selecePicDic[@"organizationCodePic"];
            }

                break;
            case 2:{

               selectImg = self.selecePicDic[@"taxCodePic"];
            }

                break;
            default:
                break;
        }
        if (selectImg != nil) {
            
            [cell.registerImg setBackgroundImage:selectImg forState:UIControlStateNormal];
        }else{
            
            [cell.registerImg setBackgroundImage:[UIImage imageNamed:@"tupian"] forState:UIControlStateNormal];
        }
    }
    
    cell.contentText.secureTextEntry = NO;
    cell.contentText.keyboardType = UIKeyboardTypeDefault;
    
    if ([model.title isContainString:@"密码"]) {
        
        cell.contentText.secureTextEntry = YES;
        
    }else if ([model.title isContainString:@"电话"]){
        
        cell.contentText.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    return cell;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    //移除空格
    textField.text = [NSString removeTheSpacesForString:textField.text];
    
    NSInteger section = textField.tag / 10008;
    NSInteger row = textField.tag % 10008;
    
    
    //取出数据
    NSMutableArray *array = [self.dataDict objectForKey:[NSString stringWithFormat:@"%ld",section]];
    
    RequestModel *model = [array objectAtIndex:row];
    //数据记录
    model.data = textField.text;
    
}


- (void)feedTextPhone:(UITextField *)tfText{
    
        //cxf 自定义数字键盘上的完成按钮
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kWidth, 35)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * spaceBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    doneBtn.frame = CGRectMake(2, 5, 40, 30);
    [doneBtn addTarget:self action:@selector(dealKeyboardHide) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *doneBtnItem = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:spaceBtn,doneBtnItem,nil];
    [topView setItems:buttonsArray];

    [tfText setInputAccessoryView:topView];
    [tfText setAutocorrectionType:UITextAutocorrectionTypeNo];
    [tfText setAutocapitalizationType:UITextAutocapitalizationTypeNone];
}


-(void)dealKeyboardHide{
    kKeyBoardHiden;
}


//提交信息
- (void)sureCommitMsg{

    //密码
    NSString *pw = @"";
    //确认密码
    NSString *sure_pw = @"";
    
    //移除所有参数数据
    [self.request removeAllObjects];
    
    //循环遍历
    for (int i = 0; i < 4; i++) {
        
        NSString *key = [NSString stringWithFormat:@"%d",i];
        
        //获取数据
        NSArray *array = self.dataDict[key];
        
        //遍历数据
        for (RequestModel *model in array) {
        
            //判断是否存在字段
            if (model.field.length > 0) {

                //判断是否为邮箱字段
                if ([model.field isEqualToString:@"eMail"]) {
                    
                    if (model.data.length > 0) {
                        
                        //检验邮箱是否合法
                        if (![UITools isValidateEmail:model.data]){

                            [self waringShow:@"邮箱输入不合法，请重新输入"];
                            
                            return;
                        }
                    }

                }else{
                    
                    //存在占位符的非邮箱字段均为必传字段
                    if (model.placeholder.length > 0) {
                        
                        //判断是否存在数据
                        if (model.data.length == 0) {
                            
                            [self waringShow:model.placeholder];
                            
                            return;
                            
                        }else{
                            
                            //判断确认
                            if ([model.title isEqualToString:@"密码"]) {
                                
                                //记录密码数据
                                pw = model.data;
                                
                                if (sure_pw.length > 0) {
                                    
                                    if ([pw isEqualToString:sure_pw] == NO) {
                                        
                                        [self waringShow:@"两次密码输入不一致，请重新输入"];
                                        return;
                                    }
                                }
                                
                            }else if ([model.title isEqualToString:@"重复密码"]){
                                
                                //记录密码数据
                                sure_pw = model.data;
                                
                                if (pw.length > 0) {
                                    
                                    if ([pw isEqualToString:sure_pw] == NO) {
                                        
                                        [self waringShow:@"两次密码输入不一致，请重新输入"];
                                        return;
                                    }
                                }
                                
                            }
                        }
                    }
                }
                
                //根据字段赋值
                [self.request setObject:model.data forKey:model.field];
            }
            
        }
    }
    
    //判断是否选择了图片
    if (self.selecePicDic.allKeys.count == 0) {
        
        [self waringShow:@"请您按要求选择上传图片"];
        return;
        
    }else{
        
        
        if (certifiType == 2) {
            
            UIImage *image = self.selecePicDic[@"license"];
            
            if (image == nil) {
                
                [self waringShow:@"请选择营业执照图片"];
                return;
            }
            image= self.selecePicDic[@"organizationCodePic"];
            
            if (image == nil) {
                
                [self waringShow:@"请选择组织机构照片"];
                return;
            }
            image= self.selecePicDic[@"taxCodePic"];
            
            if (image == nil) {
                
                [self waringShow:@"请选择税务登记证照片"];
                
                return;
            }
            
        }else{
            
            UIImage *image= self.selecePicDic[@"certificatesPic"];
            
            if (image == nil) {
                
                [self waringShow:@"请选择三证合一证件照"];
                return;
            }
        }
    }

    //上传图片
    [self uploadImage];

}

@end
