
//
//  CustomViewController.m
//  BNZY
//
//  Created by zhiyundaohe on 2017/12/16.
//  Copyright © 2017年 zhiyundaohe. All rights reserved.
//

#import "CustomViewController.h"


@interface CustomViewController ()<UIGestureRecognizerDelegate>


//分页数位置
@property (nonatomic) NSInteger page;

@property (nonatomic) BOOL tap;


@end

@implementation CustomViewController

- (void)setRecycle:(BOOL)recycle{
    
    if (_recycle != recycle) {
        
        _recycle = recycle;

        if (self.tap == NO && recycle == YES) {

            //手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(packUpInController)];

            tap.delegate = self;
            
            [self.view addGestureRecognizer:tap];
            
//            //创建手势
//            [self.view recycleKeyBoardWithDelegate:self];
            
            self.tap = YES;
        }
    }
}

//执行手势
- (void)packUpInController{
    
    
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
/* * * * * * * * * *
 *
 * @ 导航栏控制器前置视图
 *
 * * * * * * * * * */
- (UIView *)brontView{
    
    if (!_brontView) {
        
        _brontView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kWidth, kHeight)];
        _brontView.backgroundColor = kWindowColor;
        [self.navigationController.view addSubview:_brontView];
        [self.navigationController.view bringSubviewToFront:_brontView];

        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBrontView)];
        [_brontView addGestureRecognizer:tap];
    }
    
    return _brontView;
}

//前置视图手势添加
- (void)tapBrontView{
    
    kKeyBoardHiden;
    //隐藏视图
    self.brontView.hidden = YES;
}

/* * * * * * * * * *
 *
 * @ 懒加载数据集合
 *
 * * * * * * * * * */
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

/* * * * * * * * * *
 *
 * @ 懒加载数据字典
 *
 * * * * * * * * * */
- (NSMutableDictionary *)dictData{
    
    if (!_dictData) {
        
        _dictData   = [[NSMutableDictionary alloc] init];
        
    }
    return _dictData;
}

/* * * * * * * * * *
 *
 * @ 懒加载数据请求参数字典
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
 * @ 懒加载表视图
 *
 * * * * * * * * * */
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - NAV_HEIGHT)style:(UITableViewStyleGrouped)];
        _tableView.separatorStyle = 0;
//        _tableView.showsVerticalScrollIndicator = NO;
        
        //【iOS 11 系统】 解决分组样式顶部视图和分区留白问题
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.1)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.1)];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

//重写setter
- (void)setStyle:(VCStyle)style{
    
    if (_style != style) {
        
        _style = style;
        
        
        if (style > 1) {
            
            //默认分页数据，以1开始，总页数为1，单页数据量为10，总数数据需要计算
            self.page = 1;
            self.totle = 1;
            self.limit = 10;
        }
        
        switch (style) {
                
                //判断使用样式
            case VCStyleNone:{
                    
                self.tableView.bounces = NO;
            }
                break;
            case VCStyleRefresh:{
                
                [self.tableView createRefreshWithTarget:self action:@selector(refreshInRefrsh)];
            }
                break;
            case VCStyleLoad:{
                
                 [self.tableView createLoadingWithTarget:self action:@selector(loadInCustom)];
            }
                break;
            case VCStyleBoth:{
                
                [self.tableView createHeaderAction:@selector(refreshInRefrsh) footerAction:@selector(loadInCustom) target:self];
            }
                break;
                
            default:
                break;
        }
    }
}

//视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kLikeColor;

    //底部素线隐藏（组合使用）
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:self.title];
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInRefresh)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
}

//返回上一页面
- (void)backInRefresh{
    
    //是否执行返回的block
    if (self.backBlock) {
        
        self.backBlock();
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)refreshInRefrsh{
    
    //默认从第一页数据开始
    self.page = 1;
    
    //执行刷新
    if (_delegate && [_delegate respondsToSelector:@selector(refreshDataInCustom)]) {
        
        [_delegate refreshDataInCustom];
    }

}

- (void)loadInCustom{
    
    //页数判断
    if (self.page < self.totle) {
        
        //获取当前展示视图
        self.tableView.footerRefreshingText = @"加载数据";
        
        self.page = self.page + 1;
        
    }else {
        
        //获取当前展示视图
        self.tableView.footerRefreshingText = @"暂无更多数据";
        
        WEAKSELF
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //结束刷新状态
            [weakSelf.tableView footerEndRefreshing];
            
        });
        
        //结束返回
        return;
    }

    //执行加载
    if (_delegate && [_delegate respondsToSelector:@selector(loadDataDataInCustom:)]) {
        
        [_delegate loadDataDataInCustom:self.page];
    }

}

#pragma mark ========   刷新和加载代理同时设置   ========
- (void)setDelegate:(id<CustomViewControllerDelegate>)delegate{
    
    if (_delegate != delegate) {
        
        _delegate = delegate;
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
