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

@interface ViewController ()

@property (nonatomic,strong) DJBrowserCtrl *browCtrl;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //demo
    
    [self initData];
    
    self.browCtrl = [[DJBrowserCtrl alloc] init];
    self.browCtrl.imageArray = self.dataArray;
    self.browCtrl.deleteCallBack = ^(NSInteger index){
        
        
    };
    
    
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showBtn.width = 100;
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
    self.dataArray = [NSMutableArray arrayWithObjects:url,url2,url3,url4, nil];
}

- (void)showDJBrowser{
    [self initData];
    [self presentViewController:self.browCtrl animated:YES completion:nil];
    self.browCtrl.imageArray = self.dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
