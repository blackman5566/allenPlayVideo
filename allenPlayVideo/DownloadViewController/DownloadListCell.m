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

#pragma mark - life cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self = arrayOfViews[0];
        self.isDownloading = YES;
    }
    return self;
}

#pragma mark - Button Action

- (IBAction)downloadAndStopButtonAction:(id)sender {
    NSIndexPath *indexPath = [[self dependTableView] indexPathForCell:self];
    if (!self.isDownloading) {
        [self.playAndStopButton setTitle:@"Pause" forState:UIControlStateNormal];
        [DownloadModel startTask:indexPath.row];
    }
    else {
        [self.playAndStopButton setTitle:@"Downloading" forState:UIControlStateNormal];
        [DownloadModel stopTask:indexPath.row];
    }
    self.isDownloading = !self.isDownloading;
}

#pragma mark - private method

- (UITableView *)dependTableView {
    UIView *findView = self.superview;
    while (![findView isKindOfClass:[UITableView class]]) {
        findView = findView.superview;
    }
    UITableView *table = (UITableView *)findView;
    return table;
}
@end
