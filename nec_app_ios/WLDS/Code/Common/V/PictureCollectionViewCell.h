//
//  PictureCollectionViewCell.h
//  WLDS
//
//  Created by zhiyundaohe on 2018/3/2.
//  Copyright © 2018年 zhiyundaohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picIV;

@property (weak, nonatomic) IBOutlet UILabel *title;

////图片
//@property (nonatomic,strong) UIImageView *picIV;
//
////文本标题
//@property (nonatomic,strong) UILabel *title;

@end
