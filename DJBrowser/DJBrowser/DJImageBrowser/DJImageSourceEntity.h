//
//  DJImageSourceEntity.h
//  DJBrowser
//
//  Created by 丁嘉 on 16/7/8.
//  Copyright © 2016年 yoanna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJImageSource.h"

@interface DJImageSourceEntity : NSObject<DJImageSource>

- (instancetype _Nonnull)initWithImages:(NSArray<id <DJImage>>* _Nonnull)images;
@end
