//
//  CustomSearchBar.m
//  Deji_Plaza
//
//  Created by zl on 13-1-7.
//  Copyright (c) 2013年 zl. All rights reserved.
//

#import "CustomSearchBar.h"

//判断当前设备是否是IOS7
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//判断当前设备是否是IOS8
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

//默认字体
#define defaultFontSize(s)    [UIFont systemFontOfSize:s]
#define defaultBoldFontSize(s)  [UIFont boldSystemFontOfSize:s]

@implementation CustomSearchBar


/**
 *** 使用范例 ****
 
      //搜索框
      _searchBar = [[CustomSearchBar alloc] initWithFrame:CGRectMake(5, 5, kWidth - 5, 40)];
     
      self.searchBar.searchBarStyle = 2;
     
     [self.view addSubview:self.searchBar];
     
     self.searchBar.placeholder = @"请输入您要搜索的经销商";
     
     self.searchBar.delegate = self;
     
     self.searchBar.showsCancelButton = YES;
     
     self.searchBar.leftImageName = @"search";
     
     [self.view addSubview:self.searchBar];
 
**/


#pragma mark===========初始化================

/**   函数作用 :初始化界面
 **   函数参数 :
 **   函数返回值:
 **/

-(void)initView
{
    self.backgroundColor = [UIColor clearColor];
    
    float version = [[[ UIDevice currentDevice ] systemVersion ] floatValue ];
    
    if (version > 7)
        
    {
        //iOS7.1
        
        [[[[ self.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
        
        [ self setBackgroundColor :[ UIColor clearColor ]];
        
    }
    else if (IOS7) {
        if ([ self  respondsToSelector: @selector (barTintColor)]) {
            [ self  setBarTintColor:[UIColor clearColor]];
        }
    }
    else
    {
        for (UIView *subView in self.subviews) {
//            //背景透明
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subView removeFromSuperview];
            }
        }
    }
    
    
    //背景
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[MHFile getResourcesFile:@"searchBar_bg.png"]]];
//    imageView.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height );
//    [self insertSubview:imageView atIndex:0];
//    [imageView release];
    
}


#pragma mark===========life circle================

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initView];
    }
    
    return self;
}

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
//    [self initView];
}


//重载放大镜图片
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
	UITextField *searchField = nil;
    
    UIView *view = self;
    
    if (IOS7) {
        
        view = [self.subviews lastObject];
    }
    
	NSUInteger numViews = [view.subviews count];
    
	for(int i = 0; i< numViews; i++) {
        
		if([[view.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) {
            
			searchField = [view.subviews objectAtIndex:i];
		}
	}
    
	if(searchField) {
        
        searchField.background = _searchBarBackGround;
        
        [searchField setValue:defaultFontSize(15) forKeyPath:@"_placeholderLabel.font"];
        //放大镜
		UIImageView *iView = [[UIImageView alloc] init];
        iView.image = [UIImage imageNamed:self.leftImageName];
        iView.frame = CGRectMake(0, 0, 20, 20);
		searchField.leftView = iView;
        
        searchField.frame = CGRectMake(0, 0, self.frame.size.width - (40 + iView.frame.size.width + iView.frame.origin.x), self.frame.size.height);
        
        searchField.backgroundColor = kWhiteColor;
        
	}
    
//    searchField.center = CGPointMake(searchField.center.x, self.bounds.size.height/2);
}

-(void)setSearchBarBackGround:(UIImage *)backGround{
    
    if (_searchBarBackGround == backGround) return;

    [self setNeedsDisplay];
}

-(void)setSearchBarLeftIcon:(UIImage *)leftIcon{
    
    if (_searchBarLeftIcon == leftIcon) return;

    [self setNeedsDisplay];
}

-(void)setSearchBarRightIcon:(UIImage *)rightIcon{
    
    if (_searchBarRightIcon == rightIcon) return;

    [self setImage:_searchBarRightIcon forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
}


@end

