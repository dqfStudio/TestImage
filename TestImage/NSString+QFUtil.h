//
//  NSStringUtil.h
//  TestProj
//
//  Created by dqf on 2017/8/10.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QFUtil)

+ (NSString *(^)(id))append;
- (NSString *(^)(id))append;

+ (NSString *(^)(NSString *, NSUInteger))appendCount;
- (NSString *(^)(NSString *, NSUInteger))appendCount;

- (NSString *(^)(NSString *, NSString *))replace;

+ (NSString *(^)(NSUInteger))space;
- (NSString *(^)(NSUInteger))space;

+ (NSString *(^)(NSUInteger))tab;
- (NSString *(^)(NSUInteger))tab;

+ (NSString *(^)(NSUInteger))wrap;
- (NSString *(^)(NSUInteger))wrap;

- (NSString *(^)(NSUInteger))substringToIndex;
- (NSString *(^)(NSUInteger))substringFromIndex;

- (NSString *(^)(NSString *))subStringToStart;
- (NSString *(^)(NSString *))subStringToEnd;

- (NSString *(^)(NSString *))subStringFromStart;
- (NSString *(^)(NSString *))subStringFromEnd;

- (NSArray<NSString *> *(^)(NSString *))componentsByString;
- (NSArray<NSString *> *(^)(NSString *))componentsBySetString;
- (NSArray<NSString *> *(^)(NSString *, NSString *))componentsByStringBySetString;

- (BOOL(^)(NSString *))containsString;
- (BOOL(^)(NSArray<NSString *> *))containsStrArr;

@end


@interface NSString (QFCode)

- (id)JSONValue;

- (NSString *)trim;

- (NSString *)md5;

- (NSString *)encode;

- (NSString *)decode;

@end
