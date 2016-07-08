//
//  DJImageSource.h
//  DJBrowser
//
//  Created by 丁嘉 on 16/7/8.
//  Copyright © 2016年 yoanna. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DJImage;

@protocol DJImageSource <NSObject>

//The array has all DJImage object
@property (nonatomic,strong) NSArray<id <DJImage>> *images;

//The number of images(DJImage object)
@property (nonatomic,assign) NSUInteger imageCount;

//return DJImage object at index 
- (id <DJImage>)objectInImagesAtIndex:(NSUInteger)index;

//remove image object at index
- (void)removeObjectAtIndexe:(NSUInteger)index;
@end
