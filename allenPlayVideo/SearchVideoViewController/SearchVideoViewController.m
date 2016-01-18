//
//  DownloadViewController.m
//  allenPlayVideo
//
//  Created by allen_hsu on 2015/12/28.
//  Copyright © 2015年 allen_hsu. All rights reserved.
//

#import "SearchVideoViewController.h"
#import "DaiYoutubeParser.h"
#import "UIView+AnimationExtensions.h"
#import "AppDelegate.h"
#import "DownloadListViewController.h"
#import "DownloadModel.h"

@interface SearchVideoViewController ()

@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;

@property (strong, nonatomic) NSString *youtubeVideoID;

@end

@implementation SearchVideoViewController

#pragma mark - UIButton Action

- (IBAction)downLoadButtonAction:(id)sender {
    [self downLoadVideo];
}

- (IBAction)loadWebPage:(id)sender {
    [self setupWebView];
}

#pragma mark - UIWebView Deleage

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.youtubeVideoID = [webView.request.URL youtubeVideoID];
}

#pragma mark - instance private method

- (void)downLoadVideo {
    CGSize videoSize = self.webView.frame.size;
    [DaiYoutubeParser parse:self.youtubeVideoID screenSize:videoSize videoQuality:DaiYoutubeParserQualityLarge completion: ^(DaiYoutubeParserStatus status, NSString *url, NSString *videoTitle, NSNumber *videoDuration) {
         NSURL *videoUrl = [NSURL URLWithString:url];
         if (status) {
             [DownloadModel downloadVideo:videoTitle videoUrl:videoUrl];
         }
         else {
             NSLog(@"please check url or network !!");
         }
     }];
}

#pragma mark - init

- (void)setupWebView {
    self.webView.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:self.urlTextField.text];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

- (void)setupInitValue {
    self.title = @"搜尋";
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupNaviButton {
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithTitle:@"下載進度"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(openListView)];
    self.navigationItem.leftBarButtonItem = listButton;
}

- (void)openListView {
    [self downLoadVideo];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitValue];
    [self setupWebView];
    [self setupNaviButton];
}

@end