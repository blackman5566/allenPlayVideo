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

@interface DownloadListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *taskInfoTableView;

@end

@implementation DownloadListViewController


#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DownloadModel fileDownloadDataArrays].count;
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

- (void)setupNaviButton {
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithTitle:@"下載進度"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(openListView)];
    self.navigationItem.leftBarButtonItem = listButton;
}
-(void)openListView{
    [self.taskInfoTableView reloadData];
}
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitValue];
    [self setupTaskInfoTableView];
    [self setupNaviButton];
}

@end
