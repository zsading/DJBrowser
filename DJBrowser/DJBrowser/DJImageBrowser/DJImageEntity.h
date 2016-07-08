//
//  DJImageEntity.h
//  DJBrowser
//
//  Created by 丁嘉 on 16/7/8.
//  Copyright © 2016年 yoanna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJFramework.h"


@interface DJImageEntity : NSObject<DJImage>


- (instancetype _Nonnull)initWithImageURL:(NSURL *_Nonnull)URL;

- (instancetype _Nonnull)initWithImage:(UIImage *_Nonnull)image;

@end
