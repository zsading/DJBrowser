//
//  DJImagePreviewCell.m
//  DJBrowser
//
//  Created by VictorDing on 2017/3/2.
//  Copyright © 2017年 yoanna. All rights reserved.
//

#import "DJImagePreviewCell.h"

@interface DJImagePreviewCell ()


@end

@implementation DJImagePreviewCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.zoomImageView = [[DJZoomImageView alloc] init];
        [self.contentView addSubview:self.zoomImageView];
    }
    
    return self;
}


- (void)layoutSubviews{
    self.zoomImageView.frame = self.contentView.bounds;
}
@end
