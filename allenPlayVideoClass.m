//
//  allenPlayVideoClass.m
//  allenPlayVideo
//
//  Created by allen_hsu on 2015/12/28.
//  Copyright © 2015年 allen_hsu. All rights reserved.
//

#import "allenPlayVideoClass.h"
#import <AVFoundation/AVFoundation.h>

@interface allenPlayVideoClass ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end

@implementation allenPlayVideoClass

#pragma mark - init

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    }
    return self;
}

#pragma mark - instance method

- (void)playVideo:(NSString *)videoName pathType:(PathType)pathType {
    NSString *path = [self pathVideoName:videoName fromDocument:pathType];
    if (path) {
        if (pathType == PathTypeFromURL) {
            // URL
            NSURL *url = [NSURL URLWithString:path];
            NSData *data = [NSData dataWithContentsOfURL:url];
        }
        else {
            // File
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
        }
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
    }
    else {
    }
}

#pragma mark * fetch file

- (NSString *)pathVideoName:(NSString *)videoName fromDocument:(PathType)pathType {
    NSString *path;
    switch (pathType) {
        case PathTypeFromDefault:
        {
            path = [self pathVideoName:videoName fromDocument:PathTypeFromDocument];
            if (!path.length) {
                path = [self pathVideoName:videoName fromDocument:PathTypeFromResource];
            }
            break;
        }

        case PathTypeFromDocument:
        {
            NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            path = [documentPath[0] stringByAppendingString:[NSString stringWithFormat:@"/%@.m4v", videoName]];
            break;
        }

        case PathTypeFromResource:
        {
            path = [[NSBundle mainBundle] pathForResource:videoName ofType:@".m4v"];
            break;
        }

        case PathTypeFromURL:
        {
            return videoName;
        }
    }
    return path;
}

@end
