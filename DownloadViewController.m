//
//  DownloadViewController.m
//  allenPlayVideo
//
//  Created by allen_hsu on 2015/12/28.
//  Copyright © 2015年 allen_hsu. All rights reserved.
//

#import "DownloadViewController.h"
#import "DaiYoutubeParser.h"

@interface DownloadViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;

@property (strong, nonatomic) NSString *youtubeVideoID;

@end

@implementation DownloadViewController

#pragma mark - UIButton Action

- (IBAction)loadWebPage:(id)sender {
    // [self setupWebView];
    [self downLoadVideo];
}

#pragma mark - UIWebView Deleage

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 第一種
    // https://www.youtube.com/watch?v=ce_MeFj_BWE
    // 回
    // https://m.youtube.com/watch?v=ce_MeFj_BWE

    // 第二種
    // http://youtu.be/ce_MeFj_BWE
    // 回
    // https://m.youtube.com/watch?feature=youtu.be&v=ce_MeFj_BWE

    // 第三種
    // https://m.youtube.com/watch?v=ce_MeFj_BWE
    // 回
    // https://m.youtube.com/watch?v=ce_MeFj_BWE

    NSString *urlString = webView.request.URL.absoluteString;
    NSArray *splitUsingEqual = [urlString componentsSeparatedByString:@"="];
    self.youtubeVideoID = [splitUsingEqual lastObject];
}

#pragma mark - instance private method

- (void)downLoadVideo {
    CGSize videoSize = self.webView.frame.size;
    [DaiYoutubeParser parse:self.youtubeVideoID screenSize:videoSize videoQuality:DaiYoutubeParserQualityLarge completion: ^(DaiYoutubeParserStatus status, NSString *url, NSString *videoTitle, NSNumber *videoDuration) {
         if (status == DaiYoutubeParserStatusSuccess) {

         }
         else {
             NSLog(@"please check url or network !!");
         }
     }];
}
#pragma mark * init

- (void)setupWebView {
    self.webView.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:self.urlTextField.text];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

- (void)setupInitValue {
    self.title = @"download";
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitValue];
    [self setupWebView];
}

@end