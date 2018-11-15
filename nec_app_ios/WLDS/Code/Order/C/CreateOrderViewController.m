//
//  CreateOrderViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/3.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "CreateOrderViewController.h"

#import "CreateOrderTableViewCell.h"

#import "CreateCell.h"

#import "HaulageOperatorTableViewController.h"

//输入信息页面
#import "CreateInputViewController.h"

//优惠券
#import "DiscountsTableViewController.h"

/* * * * * * * * * *
 请求参数 参数名
 
 发货人姓名   @"deliveryName"
 发货人电话   @"deliveryPhone
 发货省份id   @"deliveryProvinceId
 发货省份     @"deliveryProvince
 发货城市id   @"deliveryCityId
 发货城市     @"deliveryCity
 发货区县id   @"deliveryRegionId
 发货区县     @"deliveryRegion
 发货地址     @"deliveryAddress
 
 
 收货人姓名    @"receivingName
 收货人电话    @"receivingPhone
 收货省份id   @"receivingProvinceId
 收货省份     @"receivingProvince
 收货城市id   @"receivingCityId
 收货城市     @"receivingCity
 收货区县id   @"receivingRegionId
 收货区县     @"receivingRegion
 收货地址     @"receivingAddress
 
 货物名       @"productName
 货物重量     @"weight
 货物体积     @"volume
 件数        @"goodsNum
 回单        @"theReceipt
 保价        @"insured
 代收货款     @"collectionMoney
 
 
 送货方式    deliveryMethod    0 送货 1 自提 2 等通知放货
 付款方式    payMethod         1 现付 2 在线支付 3 到付  4 欠回付
 是否提货    pickGoodsMethod   1 是  2 否
 声明货价    declaredValue
 运力公司id  capacityId
 运力产品id  productId
 
 
 *
 * * * * * * * * * */
@interface CreateOrderViewController ()<UITextFieldDelegate>

//备注信息
@property (weak, nonatomic) IBOutlet UILabel *remarkLB;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UIView *footerView;



@property (weak, nonatomic) IBOutlet UITableView *tableView;

//请求参数
@property (nonatomic,strong) NSMutableDictionary *request;

@property (nonatomic,strong) ShowView *showView;

@property (nonatomic,strong) UIView *backView;

//查询到的数据
@property (nonatomic,strong) NSMutableDictionary *checkData;

//默认初始值
@property (nonatomic,strong) NSDictionary *defValue;

@end

@implementation CreateOrderViewController

/* * * * * * * * * *
 *
 * @
 *
 * * * * * * * * * */
- (NSDictionary *)defValue{
    
    if (!_defValue) {
        
        //获取当前时间
        NSString *makeTime = [NSDate getCurrentTimeWithFormat:@"YYYY-MM-dd"];
        
        _defValue = @{@"deliveryMethod":@"0",@"payMethod":@"1",@"pickGoodsMethod":@"1",@"serviceTypeSl":@"0",@"serviceTypeZh":@"0",@"serviceTypeXh":@"0",@"receiptType":@"0",@"serviceType":@"0",@"isRule":@"0",@"makeTime":makeTime,@"isTaxes":@"1"};
    }
    return _defValue;
}

/* * * * * * * * * *
 *
 * @ 懒加载数据集合
 *
 * * * * * * * * * */
- (NSMutableDictionary *)checkData{
    
    if (!_checkData) {
        _checkData = [[NSMutableDictionary alloc] init];
    }
    return _checkData;
}


/* * * * * * * * * *
 *
 * @ 选择视图
 *
 * * * * * * * * * */
- (ShowView *)showView{
    
    if (!_showView) {
        
        _showView = [[ShowView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        
        //背景视图
        _backView = [[UIView alloc] init];
        [_showView addSubview:_backView];
        _backView.backgroundColor = kWhiteColor;
        
        //第一层视图
        UIView *firstView = [[UIView alloc] init];
        firstView.tag = 1000;
        [_backView addSubview:firstView];
        
        //优惠券数量展示文本框
        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(15,0,kFitW(220), kFitW(40))];
        number.textColor = KTEXT_COLOR;
        number.font = kFontSize(kFitW(15));
        number.text = @"选择优惠券(有1张可用)";
        number.tag = 1001;
        [firstView addSubview:number];
        
        //更多优惠券点击视图
        UIView *more = [[UIView alloc] initWithFrame:CGRectMake(number.l, number.y,kWidth - number.l, number.h)];
        [firstView addSubview:more];
        more.tag = 1002;

        //查看更多
        [more clickWithDelegate:nil target:self action:@selector(moreCheck:)];
        
        //更多图
        UIImageView *nextIV = [[UIImageView alloc] initWithFrame:CGRectMake(more.w  - 15,(more.h - 15)/2,15,15)];
        [more addSubview:nextIV];
        nextIV.image = kSetImage(@"next@2x");
        
        //文本信息
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,nextIV.x,more.h)];
        label.textColor = kMainColor;
        label.font = kFontSize(kFitW(14));
        label.text = @"查看更多";
        label.textAlignment = NSTextAlignmentRight;
        [more addSubview:label];
        
        //优惠券背景图
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(number.x, number.v, kFitW(180), kFitW(60))];
        [firstView addSubview:iv];
        iv.image = kSetImage(@"youhuiquanbeijing@2x");
        iv.contentMode = UIViewContentModeScaleAspectFit;
        
        //文本信息
        UILabel *cost = [[UILabel alloc] initWithFrame:CGRectMake(10,5,iv.w - 30, iv.h-10)];
        cost.textColor = kWhiteColor;
        cost.font = kFontSize(kFitW(13));
        cost.numberOfLines = 0;
        cost.tag = 1003;
        cost.textAlignment = NSTextAlignmentCenter;
        [iv addSubview:cost];
        
        //设置frame
        firstView.frame = CGRectMake(0, 0,kWidth, iv.v + 5);
        
        for (int i = 0; i < 3; i++) {
            
            //背景视图
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, firstView.v + i*kFitW(40), kWidth, kFitW(40))];
            [_backView addSubview:view];
            
            //设置标签
            view.tag = 1000 * (i + 2);
            
            //底部细线
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,0,kWidth, 1.0)];
            [view addSubview:line];
            line.backgroundColor = kLikeColor;
            
            //文本信息
            UILabel *title = [[UILabel alloc] init];
            //设置标签
            title.tag = view.tag + 100;
            title.textColor = KTEXT_COLOR;
            title.font = kFontSize(kFitW(15));
            [view addSubview:title];
   
            if (0 == i) {
                
                title.text = @"运力公司名称";
                
                //更多优惠券点击视图
                UIView *orgMore = [[UIView alloc] initWithFrame:CGRectMake(view.w - more.w, line.v,more.w,view.h - line.v)];
                [view addSubview:orgMore];

                //设置标签
                orgMore.tag = view.tag + 10;
                //查看更多
                [orgMore clickWithDelegate:nil target:self action:@selector(moreCheck:)];
                
                //优惠券背景图
                UIImageView *nextIV = [[UIImageView alloc] initWithFrame:CGRectMake(more.w  - 15,(more.h - 15)/2,15,15)];
                [orgMore addSubview:nextIV];
                nextIV.image = kSetImage(@"next@2x");
                
                //文本信息
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,nextIV.x,orgMore.h)];
                label.textColor = kMainColor;
                label.font = kFontSize(kFitW(14));
                label.text = @"查看更多";
                label.textAlignment = NSTextAlignmentRight;
                [orgMore addSubview:label];
                
                //绘制大小
                title.frame = CGRectMake(number.x,orgMore.y,orgMore.x - number.x,orgMore.h);
                
            }else{
                
                title.frame = CGRectMake(number.x,line.v,kFitW(100),view.h - line.v);
                title.text = @"价格";
                //文本信息
                UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(title.l + 5,title.y, view.w - (title.l + 20),title.h)];
                sub.textColor = kGrayColor;
                sub.font = kFontSize(kFitW(15));
                //设置标签
                sub.tag = view.tag + 10;
                sub.textAlignment = NSTextAlignmentRight;
                [view addSubview:sub];
                
                 if (2 == i){
                     title.text = @"预计到达时间";
                     //按钮创建
                     UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
                     button.titleLabel.font = kFontSize(kFitW(15));
                     [_backView addSubview:button];
                     button.frame = CGRectMake(0,view.v, kWidth, kFitW(40));
                     button.backgroundColor = kMainColor;
                     [button setTitle:@"确认下单" forState:(UIControlStateNormal)];
                     [button setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
                     button.tag = 5000;
                     //位置信息
                     _backView.frame = CGRectMake(0,kHeight, kWidth,0);
                     
                     //添加监听事件
                     [button addTarget:self action:@selector(sureOrder:) forControlEvents:(UIControlEventTouchUpInside)];
                 }
            }
        }
    }
    return _showView;
}

#pragma mark ========   查看更多   ========
- (void)moreCheck:(UITapGestureRecognizer *)tap{
    
    if (tap.view.tag == 1002) {
        //查看更多优惠券
        NSArray *OrderSpecialOfferList = self.checkData[@"OrderSpecialOfferList"];
        
        if (OrderSpecialOfferList.count > 0) {
            
            self.showView.hidden = YES;
            
            DiscountsTableViewController *vc = [[DiscountsTableViewController alloc] init];
            [vc.array addObjectsFromArray:OrderSpecialOfferList];
            
            WEAKSELF
            
            vc.chooseDataBlock = ^(NSDictionary *obj) {
                
                //展示视图
                weakSelf.showView.hidden = NO;
                
                //优惠券ID
                NSString *Id = [obj stringWithKey:@"specialOfferId"];
                [weakSelf priceWithId:Id dictionary:obj];
            };
            [self pushToVC:vc];
        }
        
    }else{
        //查看运力公司
        NSArray *relationLineOrgFreight = self.checkData[@"relationLineOrgFreight"];
        
        if (relationLineOrgFreight.count > 0) {
            
            //隐藏视图
            self.showView.hidden = YES;
            
            HaulageOperatorTableViewController *vc = [[HaulageOperatorTableViewController alloc] init];
            [vc.array addObjectsFromArray:relationLineOrgFreight];
            WEAKSELF
            vc.chooseOrgBlock = ^(NSDictionary *obj) {
                
                weakSelf.showView.hidden = NO;

                //获取选择运力
                [weakSelf.request setObject:obj[@"orgId"] forKey:@"capacityId"];
                //花费
                [weakSelf.request setObject:obj[@"cast"] forKey:@"cast"];
                [weakSelf.request setObject:obj[@"pickGoodsPrice"] forKey:@"pickGoodsPrice"];
                
                //获取名称
                NSString *name = [obj stringWithKey:@"orgName"];
                UILabel *label = (UILabel *)[weakSelf.backView viewWithTag:2100];
                label.text = name;
                
                //计算价格
                [weakSelf priceWithId:[weakSelf.request stringWithKey:@"specialOfferId"] dictionary:nil];
            };
            [self pushToVC:vc];
        }
    }
}
//优惠券计算价格
- (void)priceWithId:(NSString *)Id dictionary:(NSDictionary *)data{
    
    if (Id.length == 0) {
        return;
    }
    WEAKSELF
    //计算优惠费用
    [NetRequestManger POST:@"base/orderSpecialOffer/countPrice" params:@{@"specialOfferId":Id,@"cast":[self.request stringWithKey:@"cast"],@"pickGoodsPrice":[self.request stringWithKey:@"pickGoodsPrice"]} success:^(id response) {
        
        //数据转换
        NSDictionary *dictionary = (NSDictionary *)response;
        
        //数据请求值
        BOOL success = [dictionary[@"success"] boolValue];
        
        //判断是否请求成功
        if (success == YES) {
            
            if (data != nil) {
                
                //优惠券
                UILabel *couponLB = (UILabel *)[weakSelf.
                                                backView viewWithTag:1003];
                //时间
                NSString *time = [data stringWithKey:@"specialOfferEndTime"];
                
                if (time.length == 0) {
                    //赋值操作
                    couponLB.text = [data stringWithKey:@"specialOfferName"];
                }else{
                    //赋值操作
                    couponLB.text = [NSString stringWithFormat:@"%@\n截止%@失效",[data stringWithKey:@"specialOfferName"],[NSDate calculateChineseWeek:time]];
                }
                
                
//                //赋值操作
//                couponLB.text = [NSString stringWithFormat:@"%@\n%@",[data stringWithKey:@"specialOfferName"],[data stringWithKey:@"specialOfferEndTime"]];
            }
            
            //记录Id
            [weakSelf.request setObject:Id forKey:@"specialOfferId"];
            
            //费用文本
            UILabel *castLB = (UILabel *)[weakSelf.backView viewWithTag:3010];
            //划线文本
            castLB.attributedText = [NSString changeLineColor:kRedColor string:@"需支付 " change:[NSString stringWithFormat:@" ￥%.2f ",[weakSelf.request[@"cast"] doubleValue]] last:[NSString stringWithFormat:@" %.2f",[dictionary[@"data"] doubleValue]]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
//确认订单
- (void)sureOrder:(UIButton *)button{
    
    WEAKSELF
    [NetRequestManger POST:@"lxzy/order/addOrder" params:self.request success:^(id response) {
        
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
            //隐藏视图
            weakSelf.showView.hidden = YES;

        }else{
            
            [SVProgressHUD showImage:kSetImage(@"fail@2x") status:dictionary[@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)reSetFrameWithDict:(NSDictionary *)dict{
    
    //赋值操作
    [self.checkData setValuesForKeysWithDictionary:dict];
    
    //展示视图
    self.showView.hidden = NO;
    
    //重置frame
    self.backView.frame = CGRectMake(0, kHeight, kWidth,0);
    
    //记录y坐标
    CGFloat y = 0;
    //优惠券集合
    NSArray *OrderSpecialOfferList = dict[@"OrderSpecialOfferList"];
    
    //第一层视图
    UIView *view = (UIView *)[self.backView viewWithTag:1000];
    
    if (OrderSpecialOfferList.count == 0) {
        //隐藏视图
        view.hidden = YES;
        
    }else{
        //隐藏视图
        view.hidden = NO;
        //记录位置
        y = view.v;
        UILabel *value = (UILabel *)[view viewWithTag:1003];
        value.text = @"0元";
        
        //删除优惠券Id
        [self.request removeObjectForKey:@"specialOfferId"];
        
        //优惠券数量
        UILabel *number = (UILabel *)[view viewWithTag:1001];
        number.text = [NSString stringWithFormat:@"选择优惠券(有%ld张可用)",OrderSpecialOfferList.count];
    }

    //合作线路集合
    NSArray *relationLineOrgFreight = dict[@"relationLineOrgFreight"];
    
    //第二层视图
    UIView *orgView = (UIView *)[self.backView viewWithTag:2000];

    //获取对象
    NSDictionary *lineDict;
    if (relationLineOrgFreight.count == 0) {
        //隐藏视图
        orgView.hidden = YES;
        
        //默认线路集合（去第一个默认线路）
        NSArray *LineOrgFreight = dict[@"LineOrgFreight"];
        if (LineOrgFreight.count > 0) {
            //获取第一个对象
            lineDict = [LineOrgFreight firstObject];
        }
        
    }else{
        
        //隐藏视图
        orgView.hidden = NO;
        orgView.frame = CGRectMake(orgView.x, y, orgView.w, orgView.h);
        //记录位置
        y = orgView.v;
        
        //获取第一个对象
        lineDict = [relationLineOrgFreight firstObject];
        
        //标题文本
        UILabel *name = (UILabel *)[orgView viewWithTag:orgView.tag + 100];
        name.text = [lineDict stringWithKey:@"orgName"];
        
        //更多
        UIView *more = (UIView *)[view viewWithTag:orgView.tag + 10];
        if (relationLineOrgFreight.count == 1) {
            more.hidden = YES;
        }else{
            more.hidden = NO;
        }
    }

    //线路及公司Id
    [self.request setObject:lineDict[@"lineOrgId"] forKey:@"productId"];
    [self.request setObject:lineDict[@"priceId"] forKey:@"priceId"];
    [self.request setObject:[lineDict stringWithKey:@"orgId"] forKey:@"capacityId"];
    [self.request setObject:lineDict[@"cast"] forKey:@"cast"];
    [self.request setObject:lineDict[@"pickGoodsPrice"] forKey:@"pickGoodsPrice"];
    
    //第三层视图（价格）
    UIView *priceView = (UIView *)[self.backView viewWithTag:3000];
    priceView.frame = CGRectMake(priceView.x, y, priceView.w, priceView.h);
    
    //价格文本
    UILabel *label = (UILabel *)[priceView viewWithTag:priceView.tag+10];
    label.text = [NSString stringWithFormat:@"%.2f",[lineDict stringWithKey:@"cast"].doubleValue];
    
    //第四层视图（时间）
    UIView *timeView = (UIView *)[self.backView viewWithTag:4000];
    timeView.frame = CGRectMake(timeView.x,priceView.v, timeView.w, timeView.h);
    
    //几个文本
    UILabel *timeLabel = (UILabel *)[timeView viewWithTag:timeView.tag+10];
    timeLabel.text = [lineDict stringWithKey:@"estimatedTime"];
    
    //按钮
    UIButton *button = (UIButton *)[self.backView viewWithTag:5000];
    button.frame = CGRectMake(button.x,timeView.v, button.w, button.h);
    
    WEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        //重置frame
        weakSelf.backView.frame = CGRectMake(0, kHeight - button.v, kWidth, button.v);
    }];
}

/* * * * * * * * * *
*
* @ 请求参数懒加载
*
* * * * * * * * * */
- (NSMutableDictionary *)request{
    
    if (!_request) {
        
        NSArray *array = @[@"deliveryName",@"deliveryPhone",@"deliveryProvinceId",@"deliveryProvince",@"deliveryCityId",@"deliveryCity",@"deliveryRegionId",@"deliveryRegion",@"deliveryAddress",@"receivingName",@"receivingPhone",@"receivingProvinceId",@"receivingProvince",@"receivingCityId",@"receivingCity",@"receivingRegionId",@"receivingRegion",@"receivingAddress",@"productName",@"weight",@"volume",@"goodsNum",@"theReceipt",@"insured",@"collectionMoney",@"declaredValue",@"capacityId",@"productId"];
        
        _request = [[NSMutableDictionary alloc] init];
        for (NSString *key in array) {
            
            [_request setObject:@"" forKey:key];
        }
        
        [_request setValuesForKeysWithDictionary:self.defValue];
    }
    return _request;
}

/* * * * * * * * * *
 *
 * @发货人信息tag:111
 * @发货人地址tag:112
 * @收货人信息tag:121
 * @收货人地址tag:122
 *
 * * * * * * * * * */

//清除填写信息
- (void)clearInputInfo{
    
    //发货人信息
    UILabel *info = (UILabel *)[self.view viewWithTag:111];
    info.text = @"填写发货人信息(必填)";
    UILabel *address = (UILabel *)[self.view viewWithTag:112];
    address.text = @"填写发货人姓名、电话及具体地址";
    //清除发货人存储信息
    [self.request removeObjectForKey:@"deliveryRegionId"];
    
    //收货货人信息
    UILabel *info1 = (UILabel *)[self.view viewWithTag:121];
    info1.text = @"填写收货人信息(必填)";
    UILabel *address1 = (UILabel *)[self.view viewWithTag:122];
    address1.text = @"填写收货人姓名、电话及具体地址";
    
    //清除收货人存储信息
    [self.request removeObjectForKey:@"receivingRegionId"];

    //名称
    [self.request setObject:@"" forKey:@"productName"];
    
    //件数
    [self.request setObject:@"" forKey:@"goodsNum"];
    
    //体积
    [self.request setObject:@"" forKey:@"volume"];
    //重量
    [self.request setObject:@"" forKey:@"weight"];
    //备注信息为空
    self.remarkLB.text = @"";
    
    //初始值
    [self.request setValuesForKeysWithDictionary:self.defValue];
        
    //刷新数据
    [self.tableView reloadData];

}

//跳转至收发货人页面
- (void)toConsignee:(NSInteger)tag{
    
    ConsigneeTableViewController *vc = [[ConsigneeTableViewController alloc] init];
    
    WEAKSELF
    vc.chooseConsigneeBlock = ^(NSDictionary *data) {
        
        //信息
        UILabel *info;
        //地址
        UILabel *address;
        
        if (tag == 100) {
            
            info = (UILabel *)[weakSelf.view viewWithTag:111];
            
            address = (UILabel *)[weakSelf.view viewWithTag:112];
            
            for (NSString *key in data.allKeys) {
                
                //获取数据
                NSString *value = data[key];
                
                if ([key isEqualToString:@"name"]) {
                    [weakSelf.request setObject:value forKey:@"deliveryName"];
                }else if ([key isEqualToString:@"phone"]){
                    [weakSelf.request setObject:value forKey:@"deliveryPhone"];
                }else if ([key isEqualToString:@"provinceId"]){
                    [weakSelf.request setObject:value forKey:@"deliveryProvinceId"];
                }else if ([key isEqualToString:@"province"]){
                    [weakSelf.request setObject:value forKey:@"deliveryProvince"];
                }else if ([key isEqualToString:@"cityId"]){
                    [weakSelf.request setObject:value forKey:@"deliveryCityId"];
                }else if ([key isEqualToString:@"city"]){
                    [weakSelf.request setObject:value forKey:@"deliveryCity"];
                }else if ([key isEqualToString:@"regionId"]){
                    [weakSelf.request setObject:value forKey:@"deliveryRegionId"];
                }else if ([key isEqualToString:@"region"]){
                    [weakSelf.request setObject:value forKey:@"deliveryRegion"];
                }else if ([key isEqualToString:@"streetId"]){
                    [weakSelf.request setObject:value forKey:@"deliveryStreetId"];
                }else if ([key isEqualToString:@"street"]){
                    [weakSelf.request setObject:value forKey:@"deliveryStreet"];
                }else if ([key isEqualToString:@"addressMsg"]){
                    [weakSelf.request setObject:value forKey:@"deliveryAddress"];
                }
            }
        
        }else{

            info = (UILabel *)[weakSelf.view viewWithTag:121];
            
            address = (UILabel *)[weakSelf.view viewWithTag:122];
            
            for (NSString *key in data.allKeys) {
                
                //获取数据
                NSString *value = data[key];
                
                if ([key isEqualToString:@"name"]) {
                    [weakSelf.request setObject:value forKey:@"receivingName"];
                }else if ([key isEqualToString:@"phone"]){
                    [weakSelf.request setObject:value forKey:@"receivingPhone"];
                }else if ([key isEqualToString:@"provinceId"]){
                    [weakSelf.request setObject:value forKey:@"receivingProvinceId"];
                }else if ([key isEqualToString:@"province"]){
                    [weakSelf.request setObject:value forKey:@"receivingProvince"];
                }else if ([key isEqualToString:@"cityId"]){
                    [weakSelf.request setObject:value forKey:@"receivingCityId"];
                }else if ([key isEqualToString:@"city"]){
                    [weakSelf.request setObject:value forKey:@"receivingCity"];
                }else if ([key isEqualToString:@"regionId"]){
                    [weakSelf.request setObject:value forKey:@"receivingRegionId"];
                }else if ([key isEqualToString:@"region"]){
                    [weakSelf.request setObject:value forKey:@"receivingRegion"];
                }else if ([key isEqualToString:@"streetId"]){
                    [weakSelf.request setObject:value forKey:@"receivingStreetId"];
                }else if ([key isEqualToString:@"street"]){
                    [weakSelf.request setObject:value forKey:@"receivingStreet"];
                }else if ([key isEqualToString:@"addressMsg"]){
                    [weakSelf.request setObject:value forKey:@"receivingAddress"];
                }
                
            }
        }

        //赋值操作
        info.text = [NSString stringWithFormat:@"%@  %@",data[@"name"],data[@"phone"]];
        address.text = [NSString stringWithFormat:@"地址:%@",data[@"address"]];

    };
    
    if (tag == 100) {
        vc.title = @"发货人管理";
    }else{
        vc.title = @"收货人管理";
    }
    
    [self pushToVC:vc];
}
#pragma mark ========   手势点击   ========
- (IBAction)tapLabelInCreate:(UITapGestureRecognizer *)sender {
        
    NSInteger tag = sender.view.tag;
    
    if (tag == 100 || tag == 101) {

        if ([HelperSingle shareSingle].isLogin == NO) {
            
            WEAKSELF
            [self toLogin:^(BOOL response) {
                
                [weakSelf toConsignee:tag];
            }];
            
        }else{
            
            //跳转至收发货人页面
            [self toConsignee:tag];
        }
 
    }else if (tag == 110 || tag == 120){
        
        WriteShipAddressViewController *vc = [[WriteShipAddressViewController alloc] init];
        
        WEAKSELF
        
        vc.writeInfoBlock = ^(NSDictionary *data) {
          
            //信息
            UILabel *info;
            //地址
            UILabel *address;
            
            NSString *prefix = @"delivery";
            
            if (tag == 110) {
                
                //vc.title = @"录入发货人";
                info = (UILabel *)[weakSelf.view viewWithTag:111];
                
                address = (UILabel *)[weakSelf.view viewWithTag:112];
                
            }else{
                
                //vc.title = @"录入收货人";
                info = (UILabel *)[weakSelf.view viewWithTag:121];
                
                address = (UILabel *)[weakSelf.view viewWithTag:122];
                
                prefix = @"receiving";

            }
            
            //发货地址
            for (NSString *key in data.allKeys) {
                
                //获取值
                NSString *value = data[key];
                
                [weakSelf.request setObject:value forKey:[prefix stringByAppendingString:key]];
            }
            //赋值操作
            info.text = [NSString stringWithFormat:@"%@  %@",data[@"Name"],data[@"Phone"]];
            
            address.text = [NSString stringWithFormat:@"地址:%@%@%@%@%@",data[@"Province"],data[@"City"],data[@"Region"],data[@"Street"],data[@"Address"]];
            
        };

        if (tag == 110) {
            
            vc.title = @"录入发货人";
            
        }else{
            
            vc.title = @"录入收货人";
        }
        
        [self pushToVC:vc];
    }
}

#pragma mark ========   创建运单   ========
- (IBAction)createOrder:(UIButton *)sender {

    //获取发站城市ID
    NSString *deliveryRegionId = self.request[@"deliveryRegionId"];
    if (deliveryRegionId.length == 0) {
        [self waringShow:@"请填写发货人信息"];
        return;
    }
    //获取到站城市ID
    NSString *receivingRegionId = self.request[@"receivingRegionId"];
    if (receivingRegionId.length == 0) {
        [self waringShow:@"请填写收货人信息"];
        return;
    }
    //获取货物名称
    NSString *productName = self.request[@"productName"];
    if (productName.length == 0) {
        [self waringShow:@"请填写货物名称"];
        return;
    }
    //获取货物体积
    NSString *volume = self.request[@"volume"];
    if (volume.doubleValue == 0) {
        [self waringShow:@"请填写货物体积"];
        return;
    }

    //获取货物重量
    NSString *weight = self.request[@"weight"];
    if (weight.doubleValue == 0) {
        [self waringShow:@"请填写货物重量"];
        return;
    }
    
    WEAKSELF
/*
 
 deliveryName=1&deliveryPhone=1&deliveryProvinceId=320000&deliveryProvince=江苏&deliveryCityId=320100&deliveryCity=南京市&deliveryRegionId=320106&deliveryRegion=鼓楼区&deliveryStreetId=32010610&deliveryStreet=湖南路街道&deliveryAddress=&receivingName=张&receivingPhone=22&receivingProvinceId=340000&receivingProvince=安徽&receivingCityId=340800&receivingCity=安庆市&receivingRegionId=340881&receivingRegion=桐城市&receivingStreetId=3408811&receivingStreet=金神镇&receivingAddress=&productName=年轻人&weight=3&volume=2&goodsNum=1&theReceipt=0&insured=0&collectionMoney=0&deliveryMethod=0&payMethod=1&pickGoodsMethod=1&declaredValue=0&capacityId=7256051e53664977a835ee224b21f09e&priceId=a70e688649b442dabd0c0c473917aca7&isRule=2&lineUpType=1&lineUpWeightType=0&startUp=0&receiptType=0&goodsMsg=&serviceTypeSl=0&serviceTypeZh=1&serviceTypeXh=0&isTaxes=0&specialOfferId=
 
 */
    [NetRequestManger POST:@"lxzy/order/getLineOrgFreight" params:self.request success:^(id response) {

        //数据转换
        NSDictionary *dictionary = (NSDictionary *)response;

        //数据请求值
        BOOL success = [dictionary[@"success"] boolValue];

        //判断是否请求成功
        if (success == YES) {

            //重新赋值
            [weakSelf reSetFrameWithDict:dictionary[@"data"]];
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



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark ========   视图加载   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"下单"];
    
    [self.view recycleKeyBoardWithDelegate:self];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    if (self.type > 0) {
        
        [self createNavInCreateOrder];
    }
    
    //注册登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearInputInfo) name:@"loginNotification" object:nil];
    
    //注册创单成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearInputInfo) name:@"createSuccess" object:nil];
    
    //标签切换绑定通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBarInCreateOrder:) name:@"tabBarItemChange" object:nil];
    
}

- (void)rightBarButtoonInCreate{
    
    if ([HelperSingle shareSingle].code.length > 0) {
        
        QRCodeViewController *vc = [[QRCodeViewController alloc] init];
        
        vc.data = [HelperSingle shareSingle].code;

        [self.navigationController pushViewController:vc animated:YES];
    }
}

//标签切换绑定通知
- (void)changeBarInCreateOrder:(NSNotification *)info{
    
    NSString *title = (NSString *)info.object;
    
    if ([title isEqualToString:@"下单"]) {
        //滑动到顶部
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

//创建导航栏
- (void)createNavInCreateOrder{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInCreateOrder)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
}


- (void)backInCreateOrder{
    if (self.type == 1) {
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 55 * 4 + 5;
}

//返回cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *identifier = @"CreateCellID";

    CreateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateCell" owner:self options:nil] objectAtIndex:0];
    }

    WEAKSELF
    
    cell.tapChooseBlock = ^(NSInteger index) {

        CreateInputViewController *vc = [[CreateInputViewController alloc] init];
        vc.type = index;
        //赋值操作
        [vc.request setValuesForKeysWithDictionary:weakSelf.request];
        
        vc.dataBlock = ^(NSDictionary *data) {

            //清除可变的附加信息字段数据
            if (index == 2){
                //删除的key
                [weakSelf.request removeObjectsForKeys:@[@"declaredValue",@"startUp",@"lineUpType",@"lineUpWeightType"]];
            }
            
            //赋值操作
            [weakSelf.request setValuesForKeysWithDictionary:data];
            
            //刷新页面
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
        };
        
        if (index == 0){
            vc.title = @"填写货物信息";
        }else if (index == 1){
            vc.title = @"填写服务信息";
        }else if (index == 2){
            vc.title = @"填写附加信息";
        }else if (index == 3){
            vc.title = @"填写其他货物信息";
        }
        //跳转页面
        [weakSelf pushToVC:vc];
    };
    
    //赋值操作
    [cell giveValueWithDict:self.request];
    
    return cell; 
}

#pragma mark ========   备注信息   ========
- (IBAction)remarkMessage:(UITapGestureRecognizer *)sender {
    
    CreateInputViewController *vc = [[CreateInputViewController alloc] init];
    vc.type = 4;
    WEAKSELF
    vc.dataBlock = ^(NSDictionary *data) {
        //赋值备注信息
        weakSelf.remarkLB.text = [data stringWithKey:@"remark"];
        //赋值操作
        [weakSelf.request setValuesForKeysWithDictionary:data];
    };
    //赋值操作
    [vc.request setValuesForKeysWithDictionary:self.request];
    vc.title = @"填写备注信息";
    [self pushToVC:vc];
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
