//
//  MyCell.m
//  01-pictureViewer
//
//  Created by Envy15 on 15/11/6.
//  Copyright (c) 2015年 c344081. All rights reserved.
//

#import "MyCell.h"

@interface MyCell ()
/** imageview */
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation MyCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 显示图片的 imageview
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

- (void)setPicture:(UIImage *)picture {
    _picture = picture;
    self.imageView.image = picture;
}
@end
