//
//  ViewController.m
//  HZCCardLayout
//
//  Created by Apple on 2018/1/17.
//  Copyright © 2018年 AiChen smart Windows and doors technology co., LTD. All rights reserved.
//

#import "ViewController.h"
#import "HZCCardFlowLayout.h"
// 屏幕高度
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

#define FIT_SCREEN_WIDTH(size) size * SCREEN_WIDTH / 375.0
#define FIT_SCREEN_HEIGHT(size) size * SCREEN_HEIGHT / 667.0

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

/** <#Description#> */
@property (nonatomic, strong) UICollectionView *collectionView;

/** <#Description#> */
@property (nonatomic, strong) HZCCardFlowLayout *layout;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.layout = [[HZCCardFlowLayout alloc]init];
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionInset = UIEdgeInsetsMake(0, FIT_SCREEN_WIDTH(107)*2, 0, FIT_SCREEN_WIDTH(107)*2);
    self.layout.minimumLineSpacing = -FIT_SCREEN_WIDTH(40);
    self.layout.itemSize = CGSizeMake(FIT_SCREEN_WIDTH(107), FIT_SCREEN_HEIGHT(130));
    
    CGFloat xPadding = FIT_SCREEN_WIDTH(35);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(xPadding, FIT_SCREEN_HEIGHT(275), SCREEN_WIDTH - xPadding *2, FIT_SCREEN_HEIGHT(157)) collectionViewLayout:self.layout];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:YES];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint pointInView = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    
    NSInteger index = [self.collectionView indexPathForItemAtPoint:pointInView].row;
    //中间的前后4个
    UICollectionViewCell *cell1 = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index - 2 inSection:0]];
    if (cell1) {
        [self.collectionView bringSubviewToFront:cell1];
    }
    UICollectionViewCell *cell2 = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index + 2 inSection:0]];
    if (cell2) {
        [self.collectionView bringSubviewToFront:cell2];
    }

    UICollectionViewCell *cell3 = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index +1 inSection:0]];
    if (cell3) {
        [self.collectionView bringSubviewToFront:cell3];
    }
    UICollectionViewCell *cell4 = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index -1 inSection:0]];
    if (cell4) {
        [self.collectionView bringSubviewToFront:cell4];
    }
    UICollectionViewCell *cell5 = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    if (cell5) {
        [self.collectionView bringSubviewToFront:cell5];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat index = indexPath.row;
    CGPoint pointInView = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
    CGFloat centerIndex = [collectionView indexPathForItemAtPoint:pointInView].row;
    
    if (index == centerIndex) {//点击的是中间的
        NSLog(@"点击了中间的");
    } else {//旁边的
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:YES];
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
