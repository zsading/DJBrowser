//
//  DJImageBrowserVC.h
//  DJBrowser
//
//  Created by VictorDing on 2017/3/2.
//  Copyright © 2017年 yoanna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJImageSource.h"
#import "DJImagePreviewView.h"


typedef enum : NSUInteger {
    DJImageDataTypeImage,
    DJImageDataTypeUrl,
} DJImageDataType;

typedef void(^DeleteCallback)(NSUInteger currentIndex);
typedef void(^DismissCallback)(NSUInteger currentIndex);


@interface DJImageBrowserVC : UIViewController <DJImagePreviewViewDelegate>

//Image ScrollView
@property (nonatomic,strong) UIScrollView *imageScrollView;
//Images ContainerView
@property (nonatomic,strong) UIView *sourceImagesContainerView;
//Current index
@property (nonatomic,assign) NSInteger currentImageIndex;
//Show current image index View
@property (nonatomic,strong) UIView *indexTitleView;
//All images count
@property (nonatomic,assign) NSInteger totalCount;
//Dismiss button
@property (nonatomic,strong) UIButton *closeBtn;
//Delete button
@property (nonatomic,strong) UIButton *deletePhotoBtn;
//Data source type
@property (nonatomic,assign) DJImageDataType djDataType;
//Manage the main subviews
@property(nonatomic,strong) DJImagePreviewView *djImagePreviewView;

#pragma mark - CallBack
//delete action callback
//@property (nonatomic,copy) void (^deleteCallBack)(NSInteger index);
- (void)deleteImageWithCallback:(DeleteCallback)deleteCallback;
- (void)dismissPreviewToRectInScreen:(CGRect)rect dismissCallback:(DismissCallback)dismissCallback;


#pragma mark - init methods
- (instancetype)initWithImages:(NSArray *)images;
- (instancetype)initWithImageUrls:(NSArray *)urls;


//set preview images 
- (void)setImages:(NSArray<UIImage *> *)images;
//set preview images Url
- (void)setImagesUrl:(NSArray<NSURL *> *)imagesUrl;
@end


@interface DJImageBrowserVC (UIWindow)
- (void)presentPreviewFromRectInScreen:(CGRect)rect;
- (void)dismissPreviewToRectInScreen:(CGRect)rect;

- (void)present;
- (void)dismiss;
@end
