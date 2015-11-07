//
//  PictureViewCell.h
//  01-pictureViewer
//
//  Created by Envy15 on 15/11/5.
//  Copyright (c) 2015年 c344081. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureViewCell : UICollectionViewCell
/** 图片 */
@property (nonatomic, strong) UIImage *picture;
/** imageview */
@property (nonatomic, weak) UIImageView *imageView;
@end
