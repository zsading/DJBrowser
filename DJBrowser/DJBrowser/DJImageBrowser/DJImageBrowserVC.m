//
//  DJImageBrowserVC.m
//  DJBrowser
//
//  Created by VictorDing on 2017/3/2.
//  Copyright © 2017年 yoanna. All rights reserved.
//

#import "DJImageBrowserVC.h"
#import "UIImageView+WebCache.h"
#import "UIView+Layout.h"


#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)



@interface DJImageBrowserVC ()<UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *scrollViewImageHeights;
//Double click
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;
//The current ratio
@property (nonatomic,assign) CGFloat currentScale;
//The max ratio
@property (nonatomic,assign) CGFloat maxScale;
//The min ratio
@property (nonatomic,assign) CGFloat minScale;
//if zoom
@property (nonatomic,assign) BOOL isZoom;
//source images
@property (nonatomic,strong) NSArray *previewImages;
//source images url
@property (nonatomic,strong) NSArray *previewImagesUrl;
//preview from Rect
@property (nonatomic,assign) CGRect previewFromRect;
//dismiss To Rect
@property (nonatomic,assign) CGRect dismissToRect;
//preview window
@property (nonatomic,strong) UIWindow *previewWindow;

@property (nonatomic,assign) BOOL shouldStartWithFading;
//transition View
@property (nonatomic,strong) UIImageView *transitionImageView;
//title Label
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,copy) DeleteCallback delCallback;
@property (nonatomic,copy) DismissCallback dismissCallback;


@end

@implementation DJImageBrowserVC

#pragma mark - life cycle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    self.scrollViewImageHeights = [NSMutableArray array];
    
    [self.view addSubview:self.djImagePreviewView];
    [self.view addSubview:self.indexTitleView];//Add title Label
    [self.view addSubview:self.closeBtn];// Add CloseButton
    [self.view addSubview:self.deletePhotoBtn];//Add DeletePhoto Button
    
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.djImagePreviewView.collectionView reloadData];
    
    if (self.previewWindow && !self.shouldStartWithFading) {
        
        self.djImagePreviewView.collectionView.hidden = YES;
    }else{
        self.djImagePreviewView.collectionView.hidden = NO;
    }
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.djImagePreviewView) {
        if (self.shouldStartWithFading) {
            return;
        }
        
        
        DJZoomImageView *zoomImageView = [self.djImagePreviewView zoomImageViewAtIndex:0];
        
        CGRect viewFromRect = self.previewFromRect;
        CGRect viewToRect = [self.view convertRect:[zoomImageView imageViewRectInZoomView] fromView:zoomImageView.superview];
        
        self.transitionImageView.contentMode = zoomImageView.imageView.contentMode;
        self.transitionImageView.image = zoomImageView.image;
        self.transitionImageView.frame = viewFromRect;
        [self.view addSubview:self.transitionImageView];
        
        
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transitionImageView.frame = viewToRect;
            self.view.backgroundColor = [UIColor blackColor];
        } completion:^(BOOL finished) {
            [self.transitionImageView removeFromSuperview];
            self.djImagePreviewView.collectionView.hidden = NO;
        }];
        
        
    }
}

#pragma mark - init
- (instancetype)initWithImages:(NSArray *)images{
    if (self = [super init]) {
        self.previewImages = images;
        self.totalCount = images.count;
    }
    
    return self;
}

- (instancetype)initWithImageUrls:(NSArray *)urls{
    if (self = [super init]) {
        self.previewImagesUrl = urls;
        self.totalCount = urls.count;
    }
    
    return self;
}


#pragma mark - public methods
- (void)deleteImageWithCallback:(DeleteCallback)deleteCallback{
    self.delCallback = deleteCallback;
}


- (void)dismissPreviewToRectInScreen:(CGRect)rect dismissCallback:(DismissCallback)dismissCallback{
    self.dismissToRect = rect;
    self.dismissCallback = dismissCallback;
}


- (void)dismissViewControllerWithCallback:(DismissCallback)dismissCallback{
    self.dismissCallback = dismissCallback;
}


#pragma mark - private methods
- (void)setImages:(NSArray<UIImage *> *)images{
    self.previewImages = images;
}

- (void)setImagesUrl:(NSArray<NSURL *> *)imagesUrl{
    self.previewImagesUrl = imagesUrl;
}

- (void)requestImageForZoomView:(DJZoomImageView *)zoomView atIndex:(NSUInteger)index{
    DJZoomImageView *djImageView = zoomView;
    if (self.djDataType == DJImageDataTypeImage) {
        
        djImageView.image = self.previewImages[index];
        
    }else if (self.djDataType == DJImageDataTypeUrl){
        
        UIImage *placeholderImage = [self imageFromColor:[UIColor lightGrayColor]];
        djImageView.image = placeholderImage;
        
        SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
        [imageManager loadImageWithURL:self.previewImagesUrl[index]  options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
            if (image && cacheType == SDImageCacheTypeNone) {
                CATransition *caTransition = [CATransition animation];
                caTransition.type = kCATransition;
                caTransition.duration = 0.3f;
                caTransition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                [djImageView.imageView.layer addAnimation:caTransition forKey:nil];
            }
            
            djImageView.image = image;
        }];
        
        
    }else{
        
    }
   
    
}

#pragma mark - Action
-(void)closeBtnAction:(UIButton *)btn{
     [self dismissPreviewToRectInScreen:self.dismissToRect];
    self.dismissCallback(0);
}

-(void)deleteBtnAction:(UIButton *)btn{
    self.delCallback(0);
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation ==UIInterfaceOrientationPortrait||interfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown)
    {
        return YES;
    }
    return NO;
}


#pragma mark - Double click
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    
    
    UIScrollView *imageScrollView = [self.view viewWithTag:self.currentImageIndex + 4000];
    
    if (self.currentScale == self.maxScale) {
        self.currentScale = self.minScale;
        [imageScrollView setZoomScale:self.currentScale animated:YES];
        return;
    }
    
    if (self.currentScale == self.minScale) {
        self.currentScale = self.maxScale;
        [imageScrollView setZoomScale:self.currentScale animated:YES];
    }
    
    CGFloat aveScale = self.minScale + (self.maxScale - self.minScale)/2.0;
    
    if (self.currentScale > aveScale) {
        
        self.currentScale = self.maxScale;
        [imageScrollView setZoomScale:self.currentScale animated:YES];
    }
    
    if (self.currentScale < aveScale) {
        
        self.currentScale = self.minScale;
        [imageScrollView setZoomScale:self.currentScale animated:YES];
    }
    
}
#pragma mark - Utils
- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - DJImagePreviewViewDelegate
- (NSUInteger)numberOfImagesInPreviewView:(DJImagePreviewView *)previewView{
    
    if (self.djDataType == DJImageDataTypeImage) {
         return self.previewImages.count;
    }else if (self.djDataType == DJImageDataTypeUrl){
        return self.previewImagesUrl.count;
    }else{
        return 0;
    }
   
}

- (void)imagePreviewView:(DJImagePreviewView *)imagePreviewView renderZoomImageView:(DJZoomImageView *)zoomImageView atIndex:(NSUInteger)index{
    [self requestImageForZoomView:zoomImageView atIndex:index];
}

- (void)imagePreviewView:(DJImagePreviewView *)imagePreviewView didScrollViewToIndex:(NSUInteger)index{
    NSUInteger displayIndex = index + 1;
    
    if (self.currentImageIndex == displayIndex) {
        return;
    }
    
    self.currentImageIndex = displayIndex;
    
}

#pragma mark - Getter/Setter

- (UIView *)indexTitleView{
    if (!_indexTitleView) {
        _indexTitleView = [[UIView alloc] init];
        _indexTitleView.width = 100;
        _indexTitleView.height = 50;
        _indexTitleView.centerX = self.view.center.x;
        _indexTitleView.y = 30;
        _indexTitleView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.frame = _indexTitleView.bounds;
        self.titleLabel.text = [NSString stringWithFormat:@"1/%ld",self.totalCount];
        [_indexTitleView addSubview:self.titleLabel];
    }
    
    return _indexTitleView;
}


- (UIScrollView *)imageScrollView{
    
    if (_imageScrollView == nil) {
        _imageScrollView = [[UIScrollView alloc] init];
        _imageScrollView.frame = CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        _imageScrollView.delegate = self;
        _imageScrollView.pagingEnabled = YES;
        _imageScrollView.tag = 500;
    }
    
    return _imageScrollView;
}


- (UIButton *)closeBtn{
    
    if (_closeBtn == nil) {
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.width = 45;
        _closeBtn.height = 35;
        _closeBtn.y = 25;
        _closeBtn.x = 15;
        [_closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //[self.closeBtn setBackgroundImage:[UIImage imageNamed:@"CorrectHomeworkIcon_cancelScan"] forState:UIControlStateNormal];
        [_closeBtn setTitle:@"Back" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _closeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _closeBtn;
}

- (UIButton *)deletePhotoBtn{
    
    if (_deletePhotoBtn == nil) {
        _deletePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deletePhotoBtn.width = 80;
        _deletePhotoBtn.height = 22;
        _deletePhotoBtn.y = 35;
        _deletePhotoBtn.x = SCREEN_WIDTH - 82;
        
        [_deletePhotoBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_deletePhotoBtn setTitle:@"Delete" forState:UIControlStateNormal];
        _deletePhotoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _deletePhotoBtn;
}


- (DJImagePreviewView *)djImagePreviewView{
    if (!_djImagePreviewView) {
        _djImagePreviewView = [[DJImagePreviewView alloc] initWithFrame:self.view.bounds];
        _djImagePreviewView.previewImages = self.previewImages;
        _djImagePreviewView.delegate = self;
    }
        
    return _djImagePreviewView;
}

-(void)setCurrentImageIndex:(NSInteger)currentImageIndex{
    _currentImageIndex = currentImageIndex;
    self.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.currentImageIndex,self.totalCount];
    
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
//    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
//    self.titleLabel.attributedText = attStr;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation DJImageBrowserVC (UIWindow)

- (void)presentPreviewFromRectInScreen:(CGRect)rect{
    [self presentPreviewWithFadeAnimation:NO orRect:rect];
}

- (void)dismissPreviewToRectInScreen:(CGRect)rect{
    [self dismissPreviewWithFadeAnimation:NO orToRect:rect];
}

- (void)present{
    
}

- (void)dismiss{
    
}


#pragma mark - Main animation

- (void)initPreviewWindowIfNeeded{
    //init preview window
    if (!self.previewWindow) {
        self.previewWindow = [[UIWindow alloc] init];
        self.previewWindow.windowLevel = 10000;
        self.previewWindow.backgroundColor = [UIColor clearColor];
    }
}


- (void)removePreviewWindow{
    self.previewWindow.hidden = YES;
    self.previewWindow.rootViewController = nil;
    self.previewWindow = nil;
    
}
//present self vc
- (void)presentPreviewWithFadeAnimation:(BOOL)isFading orRect:(CGRect)rect{
    
    self.shouldStartWithFading = isFading;
   
    if (isFading) {
        //fading anmation
        self.view.alpha = 0;
        
    }else{
        self.previewFromRect = rect;
        if (!self.transitionImageView) {
            self.transitionImageView = [[UIImageView alloc] init];
        }
        self.view.backgroundColor = [UIColor clearColor];
    }
    
    [self initPreviewWindowIfNeeded];
    self.previewWindow.rootViewController = self;
    self.previewWindow.hidden = NO;
}

//dismiss self vc
- (void)dismissPreviewWithFadeAnimation:(BOOL)isFading orToRect:(CGRect)rect{
    
    if (isFading) {
     
        return;
    }
    
    DJZoomImageView *zoomViewImage = [self.djImagePreviewView zoomImageViewAtIndex:self.currentImageIndex];
    CGRect fromRect = [zoomViewImage imageViewRectInZoomView];
    CGRect toRect = rect;
    
    self.transitionImageView.image = zoomViewImage.image;
    self.transitionImageView.frame = fromRect;
    [self.view addSubview:self.transitionImageView];
    self.djImagePreviewView.collectionView.hidden = YES;
    
    [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.transitionImageView.frame = toRect;
        self.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removePreviewWindow];
        self.view.backgroundColor = [UIColor blackColor];
        self.djImagePreviewView.collectionView.hidden = NO;
    }];
    
   
}
@end
