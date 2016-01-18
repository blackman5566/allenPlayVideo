//
//  NSURL+Category.m
//  allenPlayVideo
//
//  Created by daisuke on 2015/12/31.
//  Copyright © 2015年 allen_hsu. All rights reserved.
//

#import "NSURL+Category.h"

@implementation NSURL (Category)

- (NSString *)youtubeVideoID {
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

    NSArray *splitUsingAnd = [self.query componentsSeparatedByString:@"&"];
    for (NSString *keyWord in splitUsingAnd) {
        NSArray *splitUsingEqual = [keyWord componentsSeparatedByString:@"="];
        if ([splitUsingEqual[0] isEqualToString:@"v"]) {
            return [splitUsingEqual lastObject];
        }
    }
    return @"";
}

@end
