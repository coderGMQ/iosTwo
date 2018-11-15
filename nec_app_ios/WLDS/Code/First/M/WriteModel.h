//
//  WriteModel.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/13.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WriteModel : NSObject

@property (nonatomic,strong) NSNumber *Id;

@property (nonatomic,strong) NSString *areaname;

@property (nonatomic,strong) NSString *shortname;

+(WriteModel *)shareWriteModelWithDictionary:(NSDictionary *)dictionary;

@end

//        "id" : 820000,
//        "areacode" : null,
//        "position" : "tr_0",
//        "parentid" : 0,
//        "shortname" : "澳门",
//        "zipcode" : null,
//        "pinyin" : null,
//        "lat" : "22.198952",
//        "level" : 1,
//        "lng" : "113.549088",
//        "areaname" : "澳门特别行政区",
//        "sort" : 33

