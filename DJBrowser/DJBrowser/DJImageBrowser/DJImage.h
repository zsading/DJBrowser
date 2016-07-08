//
//  DJImage.h
//  DJBrowser
//
//  Created by 丁嘉 on 16/7/8.
//  Copyright © 2016年 yoanna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJFramework.h"

@protocol DJImage <NSObject>

//The image url
@property (nonatomic,strong) NSURL *imageURL;
//The image object (set if not use imageURL)
@property (nonatomic,strong) UIImage *dj_image;
@end
