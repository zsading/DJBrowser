//
//  DJBrowserCtrl.h
//
//
//  Created by yoanna on 15/11/13.
//  Copyright © 2015年 yoanna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJBrowserCtrl : UIViewController

//滚动视图
@property (nonatomic,strong) UIScrollView *imageScrollView;
//父视图容器
@property (nonatomic,strong) UIView *sourceImagesContainerView;
//照片数组
@property (nonatomic,strong) NSMutableArray *imageArray;
//当前的index数量
@property (nonatomic,assign) NSInteger currentImageIndex;
//显示index的Label
@property (nonatomic,strong) UILabel *indexTitleLabel;
//全部的图片数量
@property (nonatomic,assign) NSInteger totalCount;
//关闭按钮
@property (nonatomic,strong) UIButton *closeBtn;
//删除按钮
@property (nonatomic,strong) UIButton *deletePhotoBtn;

#pragma mark - 回调相关
//删除回调
@property (nonatomic,copy) void (^deleteCallBack)(NSInteger index);
@end
