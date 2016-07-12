//
//  ViewController.m
//  DJBrowser
//
//  Created by yoanna on 16/2/1.
//  Copyright © 2016年 yoanna. All rights reserved.
//

#import "DJBrowserCtrl.h"
#import "ViewController.h"
#import "UIView+Layout.h"
#import "DJImageSourceEntity.h"
#import "DJImageEntity.h"

@interface ViewController ()

@property (nonatomic,strong) DJBrowserCtrl *browCtrl;
//@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) DJImageSourceEntity *myImageSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //demo
    
    [self initData];
    
    
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showBtn.width = 200;
    showBtn.height = 50;
    showBtn.center = self.view.center;
    [showBtn setTitle:@"click me show demo" forState:UIControlStateNormal];
    [showBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:showBtn];
    [showBtn addTarget:self action:@selector(showDJBrowser) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)initData{
    
    NSURL *url = [NSURL URLWithString:@"http://upload-images.jianshu.io/upload_images/195046-aa5f38ebb7475e42.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
    NSURL *url2 = [NSURL URLWithString:@"http://upload-images.jianshu.io/upload_images/1476423-2a26124e01149553.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
    NSURL *url3 = [NSURL URLWithString:@"http://upload-images.jianshu.io/upload_images/1476423-00b20746c7046090.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
    NSURL *url4 = [NSURL URLWithString:@"http://upload-images.jianshu.io/upload_images/1476423-8a57c3f235111cbb.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
    
    DJImageEntity *di_image1 = [[DJImageEntity alloc] initWithImageURL:url];
    DJImageEntity *di_image2 = [[DJImageEntity alloc] initWithImageURL:url2];
    DJImageEntity *di_image3 = [[DJImageEntity alloc] initWithImageURL:url3];
    DJImageEntity *di_image4 = [[DJImageEntity alloc] initWithImageURL:url4];
    
    DJImageSourceEntity *imageSource = [[DJImageSourceEntity alloc] initWithImages:@[di_image1,di_image2,di_image3,di_image4]];
    self.myImageSource = imageSource;
}

- (void)showDJBrowser{
    [self initData];
    
    self.browCtrl = [[DJBrowserCtrl alloc] initWithImageSource:self.myImageSource];
    self.browCtrl.deleteCallBack = ^(NSInteger index){
        NSLog(@"Delete index is %ld",index);
    };
    
    [self presentViewController:self.browCtrl animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
