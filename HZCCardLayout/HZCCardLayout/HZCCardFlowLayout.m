//
//  HZCCardFlowLayout.m
//  HZCCardLayout
//
//  Created by Apple on 2018/1/17.
//  Copyright © 2018年 AiChen smart Windows and doors technology co., LTD. All rights reserved.
//

#import "HZCCardFlowLayout.h"

#define ActiveDistance 400 //垂直缩放除以系数
#define ScaleFactor 0.25  //缩放系数  越大缩放越大
@implementation HZCCardFlowLayout

/**
 改变collectionView的位置
 
 @param proposedContentOffset 默认情况下，collectionView最终的contentOffset
 @param velocity 力度
 @return collectionView最终的偏移量（最终的停留位置）
 */
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
      // 目标区域中包含的cell
    NSArray *attriArray = [super layoutAttributesForElementsInRect:targetRect];
    // collectionView落在屏幕中点的x坐标
    CGFloat horizontalCenterX = proposedContentOffset.x + (self.collectionView.bounds.size.width / 2);
    CGFloat offsetAdjustment = CGFLOAT_MAX;
    
    for (UICollectionViewLayoutAttributes *layoutAttrinbutes in attriArray) {
        CGFloat itemHorizontalCenterX = layoutAttrinbutes.center.x;
        if (fabs(itemHorizontalCenterX-horizontalCenterX)<fabs(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenterX-horizontalCenterX;
        }
    }
    //调整
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

//重新计算布局属性
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //    NSArray * supperAtt = [super layoutAttributesForElementsInRect:rect];
    NSArray* supperAtt = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    CGRect visibleRect = CGRectZero;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes *attributes in supperAtt) {
        CGFloat distace = CGRectGetMidX(visibleRect) - attributes.center.x;
        CGFloat normalizedDistance = fabs(distace/ActiveDistance);
        CGFloat zoom = 1 -ScaleFactor *normalizedDistance;
        attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
        CGRect newFrame = CGRectMake(attributes.frame.origin.x, fabs(distace *ScaleFactor), attributes.frame.size.width, attributes.frame.size.height);
        attributes.frame = newFrame;
    }
    
    return supperAtt;
}



/**
 *  当可见范围发生新布局的时候刷新
 // */
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
