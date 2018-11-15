//
//  ServeCollectionViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/2.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "ServeCollectionViewController.h"

#import "ServeDetailsCollectionViewController.h"

@interface ServeCollectionViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

//数据集合
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation ServeCollectionViewController

static NSString * const reuseIdentifier = @"PictureCollectionViewCellID";

//初始化
- (instancetype)init{
    
    NSInteger itemsCount = 3;
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

/* * * * * * * * * *
 *
 * @ 懒加载数据集合
 *
 * * * * * * * * * */
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] initWithArray:@[@{@"pic":@"daishou@2x",@"title":@"代收货款"},
                            @{@"pic":@"qiandanhuishou@2x",@"title":@"签收回单"},
                            @{@"pic":@"duanxintongzhi@2x",@"title":@"短信通知"},
                            @{@"pic":@"baoxianbaozhang@2x",@"title":@"保险保障"},
                            @{@"pic":@"jinrongchanping@2x",@"title":@"金融产品"},
                            @{@"pic":@"zhuangbeiwuliu@2x",@"title":@"物流装备"}]];
    }
    
    return _dataArray;
}
#pragma mark ========   视图加载   ========
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;

    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.collectionView.backgroundColor = kLikeColor;
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:@"服务项目"];
    [self createNavInServe];
    
    // Register cell classes
    [self.collectionView registerClass:[PictureCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
//    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PictureCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

//创建导航栏
- (void)createNavInServe{
    
    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInServe)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;
    
}
//左侧返回按钮点击事件
- (void)backInServe{
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataArray.count;
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
    
    
    
    ServeDetailsCollectionViewController *vc = [[ServeDetailsCollectionViewController alloc] init];
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    vc.title = dict[@"title"];
    [self.navigationController pushViewController:vc animated:YES];
    
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
