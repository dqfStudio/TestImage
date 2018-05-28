//
//  QFSpeechBar.h
//  TestImage
//
//  Created by dqf on 2017/10/15.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QFSpeechBarDelegate <NSObject>
@required
- (void)playAction;
@end

@interface QFSpeechBar : UIView
@property (nonatomic, weak) id<QFSpeechBarDelegate> delegate;
- (void)setStatus:(NSString *)status enabled:(BOOL)enabled;
@end
