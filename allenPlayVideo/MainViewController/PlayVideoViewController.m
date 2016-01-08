//
//  MainViewController.m
//  allenPlayVideo
//
//  Created by allen_hsu on 2015/12/28.
//  Copyright © 2015年 allen_hsu. All rights reserved.
//

#import "PlayVideoViewController.h"
#import "PlayVideoView.h"
#import "VideoListStorage.h"
#import "PlayVideoCell.h"

@interface PlayVideoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *videoInfoTableView;
@property(nonatomic, strong) PlayVideoView *playVideo;
@property(nonatomic, strong) NSMutableArray *videoFile;

@end

@implementation PlayVideoViewController

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.playVideo didVideoSelect:indexPath.row];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.playVideo removeVideo:indexPath.row callBack:^{
            [[VideoListStorage shared] exportPath:[DaiStoragePath document]];
        }];
        [self.videoInfoTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoFile.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PlayVideoCell";
    PlayVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSString *videoTitle = self.videoFile[indexPath.row];
    cell.videoTitle.text = videoTitle;
    cell.videoImage.image = [self.playVideo videoImage:indexPath.row];
    return cell;
}

#pragma mark - private method

- (void)setupInitValue {
    self.title = @"影片";
    self.navigationController.navigationBar.hidden = YES;
}

- (void)setupVideoView {
    self.videoFile = [VideoListStorage shared].videoListInfoArrays;
    self.playVideo = [PlayVideoView new];
    [self.view addSubview:self.playVideo];
    [self.playVideo initVideoData:[VideoListStorage shared].videoListInfoArrays];
}

- (void)setupVideoInfoTableView {
    [self.videoInfoTableView registerClass:[PlayVideoCell class] forCellReuseIdentifier:@"PlayVideoCell"];
    self.videoInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitValue];
    [self setupVideoView];
    [self setupVideoInfoTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.videoInfoTableView reloadData];
}

@end
