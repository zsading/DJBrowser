//
//  DJCollectionViewPageLayout.m
//  DJBrowser
//
//  Created by VictorDing on 2017/3/2.
//  Copyright © 2017年 yoanna. All rights reserved.
//

#import "DJCollectionViewPageLayout.h"

@interface DJCollectionViewPageLayout ()
{
    CGSize _finalItemSize;
}
@end

@implementation DJCollectionViewPageLayout


- (instancetype)init{
    self = [super init];
    if (self) {
        self.velocityForPageTurning = 0.4;
        self.minimumLineSpacing = 0;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
    CGSize size = self.itemSize;
    id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    
    if ([delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        size = [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    }
    
    _finalItemSize = size;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    CGFloat itemSpace = _finalItemSize.width + self.minimumLineSpacing;
    if (fabs(velocity.x) > self.velocityForPageTurning) {
        //page turn
        BOOL isRightDirection = proposedContentOffset.x < self.collectionView.contentOffset.x;
        proposedContentOffset = CGPointMake(self.collectionView.contentOffset.x + (itemSpace/2)*(isRightDirection?-1:1), self.collectionView.contentOffset.y);
    }else{
        proposedContentOffset = self.collectionView.contentOffset;
    }
    
    proposedContentOffset.x = roundf(proposedContentOffset.x/itemSpace)*itemSpace;
    return proposedContentOffset;
}


@end
