//
//  QFDataConversion.h
//  TestProject
//
//  Created by dqf on 2017/9/23.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (QFJson)
//将字典转化成json data
- (NSData *)toJsonData;
//将字典转化成字符串 如：rn=1&tt=3&rr=4
- (NSString *)toLinkString;
//将字典转化成json字符串
- (NSString *)toJsonString;
//去掉json字符串中的空格和换行符
- (NSString *)toJsonString2;
@end

@interface NSString (QFJson)
//将json字符串转化成字典
- (NSDictionary *)toDictionary;
//将字符串转化data
- (NSData *)toData;
@end

@interface NSData (QFJson)
//将json data转化成字典
- (NSDictionary *)toDictionary;
//将data转化成字符串
- (NSString *)toString;
@end
