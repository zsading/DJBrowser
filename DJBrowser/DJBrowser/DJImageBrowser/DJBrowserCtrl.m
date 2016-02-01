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
//双击
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;
//当前的比例
@property (nonatomic,assign) CGFloat currentScale;
//最大比例
@property (nonatomic,assign) CGFloat maxScale;
//最小比例
@property (nonatomic,assign) CGFloat minScale;
//是否正在放大缩小
@property (nonatomic,assign) BOOL isZoom;
@end

@implementation DJBrowserCtrl

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self createIndexTitleLabel];
        [self createScrollView];
        [self createCloseBtn];
        [self createDeletePhotoBtn];
        
        self.scrollViewImageHeights = [NSMutableArray array];
        [self.view addGestureRecognizer:self.doubleTap];
        self.maxScale = 2.0;
        self.minScale = 1.0;
        self.currentScale = 1;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.view showPlaceHolderWithAllSubviews];
}

- (void)createCloseBtn
{
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.closeBtn.width = 45;
    self.closeBtn.height = 35;
    self.closeBtn.y = 25;
    self.closeBtn.x = 15;
    
    [self.closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"CorrectHomeworkIcon_cancelScan"] forState:UIControlStateNormal];
    [self.closeBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.closeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.closeBtn];
}

- (void)createDeletePhotoBtn
{
    self.deletePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.deletePhotoBtn.width = 42;
    self.deletePhotoBtn.height = 22;
    self.deletePhotoBtn.y = 35;
    self.deletePhotoBtn.x = SCREEN_WIDTH - 52;
    
    [self.deletePhotoBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.deletePhotoBtn setTitle:@"删除" forState:UIControlStateNormal];
    self.deletePhotoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.deletePhotoBtn];
}

- (void)createScrollView
{
    self.imageScrollView = [[UIScrollView alloc] init];
    
    self.imageScrollView.frame = CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.imageScrollView.delegate = self;
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.tag = 500;
    [self.view addSubview:self.imageScrollView];
}

- (void)createIndexTitleLabel
{
    self.indexTitleLabel = [[UILabel alloc] init];
    self.indexTitleLabel.textColor = [UIColor whiteColor];
    self.indexTitleLabel.width = 100;
    self.indexTitleLabel.height = 50;
    self.indexTitleLabel.centerX = self.view.center.x;
    self.indexTitleLabel.y = 30;
    self.indexTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.indexTitleLabel];
    
}

- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired = 1;
    }
    return _doubleTap;
}

-(void)setSourceImagesContainerView:(UIView *)sourceImagesContainerView
{
    _sourceImagesContainerView = sourceImagesContainerView;
//    初始化所有视图
    [self initWithAllView];
}

- (void)setImageArray:(NSMutableArray *)imageArray{
    _imageArray = imageArray;
    [self initWithImageArray];
}

- (void)initWithImageArray{
    
    
    [self.imageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0;i < self.imageArray.count;i++) {
        
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
        
        [imageView sd_setImageWithURL:self.imageArray[i] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
           
            CGFloat scale = image.size.width/image.size.height;
            CGFloat imageViewHeight = SCREEN_WIDTH / scale;
            imageView.height = imageViewHeight;
            imageView.centerY = self.imageScrollView.height/2;
            
            [self.scrollViewImageHeights addObject:[NSNumber numberWithDouble:imageViewHeight]];
            
        }];
        
        
    }
    [self changeImageScrollViewByContentSize];
    self.indexTitleLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.currentImageIndex+1,(long)self.imageArray.count];
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

-(void)setCurrentImageIndex:(NSInteger)currentImageIndex
{
    _currentImageIndex = currentImageIndex;
    self.indexTitleLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.currentImageIndex+1,(long)self.imageArray.count];
//    [self.imageScrollView setContentOffset:CGPointMake(self.currentImageIndex*SCREEN_WIDTH, 0)];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.indexTitleLabel.text];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    self.indexTitleLabel.attributedText = attStr;
    
    [self changeImageScrollViewByContentSize];
}

-(void)setTotalCount:(NSInteger)totalCount
{

    
//    _totalCount = totalCount;
//    self.indexTitleLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.currentImageIndex+1,(long)self.totalCount];
//    
//    if (self.totalCount == self.currentImageIndex) {
//        self.currentImageIndex --;
//    }else{
//        self.imageScrollView.contentSize = CGSizeMake(self.totalCount*SCREEN_WIDTH,0);
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
-(void)closeBtnAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)deleteBtnAction:(UIButton *)btn{

//    将imageView移去
    for (UIScrollView *subScrollView in self.imageScrollView.subviews) {
        
        //遍历找到当前的scrollView
        if ((subScrollView.tag - 4000) == self.currentImageIndex) {
            //移除
            [subScrollView removeFromSuperview];
            [self.imageArray removeObjectAtIndex:self.currentImageIndex];
            
            //填补删除的空缺
            [self initWithImageArray];
            
            //回调
            if (self.imageArray.count == 0) {
                
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
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
//    self.currentImageIndex = index;
//    self.imageScrollView.contentSize = CGSizeMake(self.imageScrollView.contentSize.width, [self.scrollViewImageHeights[index] doubleValue]);
//}

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
    self.imageScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.imageArray.count,0);
    
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
                    [s setZoomScale:1.0]; //scrollView每滑动一次将要出现的图片较正常时候图片的倍数（将要出现的图片显示的倍数）
                }
            }
        }
    }
}


#pragma mark 双击
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
