//
//  DownloadListViewController.m
//  allenPlayVideo
//
//  Created by 許佳豪 on 2016/1/4.
//  Copyright © 2016年 allen_hsu. All rights reserved.
//

#import "DownloadListViewController.h"
#import "DownloadListCell.h"
#import "DownloadModel.h"
#import "FileDownloadInfo.h"
#import "VideoListStorage.h"

@interface DownloadListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *taskInfoTableView;

@end

@implementation DownloadListViewController


#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [DownloadModel cancelTask:indexPath.row];
        [self.taskInfoTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DownloadModel fileInfoArrays].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DownloadListCell";
    DownloadListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    FileDownloadInfo *fileInfo  = [DownloadModel fileInfoArrays][indexPath.row];
    cell.videoNameLabel.text = fileInfo.fileTitle;
    cell.progressLabel.text = @"0.0";
    cell.progressView.progress = fileInfo.downloadProgress;
    return cell;
}

#pragma mark - private instance method

#pragma mark * init

- (void)setupInitValue {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.taskInfoTableView.contentInset = UIEdgeInsetsMake(64, 0, 100, 0);
    self.title = @"下載";
}

- (void)setupTaskInfoTableView {
    [self.taskInfoTableView registerClass:[DownloadListCell class] forCellReuseIdentifier:@"DownloadListCell"];
    self.taskInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupNaviButton {
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithTitle:@"下載"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self.taskInfoTableView
                                                                  action:@selector(reloadData)];
    self.navigationItem.leftBarButtonItem = listButton;
}

- (void)setupBlocks {
    __weak typeof(self) weakSelf = self;
    [DownloadModel downloadProgressUpdateBlock: ^(NSURLSessionDownloadTask *downloadTask, CGFloat bytesWritten, CGFloat totalBytesWritten, CGFloat totalBytesExpectedToWrite) {
         FileDownloadInfo *fileInfo;
         for (fileInfo in [DownloadModel fileInfoArrays]) {
             if (fileInfo.taskIdentifier == downloadTask.taskIdentifier) {
                 break;
             }
         }
        dispatch_sync(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            fileInfo.downloadProgress = totalBytesWritten / totalBytesExpectedToWrite;
            NSInteger index = [[DownloadModel fileInfoArrays] indexOfObject:fileInfo];
            DownloadListCell *cell = [strongSelf.taskInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            cell.progressView.progress = fileInfo.downloadProgress;
            cell.progressLabel.text = [NSString stringWithFormat:@"%1.1f", fileInfo.downloadProgress * 100];
        });
    }];

    [DownloadModel downloadFinishCallBackBlockcompletion: ^{
         [weakSelf.taskInfoTableView reloadData];
     }];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitValue];
    [self setupTaskInfoTableView];
    [self setupNaviButton];
    [self setupBlocks];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.taskInfoTableView reloadData];
}

@end
