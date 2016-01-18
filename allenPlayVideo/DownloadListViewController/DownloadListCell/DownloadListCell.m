//
//  DownloadListCell.m
//  allenPlayVideo
//
//  Created by 許佳豪 on 2016/1/4.
//  Copyright © 2016年 allen_hsu. All rights reserved.
//

#import "DownloadListCell.h"
#import "DownloadModel.h"

@interface DownloadListCell ()

@property(nonatomic, assign) BOOL isDownloading;

@end

@implementation DownloadListCell

#pragma mark - Button Action

- (IBAction)downloadAndStopButtonAction:(id)sender {
    if (self.isDownloading) {
        [self.playAndStopButton setTitle:@"Down" forState:UIControlStateNormal];
        [DownloadModel stopTask:[self indexPath].row];
        self.pauseView.hidden = NO;
    }
    else {
        [self.playAndStopButton setTitle:@"Pause" forState:UIControlStateNormal];
        [DownloadModel startTask:[self indexPath].row];
        self.pauseView.hidden = YES;
    }
    self.isDownloading = !self.isDownloading;
}

#pragma mark - life cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isDownloading = YES;
        self.pauseView.hidden = YES;
    }
    return self;
}

@end
