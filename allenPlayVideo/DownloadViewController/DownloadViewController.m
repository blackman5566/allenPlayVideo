//
//  DownloadViewController.m
//  allenPlayVideo
//
//  Created by allen_hsu on 2015/12/28.
//  Copyright © 2015年 allen_hsu. All rights reserved.
//

#import "DownloadViewController.h"
#import "DaiYoutubeParser.h"
#import "DaiYoutubeParser.h"
#import "UIView+AnimationExtensions.h"
#import "AppDelegate.h"

@interface DownloadViewController () <NSURLSessionDownloadDelegate>

@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;

@property (strong, nonatomic) NSString *youtubeVideoID;
@property (strong, nonatomic) NSString *videoTitle;
@property (strong, nonatomic) NSMutableDictionary *listTakeDictionary;

@end

@implementation DownloadViewController

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
}

#pragma mark - instance private method

- (void)downLoadVideo {
    CGSize videoSize = self.webView.frame.size;
    [DaiYoutubeParser parse:self.youtubeVideoID screenSize:videoSize videoQuality:DaiYoutubeParserQualityLarge completion: ^(DaiYoutubeParserStatus status, NSString *url, NSString *videoTitle, NSNumber *videoDuration) {
         NSURL *videoUrl = [NSURL URLWithString:url];
         if (status) {
             self.videoTitle = videoTitle;
             NSURLSessionDownloadTask *task = [[self backgroundSession] downloadTaskWithRequest:[NSURLRequest requestWithURL:videoUrl]];
             [task resume];

         }
         else {
             NSLog(@"please check url or network !!");
         }
     }];
}

#pragma mark - NSURLSessionDownloadDelegate

- (NSURLSession *)backgroundSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.hiiir.allenPlayVideo.BackgroundSession"];
        session = [NSURLSession sessionWithConfiguration:configuration
                                                delegate:self
                                           delegateQueue:nil];
    });
    return session;
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
    didWriteData:(int64_t)bytesWritten
    totalBytesWritten:(int64_t)totalBytesWritten
    totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown) {
        float percent = (float)totalBytesWritten / totalBytesExpectedToWrite;
        NSLog(@"%f", percent);
    }
    else {

    }
}

- (void)URLSession:(NSURLSession *)session
    downloadTask:(NSURLSessionDownloadTask *)downloadTask
    didFinishDownloadingToURL:(NSURL *)location {
    if (location) {
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSString *fileName = [NSString stringWithFormat:@"%@.m4v", self.videoTitle];
        NSURL *tempURL = [documentsURL URLByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:tempURL error:nil];
    }
}

#pragma mark - init

- (void)setupWebView {
    self.webView.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:self.urlTextField.text];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

- (void)setupInitValue {
    self.title = @"下載";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.listTakeDictionary = [NSMutableDictionary new];
}

- (void)setupNaviButton {
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithTitle:@"下載進度"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(openListView)];
    self.navigationItem.leftBarButtonItem = listButton;
}

- (void)openListView {

}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitValue];
    [self setupWebView];
    [self setupNaviButton];
    [self.downloadButton pulseToSize:1.2f duration:0.4f repeat:YES];
}

@end