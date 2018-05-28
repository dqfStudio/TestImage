//
//  QFSpeech.m
//  iOS原生语音识别
//
//  Created by dqf on 2017/10/14.
//  Copyright © 2017年 尹啟星. All rights reserved.
//

#import "QFSpeech.h"
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>

@interface QFSpeech () <SFSpeechRecognizerDelegate>
@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@end

@implementation QFSpeech

+ (void)getAuthorization:(void(^)(NSAuthorizationStatus status))callback {
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    if (callback) {
                        callback(NSAuthorizationStatusNotDetermined);
                    }
                    break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    if (callback) {
                        callback(NSAuthorizationStatusDenied);
                    }
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    if (callback) {
                        callback(NSAuthorizationStatusRestricted);
                    }
                    break;
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    if (callback) {
                        callback(NSAuthorizationStatusAuthorized);
                    }
                    break;
                    
                default:
                    break;
            }
        });
    }];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _timeInterval = 3;
    }
    return self;
}

- (void)startSpeech {
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
        if (_recognitionRequest) {
            [_recognitionRequest endAudio];
        }
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopSpeech) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playSpeech) object:nil];
        if ([self.delegate respondsToSelector:@selector(getSpeechStatus:)]) {
            [self.delegate getSpeechStatus:NSSpeechStatusStop];
        }
    }else {
        [self startRecording];
        if ([self.delegate respondsToSelector:@selector(getSpeechStatus:)]) {
            [self.delegate getSpeechStatus:NSSpeechStatusIsPlaying];
        }
        [self performSelector:@selector(stopSpeech) withObject:nil afterDelay:_timeInterval];
    }
}

- (void)playSpeech {
    [self startRecording];
    if ([self.delegate respondsToSelector:@selector(getSpeechStatus:)]) {
        [self.delegate getSpeechStatus:NSSpeechStatusIsPlaying];
    }
    [self performSelector:@selector(stopSpeech) withObject:nil afterDelay:_timeInterval];
}

- (void)stopSpeech {
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
        if (_recognitionRequest) {
            [_recognitionRequest endAudio];
        }
    }
    if ([self.delegate respondsToSelector:@selector(getSpeechStatus:)]) {
        [self.delegate getSpeechStatus:NSSpeechStatusStop];
    }
    [self performSelector:@selector(playSpeech) withObject:nil afterDelay:1.0];
}

- (void)startRecording {
    if (_recognitionTask) {
        [_recognitionTask cancel];
        _recognitionTask = nil;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error;
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    NSParameterAssert(!error);
    [audioSession setMode:AVAudioSessionModeMeasurement error:&error];
    NSParameterAssert(!error);
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    NSParameterAssert(!error);
    
    _recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    NSAssert(inputNode, @"录入设备没有准备好");
    NSAssert(_recognitionRequest, @"请求初始化失败");
    _recognitionRequest.shouldReportPartialResults = YES;
    __weak typeof(self) weakSelf = self;
//    __block BOOL skip = NO;
    _recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:_recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
//        BOOL isFinal = NO;
//        if (result) {
//            if (!skip) {
//                skip = YES;
//                if ([strongSelf.delegate respondsToSelector:@selector(getSpeechWords:)]) {
//                    [strongSelf.delegate getSpeechWords:result.bestTranscription.formattedString];
//                }
//            }
//            isFinal = result.isFinal;
//        }else {
//            if ([strongSelf.delegate respondsToSelector:@selector(getSpeechWords:)]) {
//                [strongSelf.delegate getSpeechWords:nil];
//            }
//        }
        BOOL isFinal = NO;
        if (result) {
            isFinal = result.isFinal;
            if (isFinal) {
                if ([strongSelf.delegate respondsToSelector:@selector(getSpeechWords:)]) {
                    [strongSelf.delegate getSpeechWords:result.bestTranscription.formattedString];
                }
            }
        }else {
//            if ([strongSelf.delegate respondsToSelector:@selector(getSpeechWords:)]) {
//                [strongSelf.delegate getSpeechWords:nil];
//            }
        }
        if (error || isFinal) {
            [self.audioEngine stop];
            [inputNode removeTapOnBus:0];
            strongSelf.recognitionTask = nil;
            strongSelf.recognitionRequest = nil;
        }
    }];
    
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    [inputNode removeTapOnBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.recognitionRequest) {
            [strongSelf.recognitionRequest appendAudioPCMBuffer:buffer];
        }
    }];
    
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:&error];
    NSParameterAssert(!error);
}

#pragma mark - lazyload

- (AVAudioEngine *)audioEngine {
    if (!_audioEngine) {
        _audioEngine = [[AVAudioEngine alloc] init];
    }
    return _audioEngine;
}

- (SFSpeechRecognizer *)speechRecognizer {
    if (!_speechRecognizer) {
        NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:local];
        _speechRecognizer.delegate = self;
    }
    return _speechRecognizer;
}

#pragma mark - SFSpeechRecognizerDelegate

- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
    if (available) {
        if ([self.delegate respondsToSelector:@selector(getSpeechStatus:)]) {
            [self.delegate getSpeechStatus:NSSpeechStatusStop];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(getSpeechStatus:)]) {
            [self.delegate getSpeechStatus:NSSpeechStatusUnknow];
        }
    }
}

@end

