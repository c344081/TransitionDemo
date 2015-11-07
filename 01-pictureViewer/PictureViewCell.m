
//
//  PictureViewCell.m
//  01-pictureViewer
//
//  Created by Envy15 on 15/11/5.
//  Copyright (c) 2015年 c344081. All rights reserved.
//

#import "PictureViewCell.h"

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

@interface PictureViewCell () <UIScrollViewDelegate>
/** scrollView  用于缩放*/
@property (nonatomic, weak)  UIScrollView *scrollView;

@end

@implementation PictureViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加 scrollView
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
        scrollView.minimumZoomScale = 0.5;
        scrollView.maximumZoomScale = 5.0;

        scrollView.delegate = self;
        
        // 显示图片的 imageview
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

- (void)setPicture:(UIImage *)picture {
    _picture = picture;
    
    self.imageView.image = picture;
    
    // 重新布局
    [self changeLayout];
}

- (void)changeLayout {
    // 重置 scrollView缩放属性
    self.scrollView.zoomScale = 1.0;
    
    // 调整imageview 的尺寸
    CGFloat imageW = SCREENW;
    CGFloat imageH = self.picture.size.height * imageW / self.picture.size.width;
    self.imageView.frame = CGRectMake(0, 0, imageW, imageH);
    
    // 居中显示
    if (imageH < SCREENH) {
        self.scrollView.contentSize = CGSizeMake(SCREENW, imageH);
    } else {
        self.scrollView.contentSize = CGSizeMake(SCREENW, SCREENH);
    }
    
    CGFloat offset = (SCREENH - imageH) * 0.5;
    self.scrollView.contentInset = UIEdgeInsetsMake(offset, 0, offset, 0);
}

#pragma mark - scrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

// 缩放过程中会回调此方法
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 缩放比例小于1时,让图片始终居中显示
    if (scrollView.zoomScale <= 1.0) {
        NSLog(@"-----");
        CGFloat offsetX = (SCREENW - self.imageView.bounds.size.width * scrollView.zoomScale) *0.5;
         CGFloat offsetY = (SCREENH - self.imageView.bounds.size.height * scrollView.zoomScale) *0.5;

        self.scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, offsetY, offsetX);
     
    }
}

@end
