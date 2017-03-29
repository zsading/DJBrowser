//
//  ViewController.m
//  DJBrowser
//
//  Created by yoanna on 16/2/1.
//  Copyright © 2016年 yoanna. All rights reserved.
//

#import "DJImageBrowserVC.h"
#import "ViewController.h"
#import "UIView+Layout.h"


#define CurrentDataType 0
#define UrlData 0
#define ImageData 1
@interface ViewController ()

@property (nonatomic,strong) DJImageBrowserVC *browCtrl;
//@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton *showBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //demo
    
    [self initData];
    
    
    self.showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.showBtn.width = 80;
    self.showBtn.height = 80;
    self.showBtn.center = self.view.center;
//    [showBtn setTitle:@"click me show demo" forState:UIControlStateNormal];
    [self.showBtn setImage:[UIImage imageNamed:@"image0"] forState:UIControlStateNormal];
    [self.showBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:self.showBtn];
    [self.showBtn addTarget:self action:@selector(showDJBrowser) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)initData{
   
//    
//    NSArray *imageArray = @[image0,image1,image2,image3,image4,image5];
//    DJImageSourceEntity *imageSource = [[DJImageSourceEntity alloc] initWithImages:imageArray];
//    self.myImageSource = imageSource;
}

- (NSArray *)createDataWithType:(NSUInteger)type{
    
    NSArray *dataArray = nil;
    if (type == UrlData) {
        //urls
        NSURL *url = [NSURL URLWithString:@"http://upload-images.jianshu.io/upload_images/195046-aa5f38ebb7475e42.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
        NSURL *url2 = [NSURL URLWithString:@"http://upload-images.jianshu.io/upload_images/1476423-2a26124e01149553.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
        NSURL *url3 = [NSURL URLWithString:@"http://upload-images.jianshu.io/upload_images/1476423-00b20746c7046090.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
        NSURL *url4 = [NSURL URLWithString:@"http://upload-images.jianshu.io/upload_images/1476423-8a57c3f235111cbb.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
        dataArray = @[url,url2,url3,url4];
        
        
    }else if (type == ImageData){
        //image
        UIImage *image0 = [UIImage imageNamed:@"image0"];
        UIImage *image1 = [UIImage imageNamed:@"image1"];
        UIImage *image2 = [UIImage imageNamed:@"image2"];
        UIImage *image3 = [UIImage imageNamed:@"image3"];
        UIImage *image4 = [UIImage imageNamed:@"image4"];
        UIImage *image5 = [UIImage imageNamed:@"image5"];
        
        dataArray = @[image0,image1,image2,image3,image4,image5];
        
    }
    
    
    return dataArray;
}

- (void)showDJBrowser{
    
    
    NSArray *imageArray = [self createDataWithType:CurrentDataType];
    
    
    if (CurrentDataType == UrlData) {
        self.browCtrl = [[DJImageBrowserVC alloc] initWithImageUrls:imageArray];
        self.browCtrl.djDataType = DJImageDataTypeUrl;
    }else if (CurrentDataType == ImageData){
        self.browCtrl = [[DJImageBrowserVC alloc] initWithImages:imageArray];
        self.browCtrl.djDataType = DJImageDataTypeImage;
    }
    
    [self.browCtrl dismissPreviewToRectInScreen:self.showBtn.frame dismissCallback:^(NSUInteger currentIndex) {
        NSLog(@"DJImgaeBrowser has been dismissed");
    }];
    
    [self.browCtrl deleteImageWithCallback:^(NSUInteger currentIndex) {
        NSLog(@"Delete image in currentIndex:%ld",currentIndex);
    }];
    
    [self.browCtrl presentPreviewFromRectInScreen:self.showBtn.frame];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
