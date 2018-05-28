//
//  QFSpeech.h
//  iOS原生语音识别
//
//  Created by dqf on 2017/10/14.
//  Copyright © 2017年 尹啟星. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NSAuthorizationStatus) {
    NSAuthorizationStatusNotDetermined,
    NSAuthorizationStatusDenied,
    NSAuthorizationStatusRestricted,
    NSAuthorizationStatusAuthorized,
};

typedef NS_ENUM(NSInteger, NSSpeechStatus) {
    NSSpeechStatusUnknow = 0,   //不可用
    NSSpeechStatusPlay,         //录音
    NSSpeechStatusIsPlaying,    //正在录音
    NSSpeechStatusStop          //暂停
};

@protocol QFSpeechDelegate <NSObject>
@required
- (void)getSpeechStatus:(NSSpeechStatus)status;
- (void)getSpeechWords:(NSString *)aString;
@end

@interface QFSpeech : NSObject

@property (nonatomic, weak) id<QFSpeechDelegate> delegate;
@property (nonatomic, assign) NSInteger timeInterval;
+ (void)getAuthorization:(void(^)(NSAuthorizationStatus status))callback;
- (void)startSpeech;

@end
