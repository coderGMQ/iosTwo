//
//  QJPlayDataBase.h
//  数据持久化
//
//  Created by xhl on 16/6/24.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import  <UIKit/UIKit.h>

@interface QJPlayDataBase : NSObject

/*
 * @ 数据库属性
 *
 **/
//@property (nonatomic, strong) FMDatabase *dataBase;

/*
 *
 * @ 单利实例化
 *
 **/
+ (QJPlayDataBase *)shareDataBase;

/*
 *  @ 删除数据库
 *
 */
- (void)deleteDataBase;
//DROP TABLE database_name.table_name;
/*
 *  @ 删除数据库中的某一张表
 *
 */
- (BOOL)deleteTabel:(NSString *)tableName;

/*
 *
 * @ 打开数据库
 *
 **/
- (void)openSqliteWithPaths:(NSString *)paths;

/*
 *
 * @ 关闭数据库
 *
 **/

- (BOOL)closeSqlite;

/*
 *
 * @ 打开数据库
 *
 **/
- (BOOL)openDataBase;

//============================  注意 : ==数据库所有表的主键名称 统一命名为:ID 格式为:TEXT ================

/*
 * @ 数据库建表
 * @ 数据库所有表的主键名称 统一命名为:ID 格式为:TEXT
 * @ tableName:建表名称 field:表字段(主键一并传入，含带括号) 格式: @"ID TEXT Primary Key,SongName TEXT ,SingerName TEXT,SongImage TEXT,Lrcy TEXT,SongUrl TEXT,IsDownLoad TEXT,IsLoved TEXT,File_duration TEXT"
 * @ 返回状态值: @0:初次建表失败  @1:初次建表成功  @2:表已经存在
 *
 **/
- (int)createDataTable:(NSString *)tableName field:(NSString *)field;


/*
 * @ 增加数据
 * @ tableName:传入的表名
 * @ fieldArray:表字段名称数组，第一个元素设置为主键  eg:@[@"ID".@"Name",@"Sex",@"Age"]
 * @ values:各个字段对应的值数组,第一个元素为主键对应的值 eg: @[@"001".@"Tom",@"man",@"25"]
 *
 **/
- (BOOL)addDataToTable:(NSString *)tableName field:(NSArray *)fieldArray values:(NSArray *)values;

/*
 * @ 根据主键删除单条数据
 * @ tableName:表名
 * @ primaryKey:主键的值
 *
 **/
- (BOOL)deleteDataInTable:(NSString *)tableName withPrimaryKey:(NSString *)primaryKey;

/* * * * * * * * * *
 *
 * @根据字段及值来删除数据
 *
 * * * * * * * * * */
- (BOOL)deleteDataForTable:(NSString *)tableName field:(NSString *)field value:(NSString *)value;

/*
 * @ 删除表中所有数据数据
 * @ tableName:表名
 *
 **/
- (BOOL)deleteAllDataInTable:(NSString *)tableName;

/*
 * @ 根据条件执行删除操作
 *
 **/
- (BOOL)deleteMoreDataInTable:(NSString *)tableName condition:(NSString *)condition;

/*
 * @ 根据主键修改数据某一个字段对应的值
 * @ tableName:表名
 * @ fieldName:修改字段名称
 * @ value:字段修改后的新值
 * @ primaryKey:主键
 *
 **/
- (BOOL)updateDataForTable:(NSString *)tableName withFieldName:(NSString *)fieldName newValue:(NSString *)value primaryKey:(NSString *)primaryKey;
/*
 * @ 根据主键修改数据多个字段对应的值
 * @ tableName:表名
 * @ fieldArray:修改字段数组
 * @ values:修改字段后的新值数组
 * @ primaryKey:主键
 *
 **/
- (BOOL)updateDataForTable:(NSString *)tableName fieldArray:(NSArray *)fieldArray newValueArray:(NSArray *)values primaryKey:(NSString *)primaryKey;

/*
 * @ 根据主键查询单条数据
 * @ tableName:数据库表名
 * @ primaryKey:主键对应的值
 * @ fieldArray:查询结果所需返回字段数组
 *
 **/
- (NSDictionary *)selectDataInTable:(NSString *)tableName withPrimaryKey:(NSString *)primaryKey fieldArray:(NSArray *)fieldArray;

/*
 * @ 查找所有数据
 * @ fieldArray:需返回字段数组
 *
 **/
- (NSArray *)selectAllDataInTable:(NSString *)tableName fieldArray:(NSArray *)fieldArray;

/*
 * @ 查找某段范围内的数据
 * @ fieldArray:需返回字段数组
 *
 **/
- (NSArray *)selectAreaDataInTable:(NSString *)tableName fieldArray:(NSArray *)fieldArray page:(NSInteger)page size:(NSInteger)size;

/*
 * @ 根据条件查找数据
 * @ condition:筛选的字段数组
 * @ values:筛选字段对应值得数组
 * @ fieldArray:需返回字段数组
 *
 **/
- (NSArray *)selectMoreDataInTable:(NSString *)tableName condition:(NSArray *)condition values:(NSArray *)values fieldArray:(NSArray *)fieldArray;

/*
 * @ 根据条件查找一条数据数据
 * @ condition:筛选的字段数组
 * @ values:筛选字段对应值得数组
 * @ fieldArray:需返回字段数组
 *
 **/
- (NSDictionary *)selectOneDataInTable:(NSString *)tableName condition:(NSArray *)condition values:(NSArray *)values fieldArray:(NSArray *)fieldArray;

/*
 * @ 根绝某字段的值查询数据数据
 * @ fieldArray:需返回字段数组
 *
 **/
- (NSArray *)selectDataInTable:(NSString *)tableName field:(NSString *)field value:(NSString *)value fieldArray:(NSArray *)fieldArray;

/*
 * @ 根据主键查询是否存在该条数据
 * @ tableName:表名
 * @ primaryKey:主键
 *
 */
- (BOOL)isInTable:(NSString *)tableName withPrimaryKey:(NSString *)primaryKey;

/*
 * @ 根据表的名称判断表是否存在
 * @ tableName:表名
 *
 */
- (BOOL)isTableOK:(NSString *)tableName;

@end
