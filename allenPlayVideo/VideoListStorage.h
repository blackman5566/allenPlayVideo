//
//  VodeoListStorage.h
//  allenPlayVideo
//
//  Created by 許佳豪 on 2016/1/5.
//  Copyright © 2016年 allen_hsu. All rights reserved.
//

#import "DaiStorage.h"

DaiStorageArrayConverter(NSString)

@interface VideoListStorage : DaiStorage

@property (nonatomic, strong) NSStringArray *videoListInfoArrays;

@end
