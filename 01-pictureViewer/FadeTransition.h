//
//  FadeTransition.h
//  01-pictureViewer
//
//  Created by Envy15 on 15/11/7.
//  Copyright (c) 2015年 c344081. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FadeTransition;

@protocol FadeTransitionDataSource <NSObject>

- (UIView *)sharedView;

@end

@interface FadeTransition : NSObject  <UIViewControllerAnimatedTransitioning>

@end
