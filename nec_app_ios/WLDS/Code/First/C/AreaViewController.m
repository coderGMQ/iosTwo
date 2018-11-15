//
//  AreaViewController.m
//  WLDS
//
//  Created by zhiyundaohe on 2018/4/25.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import "AreaViewController.h"

#import "WriteModel.h"

@interface AreaViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//字典数据
@property (nonatomic,strong) NSMutableDictionary *dict;

//关键字
@property (nonatomic,strong) NSArray *keys;


@end

@implementation AreaViewController


/* * * * * * * * * *
 *
 * @ 懒加载字典
 *
 * * * * * * * * * */
- (NSMutableDictionary *)dict{

    if (!_dict) {

        _dict = [[NSMutableDictionary alloc] init];
    }

    return _dict;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置标题
    [self setFont:kTitFont color:kWhiteColor title:self.title];

    [self createNavInArea];

    //获取数据
    [self gainDataInArea];
}

#pragma mark ========   查询数据   ========
- (void)gainDataInArea{

    if (self.Id.length == 0) {
        self.Id = @"";
    }

    WEAKSELF
    [NetRequestManger POST:@"base/sysCity/selectCityById" params:@{@"id":self.Id} success:^(id response) {

        //数据转换
        NSDictionary *dictionary = (NSDictionary *)response;

        //数据请求值
        BOOL success = [dictionary[@"success"] boolValue];

        //判断是否请求成功
        if (success == YES) {

            NSDictionary *data = dictionary[@"data"];

            //移除所有数据兑现
            [weakSelf.dict removeAllObjects];

            //数据
            for (NSDictionary *obj in data[@"items"]) {

                //提取首字母
                NSString *key = [NSString firstCharactor:obj[@"areaname"]];

                NSMutableArray *array = self.dict[key];

                WriteModel *model = [WriteModel shareWriteModelWithDictionary:obj];

                if (array == nil) {

                    array = [[NSMutableArray alloc] initWithObjects:model, nil];

                    [weakSelf.dict setObject:array forKey:key];

                }else{

                    [array addObject:model];
                }
            }
            //添加数据字段
            weakSelf.keys = [weakSelf.dict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){

                return [obj1 compare:obj2 options:NSNumericSearch];

            }];

            //刷新数据
            [weakSelf.tableView reloadData];

        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];

}

//创建导航栏
- (void)createNavInArea{

    //左侧返回按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:kSetImage(@"back@2x") style:(UIBarButtonItemStyleDone) target:self action:@selector(backInArea)];
    self.navigationItem.leftBarButtonItem = leftBar;
    leftBar.tintColor = kWhiteColor;

}

//左侧返回按钮点击事件
- (void)backInArea{

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ========   UITableViewDataSource/UITableViewDelegate   ========
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.keys.count;  //返回26个字母
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSArray *array = [self.dict objectForKey:[self.keys objectAtIndex:section]];

    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return kFitW(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ID = @"cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }

    NSArray *array = [self.dict objectForKey:[self.keys objectAtIndex:indexPath.section]];
    //数据展示
    WriteModel *model = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = model.areaname;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return kFitW(40);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kFitW(40))];
    view.backgroundColor = kWhiteColor;

    //文本
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kFitW(20), 0, kWidth - kFitW(20 *2),view.h - 1.0)];
    [view addSubview:label];
    label.font = kFontSize(kFitW(15));
    label.textColor = kMainColor;
    label.text = [self.keys objectAtIndex:section];

    //细线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, label.v, kWidth, 1.0)];
    line.backgroundColor = kLikeColor;
    [view addSubview:line];

    return view;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{

    return self.keys;  //返回26个字母
}

//表尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    return nil;
}
//表尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.chooseAreaBlock) {

        NSArray *array = [self.dict objectForKey:[self.keys objectAtIndex:indexPath.section]];
        //数据展示
        WriteModel *model = [array objectAtIndex:indexPath.row];

        //数据展示
        self.chooseAreaBlock(model.areaname,[NSString stringWithFormat:@"%@",model.Id]);
        [self.navigationController popViewControllerAnimated:YES];
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
