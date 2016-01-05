//
//  VodeoListStorage.m
//  allenPlayVideo
//
//  Created by 許佳豪 on 2016/1/5.
//  Copyright © 2016年 allen_hsu. All rights reserved.
//

#import "VideoListStorage.h"

@implementation VideoListStorage

- (id)init {
    if (self = [super init]) {
        [self importPath:[DaiStoragePath document]];
    }
    return self;
}
@end
