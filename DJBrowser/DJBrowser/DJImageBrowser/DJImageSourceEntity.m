//
//  DJImageSourceEntity.m
//  DJBrowser
//
//  Created by 丁嘉 on 16/7/8.
//  Copyright © 2016年 yoanna. All rights reserved.
//

#import "DJImageSourceEntity.h"

@implementation DJImageSourceEntity
@synthesize images = _images;
@synthesize imageCount = _imageCount;


- (instancetype _Nonnull)initWithImages:(NSArray<id <DJImage>>* _Nonnull)images{
    
    if (self = [super init]) {
        self.images = images;
        self.imageCount = images.count;
    }
    
    return self;
}


- (id<DJImage>)objectInImagesAtIndex:(NSUInteger)index{
    return self.images[index];
}

- (void)removeObjectAtIndexe:(NSUInteger)index{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self.images];
    [mutableArray removeObjectAtIndex:index];
    self.images = mutableArray;
    self.imageCount = mutableArray.count;
}
@end
