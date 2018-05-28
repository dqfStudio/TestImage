//
//  QFTranslate.m
//  TestImage
//
//  Created by dqf on 2017/10/14.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "QFTranslate.h"
#import "NSString+QFUtil.h"
#import "QFNetwork.h"
#import "XMLDictionary.h"

@implementation QFTranslate

+ (QFTranslate *)share {
    static QFTranslate *ss = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        ss = [[self alloc] init];
    });
    return ss;
}

- (NSString *)translateToEnglish:(NSString *)word {
    NSString *baseString = @"http://fy.webxml.com.cn/webservices/EnglishChinese.asmx/TranslatorString";
    NSDictionary *dict = @{@"wordKey": [word encode]};

    NSString *xmlString = [[QFNetwork new] postSyncData:baseString param:dict];
    NSDictionary *xmlDict = [NSDictionary dictionaryWithXMLString:xmlString];
    NSArray *arr = xmlDict[@"string"];
    NSString *tmpStrng = nil;
    if (arr && arr.count > 0) {
        tmpStrng = [arr lastObject];
    }
    return tmpStrng;
}

@end
