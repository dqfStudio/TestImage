//
//  QFSpeechBar.m
//  TestImage
//
//  Created by dqf on 2017/10/15.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "QFSpeechBar.h"

@interface QFSpeechBar ()
@property (nonatomic, strong) UIButton *playBtn;
@end

@implementation QFSpeechBar

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _playBtn = [[UIButton alloc] init];
    [_playBtn setFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
    [_playBtn setBackgroundColor:[UIColor redColor]];
    [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [_playBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [_playBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_playBtn];
}

- (void)playBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(playAction)]) {
        [self.delegate playAction];
    }
}

- (void)setStatus:(NSString *)status enabled:(BOOL)enabled {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_playBtn setEnabled:enabled];
        if (enabled) {
            [_playBtn setTitle:status forState:UIControlStateNormal];
        }else {
            [_playBtn setTitle:status forState:UIControlStateDisabled];
        }
    });
}

@end
