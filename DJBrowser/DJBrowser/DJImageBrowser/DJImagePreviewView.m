//
//  DJImagePreviewView.m
//  DJBrowser
//
//  Created by VictorDing on 2017/3/2.
//  Copyright © 2017年 yoanna. All rights reserved.
//

#import "DJImagePreviewView.h"
#import "DJImagePreviewCell.h"

#define PreviewCellName (@"PreviewCell")

@implementation DJImagePreviewView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerCell];
        [self addSubview:self.collectionView];
    }
    
    return self;
}

#pragma mark - public methods
- (DJZoomImageView *)zoomImageViewAtIndex:(NSUInteger)index{
    DJImagePreviewCell *imagePreviewCell = (DJImagePreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return imagePreviewCell.zoomImageView;
}

#pragma mark - private methods
- (void)registerCell{
    [self.collectionView registerClass:[DJImagePreviewCell class] forCellWithReuseIdentifier:PreviewCellName];
}


#pragma mark - collectionView/collectionViewDataSource delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if ([self.delegate respondsToSelector:@selector(numberOfImagesInPreviewView:)]) {
        return [self.delegate numberOfImagesInPreviewView:self];
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DJImagePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PreviewCellName forIndexPath:indexPath];
    cell.zoomImageView.delegate = self;
//    cell.zoomImageView.imageView.image = self.previewImages[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.bounds.size;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    DJImagePreviewCell *previewCell = (DJImagePreviewCell *)cell;
    if ([self.delegate respondsToSelector:@selector(imagePreviewView:renderZoomImageView:atIndex:)]) {
        [self.delegate imagePreviewView:self renderZoomImageView:previewCell.zoomImageView atIndex:indexPath.item];
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView != self.collectionView) {
        return;
    }
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView != self.collectionView) {
        return;
    }
    
    
    CGFloat itemWidth = [self collectionView:self.collectionView layout:self.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]].width;
    
    CGFloat offset_X = self.collectionView.contentOffset.x;
    CGFloat index = offset_X/itemWidth;
    
    if ([self.delegate respondsToSelector:@selector(imagePreviewView:didScrollViewToIndex:)]) {
        [self.delegate imagePreviewView:self didScrollViewToIndex:index];
    }
    
}

#pragma mark - getter and setter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        DJCollectionViewPageLayout *pageLayout = self.collectionViewLayout;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:pageLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    
    return _collectionView;
}

- (DJCollectionViewPageLayout *)collectionViewLayout{
    if (!_collectionViewLayout) {
        _collectionViewLayout = [[DJCollectionViewPageLayout alloc] init];
    }
    return _collectionViewLayout;
}

@end
