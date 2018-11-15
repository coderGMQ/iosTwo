//
//  CustomSearchBar.h
//  Deji_Plaza
//
//  Created by zl on 13-1-7.
//  Copyright (c) 2013年 zl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSearchBar : UISearchBar
{
    UIImage *_searchBarBackGround;
    UIImage *_searchBarLeftIcon;
    UIImage *_searchBarRightIcon;
}

@property (nonatomic,strong) NSString *leftImageName;

-(void)setSearchBarBackGround:(UIImage *)backGround;
-(void)setSearchBarLeftIcon:(UIImage *)leftIcon;
-(void)setSearchBarRightIcon:(UIImage *)rightIcon;
@end
