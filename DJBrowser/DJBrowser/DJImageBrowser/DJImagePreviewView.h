//
//  DJImagePreviewView.h
//  DJBrowser
//
//  Created by VictorDing on 2017/3/2.
//  Copyright © 2017年 yoanna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJCollectionViewPageLayout.h"
#import "DJZoomImageView.h"

@class DJImagePreviewView;

@protocol DJImagePreviewViewDelegate <NSObject>

- (NSUInteger)numberOfImagesInPreviewView:(DJImagePreviewView *)previewView;
- (void)imagePreviewView:(DJImagePreviewView *)imagePreviewView renderZoomImageView:(DJZoomImageView *)zoomImageView atIndex:(NSUInteger)index;

- (void)imagePreviewView:(DJImagePreviewView *)imagePreviewView didScrollViewToIndex:(NSUInteger)index;
@end

@interface DJImagePreviewView : UIView<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,DJZoomImageViewDelegate>


@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) DJCollectionViewPageLayout *collectionViewLayout;
@property(nonatomic,weak) id<DJImagePreviewViewDelegate> delegate;

//source images
@property (nonatomic,strong) NSArray *previewImages;
//source images url
@property (nonatomic,strong) NSArray *previewImagesUrl;



- (DJZoomImageView *)zoomImageViewAtIndex:(NSUInteger)index;
@end
