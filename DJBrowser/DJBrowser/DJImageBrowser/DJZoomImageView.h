//
//  DJZoomImageView.h
//  DJBrowser
//
//  Created by VictorDing on 2017/3/2.
//  Copyright © 2017年 yoanna. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DJZoomImageView;
@protocol DJZoomImageViewDelegate <NSObject>
@optional
- (void)singleTouchInZoomView:(DJZoomImageView *)zoomView location:(CGPoint)point;
- (void)doubleTouchInZoomView:(DJZoomImageView *)zoomView location:(CGPoint)point;
- (void)longPressTouchInZoomView:(DJZoomImageView *)zoomView;
@end

@interface DJZoomImageView : UIView<UIScrollViewDelegate>

//display image
@property (nonatomic,strong) UIImage *image;
//imageView
@property (nonatomic,strong,readonly) UIImageView *imageView;
//scale
@property (nonatomic,assign) CGFloat maximumZoomScale;

//delegate
@property (nonatomic,weak) id <DJZoomImageViewDelegate> delegate;


- (CGRect)imageViewRectInZoomView;
@end
