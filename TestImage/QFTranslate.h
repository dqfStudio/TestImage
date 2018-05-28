//
//  QFTranslate.h
//  TestImage
//
//  Created by dqf on 2017/10/14.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QFTranslate : NSObject

+ (QFTranslate *)share;

- (NSString *)translateToEnglish:(NSString *)word;

@end
