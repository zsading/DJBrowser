//
//  DJBrowserCtrl.h
//
//
//  Created by yoanna on 15/11/13.
//  Copyright © 2015年 yoanna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJImageSource.h"
#import "DJImageSourceEntity.h"
#import "DJImageEntity.h"

@interface DJBrowserCtrl : UIViewController

//Image ScrollView
@property (nonatomic,strong) UIScrollView *imageScrollView;
//Images ContainerView
@property (nonatomic,strong) UIView *sourceImagesContainerView;
//Current index
@property (nonatomic,assign) NSInteger currentImageIndex;
//Show index Label
@property (nonatomic,strong) UILabel *indexTitleLabel;
//All images count
@property (nonatomic,assign) NSInteger totalCount;
//Dismiss button
@property (nonatomic,strong) UIButton *closeBtn;
//Delete button
@property (nonatomic,strong) UIButton *deletePhotoBtn;
//DJImageSourceEntity object
@property (nonatomic,strong) DJImageSourceEntity *dj_imageSource;

#pragma mark - CallBack
//delete action callback
@property (nonatomic,copy) void (^deleteCallBack)(NSInteger index);

#pragma mark - init methods
- (instancetype)initWithImageSource:(id <DJImageSource>)imageSource;

@end
