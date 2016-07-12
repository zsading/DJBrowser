//
//  DJBrowserCtrl.m
//  lswuyou
//
//  Created by yoanna on 15/11/13.
//  Copyright © 2015年 yoanna. All rights reserved.
//

#import "DJBrowserCtrl.h"
#import "UIImageView+WebCache.h"
#import "UIView+Layout.h"


#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface DJBrowserCtrl ()<UIScrollViewDelegate>


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


@end

@implementation DJBrowserCtrl


- (instancetype)initWithImageSource:(id<DJImageSource>)imageSource{
    
    if (self = [super init]) {
        self.dj_imageSource = imageSource;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.view showPlaceHolderWithAllSubviews];
    
    [self.view addSubview:self.indexTitleLabel];//Add title Label
    [self.view addSubview:self.imageScrollView];//Add ScrollView
    [self.view addSubview:self.closeBtn];// Add CloseButton
    [self.view addSubview:self.deletePhotoBtn];//Add DeletePhoto Button
    
    [self.view addGestureRecognizer:self.doubleTap];
    
    self.scrollViewImageHeights = [NSMutableArray array];
    
    self.maxScale = 2.0;
    self.minScale = 1.0;
    self.currentScale = 1;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initWithImageArray];
}

- (UITapGestureRecognizer *)doubleTap{
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired = 1;
    }
    return _doubleTap;
}

-(void)setSourceImagesContainerView:(UIView *)sourceImagesContainerView{
    
    _sourceImagesContainerView = sourceImagesContainerView;
//    初始化所有视图
    [self initWithAllView];
}

- (void)initWithImageArray{
    
    [self.imageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0;i < self.dj_imageSource.imageCount;i++) {
        
        UIScrollView *singleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH,0, self.imageScrollView.width, self.imageScrollView.height)];
        singleScrollView.tag = 4000+i;
        singleScrollView.maximumZoomScale = 2.0;
        singleScrollView.minimumZoomScale = 1.0;
        singleScrollView.decelerationRate = 1.0;
        singleScrollView.zoomScale = 1.0;
        
        singleScrollView.delegate = self;
        singleScrollView.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2-SCREEN_WIDTH/2, SCREEN_WIDTH, SCREEN_WIDTH)];
        imageView.tag = 3000+i;
        imageView.userInteractionEnabled = YES;
        [self.imageScrollView addSubview:singleScrollView];
        [singleScrollView addSubview:imageView];
        
        DJImageEntity *imageEntity = self.dj_imageSource.images[i];
        
        if (imageEntity.imageURL == nil || [imageEntity.imageURL.absoluteString isEqualToString:@""]) {
            imageView.image = imageEntity.dj_image;
            
        }else{
            
            [imageView sd_setImageWithURL:imageEntity.imageURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                CGFloat scale = image.size.width/image.size.height;
                CGFloat imageViewHeight = SCREEN_WIDTH / scale;
                imageView.height = imageViewHeight;
                imageView.centerY = self.imageScrollView.height/2;
                
                [self.scrollViewImageHeights addObject:[NSNumber numberWithDouble:imageViewHeight]];
                
            }];
            
        }
    }
    
    [self changeImageScrollViewByContentSize];
    self.indexTitleLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.currentImageIndex+1,(long)self.dj_imageSource.imageCount];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.indexTitleLabel.text];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    self.indexTitleLabel.attributedText = attStr;
}

-(void)initWithAllView{
    
    for (UIImageView *imageView in self.sourceImagesContainerView.subviews) {
//        NSLog(@"%ld",imageView.tag);
        if (imageView.hidden) {
            return;
        }
        UIScrollView *subScrollView = [[UIScrollView alloc] init];
      
        UIImage *image = imageView.image;
        CGFloat scale = image.size.width/image.size.height;
        CGFloat imageViewHeight = SCREEN_WIDTH / scale;

        imageView.size = CGSizeMake(SCREEN_WIDTH, imageViewHeight);
        imageView.x = 0;
        imageView.y = 0;
        
        subScrollView.frame = self.imageScrollView.bounds;
        subScrollView.x = self.totalCount *SCREEN_WIDTH;
        subScrollView.contentSize = imageView.size;
        subScrollView.tag = 100 +self.totalCount;
        [subScrollView addSubview:imageView];
        [self.imageScrollView addSubview:subScrollView];
        [self.scrollViewImageHeights addObject:[NSNumber numberWithDouble:imageViewHeight]];
        self.totalCount ++;
    }
    self.imageScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.totalCount, 0);
    
    self.indexTitleLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.currentImageIndex+1,(long)self.totalCount];
    
//    [self.view showPlaceHolderWithAllSubviews];
}

-(void)setCurrentImageIndex:(NSInteger)currentImageIndex{
    _currentImageIndex = currentImageIndex;
    self.indexTitleLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.currentImageIndex+1,(long)self.dj_imageSource.imageCount];
//    [self.imageScrollView setContentOffset:CGPointMake(self.currentImageIndex*SCREEN_WIDTH, 0)];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.indexTitleLabel.text];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    self.indexTitleLabel.attributedText = attStr;
    
    [self changeImageScrollViewByContentSize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
-(void)closeBtnAction:(UIButton *)btn{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)deleteBtnAction:(UIButton *)btn{

//    remove imageView
    for (UIScrollView *subScrollView in self.imageScrollView.subviews) {
        
        //find scrollView
        if ((subScrollView.tag - 4000) == self.currentImageIndex) {
            //remove
            [subScrollView removeFromSuperview];
            [self.dj_imageSource removeObjectAtIndexe:self.currentImageIndex];
            
            //deal after delete
            [self initWithImageArray];
            
            //callback
            if (self.dj_imageSource.imageCount == 0) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
                if (self.deleteCallBack) {
                    self.deleteCallBack(0);
                }
                
            }else{
                if (self.deleteCallBack) {
                    self.deleteCallBack(self.currentImageIndex);
                }
            }
            
            
        }
    }
    
    
}



#pragma mark - scrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"scrollView.contentOffset.x:%lf",scrollView.contentOffset.x);
    
    if (scrollView.tag == 500) {
        NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
        if (!self.isZoom) {
            self.currentImageIndex = index;
            [self changeImageScrollViewByContentSize];
        }
    }
    
  
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    CGSize boundsSize = scrollView.bounds.size;
    UIImageView *imageView= [self.view viewWithTag:scrollView.tag - 1000];
    CGRect contentsFrame = imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    imageView.frame = contentsFrame;
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    self.isZoom = NO;
    self.currentScale = scale;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    
    self.isZoom = YES;
}

- (void)changeImageScrollViewByContentSize{
    
//    UIImageView *imageView = [self.view viewWithTag:self.currentImageIndex + 3000];
    self.imageScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.dj_imageSource.imageCount,0);
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation ==UIInterfaceOrientationPortrait||interfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown)
    {
        return YES;
    }
    return NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView ==self.imageScrollView){
        CGFloat x = scrollView.contentOffset.x;
        if (x==-333){
            
        }
        else {
            //            offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0]; //reset the view's zoomScacle to 1
                }
            }
        }
    }
}


#pragma mark - double click
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

#pragma mark - Getter/Setter

- (UILabel *)indexTitleLabel{
    
    if (_indexTitleLabel == nil) {
        _indexTitleLabel = [[UILabel alloc] init];
        _indexTitleLabel.textColor = [UIColor whiteColor];
        _indexTitleLabel.width = 100;
        _indexTitleLabel.height = 50;
        _indexTitleLabel.centerX = self.view.center.x;
        _indexTitleLabel.y = 30;
        _indexTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _indexTitleLabel;
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
        _deletePhotoBtn.width = 42;
        _deletePhotoBtn.height = 22;
        _deletePhotoBtn.y = 35;
        _deletePhotoBtn.x = SCREEN_WIDTH - 52;
        
        [_deletePhotoBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_deletePhotoBtn setTitle:@"Del" forState:UIControlStateNormal];
        _deletePhotoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _deletePhotoBtn;
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
