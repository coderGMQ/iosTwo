//
//  QJPlayDataBase.m
//  数据持久化
//
//  Created by xhl on 16/6/24.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import "QJPlayDataBase.h"

//不可变常量字符串（数据库文件名称）
NSString *const sqlite_path = @"BQBusiness.sqlite";

static QJPlayDataBase *playDataBase;

@interface QJPlayDataBase ()
{
    FMDatabase *dataBase;
}

@end

@implementation QJPlayDataBase

+(QJPlayDataBase *)shareDataBase
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        playDataBase = [[QJPlayDataBase alloc] init];
    });
    
    return playDataBase;
}

/*
 *
 * @ 数据库懒加载
 *
 **/

/*
 *  @ 删除数据库
 *
 */
- (void)deleteDataBase
{
    
    if ([self isFileExist:sqlite_path]) {
        
        //本地文件管理
        NSFileManager * fileManager = [[NSFileManager alloc]init];
      
        BOOL isSuccess = [fileManager removeItemAtPath:[self getSqlitePaths] error:nil];
        
        if (isSuccess) {
            
//            NSLog(@" === 删除数据库成功 === ");
        }else
        {
//            NSLog(@" === 删除数据库失败 === ");
        }
        
    }else
    {
//        NSLog(@" === 当前不存在该数据库路径 === ");
    }
}

/*
 * @ fileName：文件名称
 *
 * @ 根据沙盒路径判断沙盒是否存在某一文件
 *
 * @ 当前是根据数据库路径，来判断是否存在数据库
 *
 **/
-(BOOL) isFileExist:(NSString *)fileName
{

    //文件路径
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    return [fileManager fileExistsAtPath:filePath];
}

/*
 *  @ 删除数据库中的某一张表
 *
 */
- (BOOL)deleteTabel:(NSString *)tableName
{
    BOOL isSuccess = NO;
    
    //判断是数据库是否存在
    if (!dataBase) {
        
        [self openSqliteWithPaths:sqlite_path];
    }
    
    if ([dataBase open]) {
        
        //建表语句
        NSString * sql =[NSString stringWithFormat:@"DROP TABLE %@",tableName];
        
        //执行建表语句，并更新
        isSuccess  = [dataBase executeUpdate:sql];
        
//        if (isSuccess == YES) {
//            
//            NSLog(@" =======  移除【%@】表成功  ======",tableName);
//        }else
//        {
//            NSLog(@" =======  移除【%@】表失败  ======",tableName);
//        }
        
    }
    
    return isSuccess;
}

/*
 *
 * @ 获取数据库路径
 *
 **/
- (NSString *)getSqlitePaths
{
    NSString *str = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:sqlite_path];
    
    NSLog(@" ==== 数据库路径 ====  %@",str);
    return str;
}

/*
 *
 * @ 打开数据库
 *
 **/
- (void)openSqliteWithPaths:(NSString *)paths
{
    dataBase = [FMDatabase databaseWithPath:[self getSqlitePaths]];
}

/*
 *
 * @ 关闭数据
 *
 **/
- (BOOL)closeSqlite
{
    return  [dataBase close];
}

/*
 *
 * @ 打开数据库
 *
 **/
- (BOOL)openDataBase
{
    return [dataBase open];
}

//============================  注意 : ==数据库所有表的主键名称 统一命名为:ID 格式为:TEXT ================
/*
 * @ 数据库建表
 * @ 数据库所有表的主键名称 统一命名为:ID 格式为:TEXT
 * @ tableName:建表名称 field:表字段(主键一并传入，含带括号) 格式: @"ID TEXT Primary Key,SongName TEXT ,SingerName TEXT,SongImage TEXT,Lrcy TEXT,SongUrl TEXT,IsDownLoad TEXT,IsLoved TEXT,File_duration TEXT"
 * @ 返回状态值: @0:初次建表失败  @1:初次建表成功  @2:表已经存在
 *
 **/
- (int)createDataTable:(NSString *)tableName field:(NSString *)field
{
    //判断是数据库是否存在
    if (!dataBase) {
        
        [self openSqliteWithPaths:sqlite_path];
    }
    //返回值初始值为0
    int backValue = 0;
    
    if ([dataBase open]) {
        
        if ([self isTableOK:tableName]) {
            //表已经存在
            backValue = 2;
//            NSLog(@" =======   【%@】表已经存在了  ======",tableName);
        }else{
            
            //建表语句
            NSString * sql =[NSString stringWithFormat:@"CREATE TABLE %@ %@",tableName,field];
            
            //执行建表语句，并更新
            BOOL  executeUpdate  = [dataBase executeUpdate:sql];
            
            if (executeUpdate == YES) {
                //初次建表成功
                backValue = 1;
//                NSLog(@" =======   初次【%@】表成功  ======",tableName);
            }else
            {
                //初次建表失败
                backValue = 0;
//                NSLog(@" =======  初次建【%@】表失败  ======",tableName);
            }
            
        }
    }
    
    return backValue;
}



//##################### ====== 数据库的增删改查 ====== #####################

/*
 * @ 增加数据
 * @ tableName:传入的表名
 * @ fieldArray:表字段名称数组，第一个元素设置为主键  eg:@[@"ID".@"Name",@"Sex",@"Age"]
 * @ values:各个字段对应的值数组,第一个元素为主键对应的值 eg: @[@"001".@"Tom",@"man",@"25"]
 *
 **/

- (BOOL)addDataToTable:(NSString *)tableName field:(NSArray *)fieldArray values:(NSArray *)values
{
    
    BOOL dataStatus = NO;
    
    if (fieldArray.count == 0 || values.count == 0) {
        NSLog(@" ==== 增添数据 model为空 ==== ");
        return NO;
    }
    
    if (!dataBase) {
        dataBase = [FMDatabase databaseWithPath:[self getSqlitePaths]];
    }
    
    if ([dataBase open]) {
        
        //数据库表结构(数组第一个元素为主键)
        NSString *field = @"";
        //插入数据的样式（例如:Name,Sex,Age)
        NSString *insertFiled;
        
        //便利传入数据库表结构的字段数组（全部构建为TEXT类型),构建表结构,已经插入数据
        for (int i = 0; i < fieldArray.count; i++) {
            
            if (i == 0) {
                
                field = [NSString stringWithFormat:@"%@ TEXT PRIMARY KEY",[fieldArray objectAtIndex:0]];
                
                insertFiled = [fieldArray objectAtIndex:0];
                
            }else
            {
                field = [NSString stringWithFormat:@"%@,%@ TEXT",field,[fieldArray objectAtIndex:i]];
                
                insertFiled = [NSString stringWithFormat:@"%@,%@",insertFiled,[fieldArray objectAtIndex:i]];
            }
        }
        
        //根据范例最终传入的表字段结构为（ID TEXT PRIMARY KEY,Name TEXT,Sex TEXT,Age TEXT）
        //建数据库表
        [self createDataTable:tableName field:[NSString stringWithFormat:@"(%@)",field]];
        
        //字典中取出主键的值
        NSString *primaryKey = [fieldArray firstObject];
        
        if ([self isInTable:tableName withPrimaryKey:primaryKey] == NO) {
            
            NSString *insertValue = [NSString stringWithFormat:@"'%@'",primaryKey];
            
            for (int i = 0; i < values.count; i++) {
                
                if (i == 0) {
                    
                    insertValue = [NSString stringWithFormat:@"'%@'",[values objectAtIndex:0]];
                }else{
                    
                    insertValue = [NSString stringWithFormat:@"%@,'%@'",insertValue,[values objectAtIndex:i]];
                }
                
            }
            
            //插入语句
            NSString *sql = [NSString stringWithFormat:@"insert into  %@(%@) values(%@)",tableName,insertFiled,insertValue];
            //执行插入语句，并更新
            BOOL insertModel = [dataBase executeUpdate:sql];
            
            if (insertModel) {
                
                NSLog(@" =====  向【%@】表中添加数据成功 ===== ",tableName);
                dataStatus = YES;
                
            }else{
                NSLog(@" =====  向【%@】表中添加数据失败 ===== ",tableName);
                dataStatus = NO;
            }
            
        }
        //关闭数据库
        [self closeSqlite];
    }
    
    return dataStatus;
}

/*
 * @ 根据主键删除单条数据
 * @ tableName:表名
 * @ primaryKey:主键的值
 *
 **/
- (BOOL)deleteDataInTable:(NSString *)tableName withPrimaryKey:(NSString *)primaryKey
{
    BOOL isSuccess = NO;
    
    if (!dataBase) {
        dataBase = [FMDatabase databaseWithPath:[self getSqlitePaths]];
    }
    if ([dataBase open]) {
        
        //删除语句
        NSString *sql  = [NSString stringWithFormat:@"delete from %@ where ID = '%@'",tableName,primaryKey];
        //执行删除语句，并更新
        isSuccess = [dataBase executeUpdate:sql];
        
        //关闭数据库
        [self closeSqlite];
    }
    
//    if (isSuccess == YES) {
//        NSLog(@"  ==== 从【%@】表中 删除主键为【%@】的数据成功  ====  ",tableName,primaryKey);
//    }else{
//        NSLog(@"  ====  从【%@】表中删除主键为【%@】的数据失败  ====  ",tableName,primaryKey);
//    }
    
    return isSuccess;
}

/*
 * @ 删除表中所有数据数据
 * @ tableName:表名
 *
 **/
- (BOOL)deleteAllDataInTable:(NSString *)tableName
{
    BOOL isSuccess = NO;
    
    if (!dataBase) {
        dataBase = [FMDatabase databaseWithPath:[self getSqlitePaths]];
    }
    if ([dataBase open]) {
        
        NSString *sql = [NSString stringWithFormat:@"delete from %@",tableName];
        
        //执行删除语句
        isSuccess = [dataBase executeUpdate:sql];
        
        //关闭数据库
        [self closeSqlite];
        
    }
    
    if (isSuccess) {
//        NSLog(@"  ====  删除【%@】表中的所有数据成功  ====  ",tableName);
    }else{
//        NSLog(@"  ====  删除【%@】表中的所有数据失败  ====  ",tableName);
    }

    return isSuccess;
}

/*
 * @ 根据sql语句执行删除操作
 *
 **/
- (BOOL)deleteMoreDataInTable:(NSString *)tableName condition:(NSString *)conditionl
{
    BOOL isSuccess = NO;
    
    if (!dataBase) {
        dataBase = [FMDatabase databaseWithPath:[self getSqlitePaths]];
    }
    if ([dataBase open]) {
        
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@",tableName,conditionl];
        
        //执行删除语句
        isSuccess = [dataBase executeUpdate:sql];
        
        //关闭数据库
        [self closeSqlite];
        
    }
    
//    if (isSuccess) {
//        NSLog(@"  == 按条件 ==  删除【%@】表中的所有数据成功  ====  ",tableName);
//    }else{
//        NSLog(@"  ==  按条件 ==  删除【%@】表中的所有数据失败  ====  ",tableName);
//    }
    
    return isSuccess;
}

/* * * * * * * * * *
 *
 * @根据字段及值来删除数据
 *
 * * * * * * * * * */
- (BOOL)deleteDataForTable:(NSString *)tableName field:(NSString *)field value:(NSString *)value{
    
    BOOL isSuccess = NO;
    
    if (!dataBase) {
        dataBase = [FMDatabase databaseWithPath:[self getSqlitePaths]];
    }
    if ([dataBase open]) {
        
        //[db executeUpdate:@"DELETE FROM User WHERE Name = ?",@"Jeffery"];
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ = %@ ?",tableName,field,value];
        
        //执行删除语句
        isSuccess = [dataBase executeUpdate:sql];
        
        //关闭数据库
        [self closeSqlite];
        
    }
    
    if (isSuccess) {
        NSLog(@"  == 按条件 ==  删除【%@】表中的所有数据成功  ====  ",tableName);
    }else{
        NSLog(@"  ==  按条件 ==  删除【%@】表中的所有数据失败  ====  ",tableName);
    }
    
    return isSuccess;
}

/*
 * @ 根据主键修改数据某一个字段对应的值
 * @ tableName:表名
 * @ fieldName:修改字段名称
 * @ value:字段修改后的新值
 * @ primaryKey:主键
 *
 **/
- (BOOL)updateDataForTable:(NSString *)tableName withFieldName:(NSString *)fieldName newValue:(NSString *)value primaryKey:(NSString *)primaryKey
{
    
    BOOL isSuccess = NO;
    
    if (!dataBase) {
        dataBase = [FMDatabase databaseWithPath:[self getSqlitePaths]];
    }
    
    if ([dataBase open]) {
        
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@='%@' where ID='%@'",tableName,fieldName,value,primaryKey];
        
        BOOL res = [dataBase executeUpdate:updateSql];
        
        if (!res) {
//            NSLog(@"  ====  修改【%@】数据失败 === ",tableName);
            isSuccess = NO;
        } else {
//            NSLog(@"  ====  修改【%@】数据成功 === ",tableName);
            isSuccess = YES;
        }
        
        [self closeSqlite];
        
    }
    
    return isSuccess;
}

/*
 * @ 根据主键修改数据多个字段对应的值
 * @ tableName:表名
 * @ fieldArray:修改字段数组
 * @ values:修改字段后的新值数组
 * @ primaryKey:主键
 *
 **/
- (BOOL)updateDataForTable:(NSString *)tableName fieldArray:(NSArray *)fieldArray newValueArray:(NSArray *)values primaryKey:(NSString *)primaryKey
{
    BOOL isSuccess = NO;
    
    if (!dataBase) {
        dataBase = [FMDatabase databaseWithPath:[self getSqlitePaths]];
    }
    
    if ([dataBase open]) {
        
        NSString *set = @"set";
        
        for (int i = 0; i < fieldArray.count; i++) {
            
            NSString *key = [fieldArray objectAtIndex:i];
            
            NSString *needStr = [values objectAtIndex:i];
            
            if (i == 0) {
                
                set = [NSString stringWithFormat:@"%@ %@='%@'",set,key,needStr];
            }else
            {
                set = [NSString stringWithFormat:@"%@ ,%@='%@'",set,key,needStr];
            }
            
        }
        
        //执行修改数据语句
        NSString *updateSql = [NSString stringWithFormat:@"update %@ %@ where ID='%@'",tableName,set,primaryKey];
        
        BOOL res = [dataBase executeUpdate:updateSql];
        
        if (!res) {
//            NSLog(@"  ====  修改【%@】数据失败 === ",tableName);
            isSuccess = NO;
        } else {
//            NSLog(@"  ====  修改【%@】数据成功 === ",tableName);
            isSuccess = YES;
        }
        
        [self closeSqlite];
        
    }
    
    return isSuccess;
}
/*
 * @ 根据主键查询单条数据
 * @ tableName:数据库表名
 * @ primaryKey:主键对应的值
 * @ fieldArray:查询结果所需返回字段数组
 *
 **/
- (NSDictionary *)selectDataInTable:(NSString *)tableName withPrimaryKey:(NSString *)primaryKey fieldArray:(NSArray *)fieldArray
{
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    
    if (!dataBase) {
        dataBase = [FMDatabase databaseWithPath:[self getSqlitePaths]];
    }
    if ([dataBase open]) {
        
        if ([self isTableOK:tableName]) {
            
            NSString *sql = [NSString stringWithFormat:@"select *from %@ where ID = '%@'",tableName,primaryKey];
            
            FMResultSet *rs = [dataBase executeQuery:sql];
            
            while ([rs next]) {
                
                for (NSString *key in fieldArray) {
                    
                    NSString *value = [rs stringForColumn:key];
                    
                    [resultDict setObject:value forKey:key];
                    
                }
            }
            
        }else{
//            NSLog(@" === 查询【%@】表不存在 === ",tableName);
        }
        
        //关闭数据库
        [self closeSqlite];
    }
    
    return resultDict;
}

/*
 * @ 根据条件查找数据
 * @ condition:筛选的字段数组
 * @ values:筛选字段对应值得数组
 * @ fieldArray:需返回字段数组
 *
 **/
- (NSArray *)selectMoreDataInTable:(NSString *)tableName condition:(NSArray *)condition values:(NSArray *)values fieldArray:(NSArray *)fieldArray
{
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    
    if (!dataBase) {
        dataBase = [FMDatabase databaseWithPath:[self getSqlitePaths]];
    }
    
    if ([dataBase open]) {
        
        if ([self isTableOK:tableName]) {
            
            NSString *where = @"where";
            
            for (int i = 0; i < condition.count; i++) {
                
                NSString *key = [condition objectAtIndex:i];
                NSString *needStr = [values objectAtIndex:i];
                
                if (i == 0) {
                    
                    where = [NSString stringWithFormat:@"%@ %@ = '%@'",where,key,needStr];
                }else
                {
                    where = [NSString stringWithFormat:@"%@ and %@ = '%@'",where,key,needStr];
                }
                
            }
            
            //拼接查询语句字符串
            NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@ %@",tableName,where];
            
            FMResultSet *rs = [dataBase executeQuery:sql];
            
            while ([rs next]) {
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                
                for (NSString *key in fieldArray) {
                    
                    NSString *value = [rs stringForColumn:key];
                    
                    [dict setObject:value forKey:key];
                    
                }
                
                [dataArr addObject:dict];
                
            }
            
        }else
        {
//            NSLog(@" === 查询【%@】表不存在 === ",tableName);
        }
        
        //关闭数据库
        [self closeSqlite];
        
    }
    
    return dataArr;
}


/*
 * @ 根据条件查找一条数据数据
 * @ condition:筛选的字段数组
 * @ values:筛选字段对应值得数组
 * @ fieldArray:需返回字段数组
 *
 **/
- (NSDictionary *)selectOneDataInTable:(NSString *)tableName condition:(NSArray *)condition values:(NSArray *)values fieldArray:(NSArray *)fieldArray
{
    //对象
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (!dataBase) {
        dataBase = [FMDatabase databaseWithPath:[self getSqlitePaths]];
    }
    
    if ([dataBase open]) {
        
        if ([self isTableOK:tableName]) {
            
            NSString *where = @"where";
            
            for (int i = 0; i < condition.count; i++) {
                
                NSString *key = [condition objectAtIndex:i];
                NSString *needStr = [values objectAtIndex:i];
                
                if (i == 0) {
                    
                    where = [NSString stringWithFormat:@"%@ %@ = '%@'",where,key,needStr];
                }else{
                    
                    where = [NSString stringWithFormat:@"%@ and %@ = '%@'",where,key,needStr];
                }
            }
            
            //拼接查询语句字符串
            NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@ %@",tableName,where];
            
            FMResultSet *rs = [dataBase executeQuery:sql];
            
            while ([rs next]) {
                
                for (NSString *key in fieldArray) {
                    
                    NSString *value = [rs stringForColumn:key];
                    
                    [dict setObject:value forKey:key];
                }
                
                break;
            }
            
        }else
        {
            //            NSLog(@" === 查询【%@】表不存在 === ",tableName);
        }
        
        //关闭数据库
        [self closeSqlite];
        
    }
    
    return dict;
}


/*
 * @ 根绝某字段的值查询数据数据
 * @ fieldArray:需返回字段数组
 *
 **/
- (NSArray *)selectDataInTable:(NSString *)tableName field:(NSString *)field value:(NSString *)value fieldArray:(NSArray *)fieldArray{
    
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    
    if (!dataBase) {
        dataBase = [FMDatabase databaseWithPath:[self getSqlitePaths]];
    }
    
    if ([dataBase open]) {
        
        if ([self isTableOK:tableName]) {
            
            /*
             * desc 降序排列 asc 升序排列
             */

            NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@ WHERE %@ = %@ ",tableName,field,value];
            
            FMResultSet *rs = [dataBase executeQuery:sql];
            
            while ([rs next]) {
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                
                for (NSString *key in fieldArray) {
                    
                    NSString *value = [rs stringForColumn:key];
                    
                    [dict setObject:value forKey:key];
                }
                
                [dataArr addObject:dict];
            }
            
        }else{
            //            NSLog(@" === 查询【%@】表不存在 === ",tableName);
        }
        
        //关闭数据库
        [self closeSqlite];
        
    }
    
    return dataArr;
}

/*
 * @ 查找某段范围内的数据
 * @ fieldArray:需返回字段数组
 *
 **/
- (NSArray *)selectAreaDataInTable:(NSString *)tableName fieldArray:(NSArray *)fieldArray page:(NSInteger)page size:(NSInteger)size
{
    
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    
    if (!dataBase) {
        dataBase = [FMDatabase databaseWithPath:[self getSqlitePaths]];
    }
    
    if ([dataBase open]) {
        
        if ([self isTableOK:tableName]) {
            
            /*
             * desc 降序排列 asc 升序排列
             */
            NSString *sql = [NSString stringWithFormat:@"SELECT  *  FROM %@  order by rowid desc limit %ld,%ld",tableName,page * size,size];
            
            FMResultSet *rs = [dataBase executeQuery:sql];
            
            while ([rs next]) {
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                
                for (NSString *key in fieldArray) {
                    
                    NSString *value = [rs stringForColumn:key];
                    
                    [dict setObject:value forKey:key];
                    
                }
                
                [dataArr addObject:dict];
            }
            
        }else
        {
//            NSLog(@" === 查询【%@】表不存在 === ",tableName);
        }
        
        //关闭数据库
        [self closeSqlite];
        
    }
    
    return dataArr;
}

/*
 * @ 查找所有数据
 * @ fieldArray:需返回字段数组
 *
 **/
- (NSArray *)selectAllDataInTable:(NSString *)tableName fieldArray:(NSArray *)fieldArray
{
    
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    
    if (!dataBase) {
        dataBase = [FMDatabase databaseWithPath:[self getSqlitePaths]];
    }
    
    if ([dataBase open]) {
        
        if ([self isTableOK:tableName]) {
            
            NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@",tableName];
            
            FMResultSet *rs = [dataBase executeQuery:sql];
            
            while ([rs next]) {
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                
                for (NSString *key in fieldArray) {
                    
                    NSString *value = [rs stringForColumn:key];
                    
                    [dict setObject:value forKey:key];
                    
                }
                
                [dataArr addObject:dict];
                
            }
            
        }else {
//            NSLog(@" === 查询【%@】表不存在 === ",tableName);
        }
        
        //关闭数据库
        [self closeSqlite];
    }
    
    return dataArr;
}


/*
 * @ 根据主键查询是否存在该条数据
 * @ tableName:表名
 * @ primaryKey:主键
 *
 */
- (BOOL)isInTable:(NSString *)tableName withPrimaryKey:(NSString *)primaryKey
{
    
    BOOL isIn = NO;
    
    if (!dataBase) {
        dataBase = [FMDatabase databaseWithPath:[self getSqlitePaths]];
    }
    
    if ([dataBase open]) {
        
        if ([self isTableOK:tableName]) {
            
            NSString * sql =[NSString stringWithFormat:@"select count(*) as 'count' from %@ where  ID = '%@'",tableName,primaryKey];
            
            FMResultSet *rs = [dataBase executeQuery:sql];
            
            while ([rs next])
            {
                NSInteger count = [rs intForColumn:@"count"];
                
                if (0 == count) {
                    
//                    NSLog(@" == 【%@】表中不存在主键为【%@】数据 ===", tableName,primaryKey);
                    isIn = NO;
                }else
                {
//                    NSLog(@" == 【%@】表中存在主键为【%@】数据 ===", tableName,primaryKey);
                    
                    isIn = YES;
                }
            }
            
        }else
        {
//            NSLog(@" === 查询【%@】表不存在 === ",tableName);
            isIn = NO;
        }
        //
        //        //关闭数据库
        //        [self closeSqlite];
        
    }
    
    return isIn;
}

/*
 * @ 根据表的名称判断表是否存在
 * @ tableName:表名
 *
 */
- (BOOL)isTableOK:(NSString *)tableName
{
    
    if (!dataBase) {
        dataBase = [FMDatabase databaseWithPath:[self getSqlitePaths]];
    }
    
    FMResultSet *rs = [dataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count){
            
//            NSLog(@" === 查询【%@】表尚未创建",tableName);
            
            return NO;
            
        }else{
            
//            NSLog(@" === 查询【%@】表已经存在",tableName);
            
            return YES;
        }
    }
    
    return NO;
}



@end
