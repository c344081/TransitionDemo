//
//  FadeTransition.m
//  01-pictureViewer
//
//  Created by Envy15 on 15/11/7.
//  Copyright (c) 2015年 c344081. All rights reserved.
//

#import "FadeTransition.h"

@implementation FadeTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.8f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 获得上下文(必须遵守数据源协议)
    UIViewController<FadeTransitionDataSource> *fromVc = (UIViewController<FadeTransitionDataSource> *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController<FadeTransitionDataSource> *toVc = (UIViewController<FadeTransitionDataSource> *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 获取点击的视图
    UIView *fromView = fromVc.sharedView;
    // 用于转场的视图
    UIView *toView = toVc.sharedView;
    
    // 设置标记 present 或 dismiss
    BOOL reverse = NO;
    if ([fromVc isBeingDismissed]) {
        reverse = YES;
    }
    
    // 设置初始化的 frame
    toView.alpha = 0;
    toView.hidden = YES;
    
    // 截图
    UIView *containerView = [transitionContext containerView];
    UIView *snapshotView = [fromView snapshotViewAfterScreenUpdates:YES];
    if (reverse) {
        // 设置截图位置
        CGFloat imageW = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat imageH = ((UIImageView *)fromView).image.size.height * imageW / ((UIImageView *)fromView).image.size.width;
        CGFloat imageY = (CGRectGetHeight([UIScreen mainScreen].bounds) - imageH) * 0.5;
        snapshotView.frame = CGRectMake(0, imageY, imageW, imageH);
    } else {
        snapshotView.frame = [containerView convertRect:fromView.frame fromView:fromView.window];
    }
    fromView.hidden = YES;
    
    // toVc无位移动画,只有透明度动画
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVc];
    toVc.view.frame = finalFrame;
    toVc.view.alpha = 0;
    
    // 添加到 containerView
    [containerView addSubview:toVc.view];
    if (reverse) {
        [containerView sendSubviewToBack:toVc.view];
    }
    
    [containerView addSubview:snapshotView];
    
    // 动画
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    [UIView animateWithDuration:duration animations:^{
        if (!reverse) {
            // 设置截图最终位置
            CGFloat imageW = CGRectGetWidth([UIScreen mainScreen].bounds);
            CGFloat imageH = ((UIImageView *)toView).image.size.height * imageW / ((UIImageView *)toView).image.size.width;
            CGFloat imageY = (CGRectGetHeight([UIScreen mainScreen].bounds) - imageH) * 0.5;
            // 移动 图片
            snapshotView.frame = CGRectMake(0, imageY, imageW, imageH);
        } else {
            snapshotView.frame = [containerView convertRect:toView.frame toView:toView.superview];
        }
        
        if (reverse) {
            fromVc.view.hidden = YES;
            toVc.view.hidden = NO;
            toVc.view.alpha = 1.0;
        }
        // fromVc 淡出
        fromVc.view.alpha = 0;

    } completion:^(BOOL finished) {
        // toVc 显示
        toVc.view.alpha = 1.0;
        
        // 移除截图,并显示视图
        toView.hidden = NO;
        toView.alpha = 1.0;
        fromView.hidden = NO;
        [snapshotView removeFromSuperview];
        
        // 结束标记
        [transitionContext completeTransition:YES];
    }];
    
}

@end
