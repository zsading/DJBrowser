//
//  DJImageEntity.m
//  DJBrowser
//
//  Created by 丁嘉 on 16/7/8.
//  Copyright © 2016年 yoanna. All rights reserved.
//

#import "DJImageEntity.h"



@implementation DJImageEntity

@synthesize dj_image = _dj_image;
@synthesize imageURL = _imageURL;


- (instancetype)initWithImage:(UIImage *)image imageURL:(NSURL *)URL{
    self = [super init];
    if (self) {
        self.dj_image = image;
        self.imageURL = URL;
    }
    
    return self;
}


- (instancetype)initWithImage:(UIImage *)image{
    return [self initWithImage:image imageURL:nil];
}

- (instancetype)initWithImageURL:(NSURL *)URL{
    return [self initWithImage:nil imageURL:URL];
}
@end
