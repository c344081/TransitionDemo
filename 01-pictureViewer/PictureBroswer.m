//
//  PictureBroswer.m
//  01-pictureViewer
//
//  Created by Envy15 on 15/11/5.
//  Copyright (c) 2015年 c344081. All rights reserved.
//

#import "PictureBroswer.h"
#import "PictureViewCell.h"
#import "FadeTransition.h"

@interface PictureBroswer () <UICollectionViewDataSource, UICollectionViewDelegate, FadeTransitionDataSource>
/** collectionView */
@property (nonatomic, weak) UICollectionView *collectionView;
/** 退出按钮 */
@property (nonatomic, weak) UIButton *cancelBtn;
/** 图片数组 */
@property (nonatomic, strong)  NSArray *pictures;
/** 初始化时的 indexPath */
@property (nonatomic, strong) NSIndexPath *initialIndexPath;
/** placeHolder */
@property (nonatomic, weak) UIImageView *placeHolderV;
@end

@implementation PictureBroswer

static NSString * const reuseIdentifier = @"Cell";

+ (instancetype)brosweWithPictures:(NSArray *)pictures selectedItemIndexPath:(NSIndexPath *)indexPath {
    return [[self alloc] initWithPictures:pictures selectedItemIndexPath:indexPath];
}

#pragma mark - 使用图片数组初始化
- (instancetype)initWithPictures: (NSArray *)pictures selectedItemIndexPath:(NSIndexPath *)indexPath {
    
    if (self = [super init]) {
        
        // 保存初始化时的 indexPath
        _initialIndexPath = indexPath;
        
        self.pictures = pictures;
        
        [self setupCollectionView];
        
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTitle:@"退出" forState: UIControlStateNormal];
        [self.view addSubview:cancelBtn];
        self.cancelBtn = cancelBtn;
        [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        
        self.cancelBtn.frame = CGRectMake(250, 600, 120, 50);
        self.cancelBtn.backgroundColor = [UIColor lightGrayColor];
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = [UIScreen mainScreen].bounds.size.width;
    CGFloat itemH = [UIScreen mainScreen].bounds.size.height;
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView = collectionView;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    // collectionView 其他设置
    self.collectionView.bounces = NO;
    self.collectionView.pagingEnabled = YES;
    
    [self.collectionView registerClass:[PictureViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:collectionView];

}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // 取模型
    UIImage *image = self.pictures[indexPath.item];
    cell.picture = image;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

#pragma mark - scrollView delegate 
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {

}

#pragma mark - fade transition
- (UIView *)sharedView {
    PictureViewCell *cell = (PictureViewCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:_initialIndexPath];
    // 取模型
    UIImage *image = self.pictures[_initialIndexPath.item];
    cell.picture = image;
    return cell.imageView;
}

@end
