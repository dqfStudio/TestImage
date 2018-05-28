//
//  QFFileHelper.h
//  QFReadFile
//
//  Created by dqf on 2017/8/18.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "NSString+QFUtil.h"

@interface QFFileHelper : NSObject

+ (NSString *)homePath;

+ (NSString *)timePath;

+ (void)folderPath:(NSString *)path block:(void(^)(NSString *path))callback;

+ (void)folderPath:(NSString *)path filter:(NSString *)filter block:(void(^)(NSString *path))callback;

+ (void)folderPath:(NSString *)path filterArr:(NSArray *)filterArr block:(void(^)(NSString *path))callback;

+ (void)file:(NSString *)path block:(void(^)(NSString *lineStr))callback;

+ (void)file:(NSString *)path append:(NSString *)content;

+ (void)file:(NSString *)path append:(NSString *)content wrap:(BOOL)isWrap;

+ (void)createFileAtPath:(NSString *)path contents:(nullable NSData *)data attributes:(nullable NSDictionary<NSString *, id> *)attr;

@end
