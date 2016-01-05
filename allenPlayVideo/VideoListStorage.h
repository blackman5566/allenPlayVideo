//
//  VodeoListStorage.h
//  allenPlayVideo
//
//  Created by 許佳豪 on 2016/1/5.
//  Copyright © 2016年 allen_hsu. All rights reserved.
//

#import "DaiStorage.h"
DaiStorageArrayConverter(fileInfo)
DaiStorageArrayConverter(videoList)

@interface VideoListStorage : DaiStorage

@property (nonatomic, strong) fileInfoArray *fileInfoArrays;
@property (nonatomic, strong) videoListArray *videoListInfoArrays;

@end
