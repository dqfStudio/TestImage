//
//  QFSpeechView.m
//  TestImage
//
//  Created by dqf on 2017/10/15.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "QFSpeechView.h"
#import "QFSpeechBar.h"
#import "QFSpeech.h"
#import "QFGetOneImage2.h"
#import "QFTranslate.h"

@interface QFSpeechView () <QFSpeechDelegate, QFSpeechBarDelegate>
@property (nonatomic, strong) QFSpeechBar *speechBar;
@property (nonatomic, strong) QFSpeech *speech;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation QFSpeechView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    self.contentLabel = [[UILabel alloc] init];
    [self.contentLabel setFrame:CGRectMake(0, 22, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
    [self.contentLabel setFont:[UIFont systemFontOfSize:17]];
    [self.contentLabel setNumberOfLines:0];
    [self.contentLabel setTextAlignment:(NSTextAlignmentCenter)];
    [self.contentLabel setBackgroundColor:[UIColor redColor]];
    [self.contentLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:self.contentLabel];
    
    self.imgView = [[UIImageView alloc] init];
    [self.imgView setFrame:CGRectMake(0, 66, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)-66-44)];
    [self.imgView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:self.imgView];
    
    _speechBar = [[QFSpeechBar alloc] init];
    [_speechBar setFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-44, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
    [_speechBar setDelegate:self];
    [self addSubview:_speechBar];
    
    [QFSpeech getAuthorization:^(NSAuthorizationStatus status) {
        switch (status) {
            case NSAuthorizationStatusNotDetermined:
                [self.speechBar setStatus:@"语音识别未授权" enabled:NO];
                break;
            case NSAuthorizationStatusDenied:
                [self.speechBar setStatus:@"用户未授权使用语音识别" enabled:NO];
                break;
            case NSAuthorizationStatusRestricted:
                [self.speechBar setStatus:@"语音识别在这台设备上受到限制" enabled:NO];
                break;
            case NSAuthorizationStatusAuthorized:
                [self.speechBar setStatus:@"开始录音" enabled:YES];
                break;
                
            default:
                break;
        }
    }];
    
    _speech = [QFSpeech new];
    [_speech setDelegate:self];
}

- (void)playAction {
    [_speech startSpeech];
}

- (void)getSpeechStatus:(NSSpeechStatus)status {
    switch (status) {
        case NSSpeechStatusUnknow:
            [self.speechBar setStatus:@"语音识别不可用" enabled:NO];
            break;
        case NSSpeechStatusPlay:
            [self.speechBar setStatus:@"停止录音" enabled:YES];
            break;
        case NSSpeechStatusIsPlaying:
            NSLog(@"正在录音");
            [self.speechBar setStatus:@"正在录音" enabled:YES];
            break;
        case NSSpeechStatusStop:
            NSLog(@"开始录音");
            [self.speechBar setStatus:@"开始录音" enabled:YES];
            break;
            
        default:
            break;
    }
}

- (void)getSpeechWords:(NSString *)aString {
    if (aString) {
        dispatch_async(dispatch_queue_create(0, 0), ^{
            NSString *englishWords = [[QFTranslate share] translateToEnglish:aString];
            UIImage *image = [[QFGetOneImage2 share] getImageWithKeywords:aString];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.contentLabel setText:aString];
                NSString *string = [NSString stringWithFormat:@"%@\n%@", aString, englishWords];
                [self.contentLabel setText:string];
                [self.imgView setImage:nil];
                [self.imgView setImage:image];
            });
        });
    }
//    else {
//        dispatch_async(dispatch_queue_create(0, 0), ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.contentLabel setText:aString];
//                [self.imgView setImage:nil];
//            });
//        });
//    }
}

@end
