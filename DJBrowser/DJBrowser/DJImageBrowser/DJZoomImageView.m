//
//  DJZoomImageView.m
//  DJBrowser
//
//  Created by VictorDing on 2017/3/2.
//  Copyright © 2017年 yoanna. All rights reserved.
//

#import "DJZoomImageView.h"

/// 判断一个size是否为空（宽或高为0）
CG_INLINE BOOL
CGSizeIsEmpty(CGSize size) {
    return size.width <= 0 || size.height <= 0;
}

@interface DJZoomImageView ()

@property(nonatomic,strong) UIScrollView *scrollView;
@end

@implementation DJZoomImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeCenter;
        
        [self addSubview:self.scrollView];
        //double tap
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
        doubleTapGesture.numberOfTouchesRequired = 1;
        doubleTapGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGesture];
        //long tap
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongpressGesture:)];
        [self addGestureRecognizer:longPressGesture];
        self.maximumZoomScale = 2;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    
   
}

#pragma mark - public methods

/**
 Get imageView rect in ZoomImageView

 @return imageView rect
 */
-(CGRect)imageViewRectInZoomView{
    CGRect rect = [self convertRect:self.imageView.frame fromView:self.imageView.superview];
    return rect;
}

#pragma mark - private methods
- (void)handleDoubleTapGesture:(UIGestureRecognizer *)g{
    CGPoint point = [g locationInView:g.view];
    
    CGFloat newScale;
    if (self.scrollView.zoomScale >= self.maximumZoomScale) {
        newScale = 1;
    }else{
        newScale = self.maximumZoomScale;
    }
    
    CGSize zoomSize;
    zoomSize.width = self.bounds.size.width / newScale;
    zoomSize.height = self.bounds.size.height / newScale;
    
    CGPoint tapPoint = [self.imageView convertPoint:point fromView:g.view];
    
    CGRect zoomRect;
    zoomRect.size = zoomSize;
    zoomRect.origin.x = tapPoint.x - zoomSize.width/2.0f;
    zoomRect.origin.y = tapPoint.y - zoomSize.height/2.0f;
    
    [self zoomToRect:zoomRect animated:YES];
}

- (void)handleLongpressGesture:(UILongPressGestureRecognizer *)g{
    if (g.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(longPressTouchInZoomView:)]) {
            [self.delegate longPressTouchInZoomView:self];
        }
    }
}

- (void)handleDidEndZooming{
    UIImageView *imageView = self.imageView;
    CGRect imageViewFrame = [self convertRect:imageView.frame fromView:imageView.superview];
    CGSize viewportSize = self.bounds.size;
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    
    if (!CGRectIsEmpty(imageViewFrame) && !CGSizeIsEmpty(viewportSize)) {
        if (CGRectGetWidth(imageViewFrame) < viewportSize.width) {
            contentInset.left = contentInset.right = floor((viewportSize.width - CGRectGetWidth(imageViewFrame)) / 2.0);
        }
        
        if (CGRectGetHeight(imageViewFrame) < viewportSize.height) {
            contentInset.top = contentInset.bottom = floor((viewportSize.height - CGRectGetHeight(imageViewFrame)) / 2.0);
        }
    }
    
    self.scrollView.contentInset = contentInset;
    self.scrollView.contentSize = imageView.frame.size;
    
    if (self.scrollView.contentInset.top > 0) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -self.scrollView.contentInset.top);
    }
    
    if (self.scrollView.contentInset.left > 0) {
        self.scrollView.contentOffset = CGPointMake(-self.scrollView.contentInset.left, self.scrollView.contentOffset.y);
    }
}

- (CGFloat)minimumZoomScale {
    CGRect viewport = self.bounds;
    if (CGRectIsEmpty(viewport) || (!self.image)) {
        return 1;
    }
    
    CGSize imageSize = self.image.size;
    
    CGFloat minScale = 1;
    CGFloat scaleX = CGRectGetWidth(viewport) / imageSize.width;
    CGFloat scaleY = CGRectGetHeight(viewport) / imageSize.height;
    if (self.contentMode == UIViewContentModeScaleAspectFit) {
        minScale = fminf(scaleX, scaleY);
    } else if (self.contentMode == UIViewContentModeScaleAspectFill) {
        minScale = fmaxf(scaleX, scaleY);
    } else if (self.contentMode == UIViewContentModeCenter) {
        if (scaleX >= 1 && scaleY >= 1) {
            minScale = 1;
        } else {
            minScale = fminf(scaleX, scaleY);
        }
    }
    return minScale;
}

- (void)revertZooming {
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    
    BOOL enabledZoomImageView = YES;
    CGFloat minimumZoomScale = [self minimumZoomScale];
    CGFloat maximumZoomScale = self.maximumZoomScale;
    maximumZoomScale = fmaxf(minimumZoomScale, maximumZoomScale);// 可能外部通过 contentMode = UIViewContentModeScaleAspectFit 的方式来让小图片撑满当前的 zoomImageView，所以算出来 minimumZoomScale 会很大（至少比 maximumZoomScale 大），所以这里要做一个保护
    CGFloat zoomScale = minimumZoomScale;
    BOOL shouldFireDidZoomingManual = zoomScale == self.scrollView.zoomScale;
    self.scrollView.panGestureRecognizer.enabled = enabledZoomImageView;
    self.scrollView.pinchGestureRecognizer.enabled = enabledZoomImageView;
    self.scrollView.minimumZoomScale = minimumZoomScale;
    self.scrollView.maximumZoomScale = maximumZoomScale;
    [self setZoomScale:zoomScale animated:NO];
    
    // 只有前后的 zoomScale 不相等，才会触发 UIScrollViewDelegate scrollViewDidZoom:，因此对于相等的情况要自己手动触发
    if (shouldFireDidZoomingManual) {
        [self handleDidEndZooming];
    }
}

- (void)setZoomScale:(CGFloat)zoomScale animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.scrollView.zoomScale = zoomScale;
        } completion:nil];
    } else {
        self.scrollView.zoomScale = zoomScale;
    }
}

- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated{
    if (animated) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.scrollView zoomToRect:rect animated:NO];
        } completion:nil];
    }else{
        [self.scrollView zoomToRect:rect animated:NO];
    }
}

#pragma mark - scrollview delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    [self handleDidEndZooming];
}

#pragma mark - getter and setter

- (void)setFrame:(CGRect)frame{
    BOOL isBoundsChanged = !CGSizeEqualToSize(self.frame.size, frame.size);
    [super setFrame:frame];
    if (isBoundsChanged) {
        [self revertZooming];
    }
}

- (void)setImage:(UIImage *)image{
    self.imageView.image = image;
    self.imageView.frame = CGRectApplyAffineTransform(CGRectMake(0, 0, image.size.width, image.size.height), self.imageView.transform);
    [self revertZooming];
}

- (UIImage *)image{
    return self.imageView.image;  
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.maximumZoomScale = 1;
        _scrollView.minimumZoomScale = 0;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        
        if (!self.imageView) {
            _imageView = [[UIImageView alloc] init];
        }
        [_scrollView addSubview:self.imageView];
    }
    
    return _scrollView;
}

- (void)setMaximumZoomScale:(CGFloat)maximumZoomScale{
    _maximumZoomScale = maximumZoomScale;
    self.scrollView.maximumZoomScale = maximumZoomScale;
}


@end
