//
//  DownloadListViewController.m
//  allenPlayVideo
//
//  Created by 許佳豪 on 2016/1/4.
//  Copyright © 2016年 allen_hsu. All rights reserved.
//

#import "DownloadListViewController.h"
#import "DownloadListCell.h"
@interface DownloadListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *taskInfoTableView;

@end

@implementation DownloadListViewController


#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DownloadListCell";
    DownloadListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    return cell;
}


#pragma mark - init

- (void)setupInitValue {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.taskInfoTableView.contentInset = UIEdgeInsetsMake(64, 0, 100, 0);
    self.title = @"下載";
}
- (void)setupTaskInfoTableView {
    [self.taskInfoTableView registerClass:[DownloadListCell class] forCellReuseIdentifier:@"DownloadListCell"];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitValue];
    [self setupTaskInfoTableView];
}

@end
