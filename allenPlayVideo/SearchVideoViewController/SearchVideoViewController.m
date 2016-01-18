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
    // 第一種
    // https://www.youtube.com/watch?v=ce_MeFj_BWE
    // webView 回的格式為
    // https://m.youtube.com/watch?v=ce_MeFj_BWE

    // 第二種
    // http://youtu.be/ce_MeFj_BWE
    // webView 回的格式為
    // https://m.youtube.com/watch?feature=youtu.be&v=ce_MeFj_BWE

    // 第三種
    // https://m.youtube.com/watch?v=ce_MeFj_BWE
    // webView 回的格式為
    // https://m.youtube.com/watch?v=ce_MeFj_BWE

    // 第四種
    // https://www.youtube.com/watch?v=2AUhPKJvslo&index=2&list=RDGV3Bz2_Pw98
    // webView 回的格式為
    // https://m.youtube.com/watch?index=7&v=AUg9OG5i4wQ&list=PLsyOSbh5bs16vubvKePAQ1x3PhKavfBIl

    NSURL *url = webView.request.URL;
    NSArray *splitUsingAnd = [url.query componentsSeparatedByString:@"&"];
    for (NSString *keyWord in splitUsingAnd) {
        NSArray *splitUsingEqual = [keyWord componentsSeparatedByString:@"="];
        if ([splitUsingEqual[0] isEqualToString:@"v"]) {
            self.youtubeVideoID = [splitUsingEqual lastObject];
        }
    }
    NSLog(@"self.youtubeVideoID = %@", self.youtubeVideoID);
    NSLog(@"url = %@", url);
    [self.downloadButton pulseToSize:1.2f duration:0.4f repeat:YES];
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