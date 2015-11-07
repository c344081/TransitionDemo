//
//  ViewController.m
//  01-pictureViewer
//
//  Created by Envy15 on 15/11/5.
//  Copyright (c) 2015年 c344081. All rights reserved.
//

#import "ViewController.h"
#import "PictureBroswer.h"
#import "MyCell.h"
#import "FadeTransition.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate>
/** collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 图片数组 */
@property (nonatomic, copy) NSArray *pictures;
/** 转场 */
@property (nonatomic, strong)  FadeTransition *fadeTransition;
@end

@implementation ViewController

static NSString *const indentifier = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCollectionView];
    
    // 设置转场
    self.fadeTransition = [[FadeTransition alloc] init];

}

#pragma mark - lazyload
- (NSArray *)pictures {
    if (!_pictures) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0; i < 9; i++) {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%02d", i+1] ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            [arrayM addObject:image];
        }
        _pictures = [arrayM copy];
    }
    return _pictures;
}

- (void)setupCollectionView {
    // 设置布局属性
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 10;
    int cols = 3;
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat itemWidth = (self.view.bounds.size.width - (cols + 1) * margin ) / cols;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    // 代理和数据源
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    collectionView.bounces = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [collectionView registerClass:[MyCell class] forCellWithReuseIdentifier:indentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
    cell.picture = self.pictures[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    PictureBroswer *pictureBroswer = [PictureBroswer brosweWithPictures:self.pictures selectedItemIndexPath:indexPath];
    
    // 设置转场代理
    pictureBroswer.transitioningDelegate = self;
    
    [self presentViewController:pictureBroswer animated:YES completion:nil];
}

#pragma mark - fade transition
- (UIView *)sharedView {
    
    return [self.collectionView cellForItemAtIndexPath: [self.collectionView indexPathsForSelectedItems][0]];
}

#pragma mark - 转场相关
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.fadeTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.fadeTransition;
}

@end
