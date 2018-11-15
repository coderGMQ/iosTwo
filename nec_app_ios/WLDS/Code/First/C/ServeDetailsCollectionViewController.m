
//
//  ServeDetailsCollectionViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/3.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "ServeDetailsCollectionViewController.h"

#import "CargoTrackingViewController.h"

#import "AgingViewController.h"

#import "ServeDetailsCollectionReusableView.h"

#import "MineViewController.h"

@interface ServeDetailsCollectionViewController ()

//数据集合
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation ServeDetailsCollectionViewController

static NSString * const reuseIdentifier = @"PictureCollectionViewCellID";

static NSString * const topReuseIdentifier = @"topView";

/* * * * * * * * * *
 *
 * @
 *
 * * * * * * * * * */

//获取描述
- (NSString *)gainDescription{
    
    if ([self.title isEqualToString:@"代收货款"]) {
        
        return @"按照寄件客户(卖方)与收件客户(买方)达成协议的要求，为寄件方承运、配送物品，在承诺的退款时效内将货款汇出，让您安全、及时地回笼资金。";
        
    }else if ([self.title isEqualToString:@"签收回单"]) {
        
        return @"在您的货物正常签收后，为您提供签收单返还的服务。";
    }else if ([self.title isEqualToString:@"短信通知"]) {
        
        return @"短信实时通知，物流变动信息。";
    }else if ([self.title isEqualToString:@"保险保障"]) {
        
        return @"保险既是保障，也是投资，更是一项重要的人生规划。";
    }else if ([self.title isEqualToString:@"金融产品"]) {
        
        return @"金融是货币流通和信用活动以及与之相联系。";
    }else if ([self.title isEqualToString:@"物流装备"]) {
        
        return @"整个物流领域内用于各个环节的设备和器材。";
    }
    
    return @"";
}

//选项标题集合加载
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] initWithArray:@[@{@"pic":@"yundangenzong@2x",@"title":@"运单跟踪"},
                                                             @{@"pic":@"zaixianxiadan@2x",@"title":@"在线下单"},
                                                             @{@"pic":@"shixiaochaxun@2x",@"title":@"时效查询"},
                                                             @{@"pic":@"wodezhanghao@2x",@"title":@"我的账号"}]];
    }
    
    return _dataArray;
}

//初始化
- (instancetype)init{
    
    NSInteger itemsCount = 4;
    //创建一个布局对象 (瀑布流)
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置集合视图行间距Line Spacing:行间距 (上下之间的间距)
    layout.minimumLineSpacing = 0.5;
    // 设置集合视图 每个item之间的间隔
    layout.minimumInteritemSpacing = 0.5;
    
    //计算高度
    CGFloat width = (kWidth - 2 * 1  - layout.minimumInteritemSpacing * itemsCount)/itemsCount;
    
    layout.itemSize = CGSizeMake(width,width * 1.2);
    layout.sectionInset = UIEdgeInsetsMake(2,1,0,1);
    
    return [super initWithCollectionViewLayout:layout];
}


#pragma mark ========   视图加载   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.collectionView.backgroundColor = kLikeColor;
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:self.title];
    [self createNavInServeDetails];
    
    // Register cell classes
    [self.collectionView registerClass:[PictureCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView registerClass:[ServeDetailsCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:topReuseIdentifier];
    
    // Do any additional setup after loading the view.
}

//创建导航栏
- (void)createNavInServeDetails{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInServeDetails)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}
//左侧返回按钮点击事件
- (void)backInServeDetails{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    NSString *title = [self gainDescription];
    

    CGFloat w = 0;
    
    if (title.length > 0) {
        
        w = [title gainHeightWithFont:kFontSize(kFitW(15)) width:kWidth - kFitW(20)] + kFitW(50 + 10);
    }
    
    
    return  CGSizeMake(kWidth,w);
    
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *title = [self gainDescription];
    
    if (title.length > 0) {
        
        ServeDetailsCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:topReuseIdentifier forIndexPath:indexPath];
        
        reusableView.title.text = self.title;
        
        [reusableView.content fitHeightWithX:reusableView.content.x Y:reusableView.content.y width:reusableView.content.w font:reusableView.content.font Text:title];
        
        return reusableView;
        
    }else{
        
        return nil;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.title.text = dict[@"title"];
    
    NSString *name =dict[@"pic"];
    
    cell.picIV.image = kSetImage(name);
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PictureCollectionViewCell *cell = (PictureCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([cell.title.text isEqualToString:@"运单跟踪"]) {

        CargoTrackingViewController *vc = [[CargoTrackingViewController alloc] init];
        
        if ([HelperSingle shareSingle].isLogin == NO) {
            
            WEAKSELF
            [self toLogin:^(BOOL response) {

                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            
        }else{

            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if ([cell.title.text isEqualToString:@"在线下单"]){
        
        CreateOrderViewController *vc = [[CreateOrderViewController alloc] init];
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.title.text isEqualToString:@"时效查询"]){
        
        //价格时效
        AgingViewController *vc = [[AgingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.title.text isEqualToString:@"我的账号"]){
        
        MineViewController *vc = [[MineViewController alloc] init];
        vc.back = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
 return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 
 }
 */

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
