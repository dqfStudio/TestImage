//
//  QFGetOneImage2.m
//  TestImage
//
//  Created by dqf on 2017/10/14.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "QFGetOneImage2.h"
#import "NSString+QFUtil.h"

@implementation QFGetOneImage2

+ (QFGetOneImage2 *)share {
    static QFGetOneImage2 *ss = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        ss = [[self alloc] init];
    });
    return ss;
}

- (UIImage *)getImageWithKeywords:(NSString *)keywords {
    NSData *data = [NSData dataWithContentsOfURL:[self getUrlWithKeywords:keywords]];
    NSDictionary *dict = [self dictionaryWithJsonData:data];
    NSArray *arr = dict[@"imgs"];
    
    if (arr && arr.count > 0) {
        NSDictionary *dic = [arr firstObject];
        NSString *value = dic[@"objURL"];
        NSURL *url = [NSURL URLWithString:value];
        NSData *data = [NSData dataWithContentsOfURL:url];
        return [UIImage imageWithData:data];
    }
    return nil;
}

- (NSURL *)getUrlWithKeywords:(NSString *)keywords {
    NSString *hostString = @"http://image.baidu.com/search/avatarjson";
    
    NSString *keyWord = [keywords encode];
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setObject:@"resultjsonavatarnew" forKey:@"tn"];
    [mutableDict setObject:@"utf-8" forKey:@"ie"];
    [mutableDict setObject:keyWord forKey:@"word"];
    [mutableDict setObject:@"girl" forKey:@"cg"];
    [mutableDict setObject:@"" forKey:@"pn"];
    [mutableDict setObject:@"1" forKey:@"rn"];
    [mutableDict setObject:@"0" forKey:@"itg"];
    [mutableDict setObject:@"0" forKey:@"z"];
    [mutableDict setObject:@"" forKey:@"fr"];
    [mutableDict setObject:@"" forKey:@"width"];
    [mutableDict setObject:@"" forKey:@"height"];
    [mutableDict setObject:@"-1" forKey:@"lm"];
    [mutableDict setObject:@"0" forKey:@"ic"];
    [mutableDict setObject:@"0" forKey:@"s"];
    [mutableDict setObject:@"-1" forKey:@"st"];
    [mutableDict setObject:@"1e0000001e" forKey:@"gsm"];
    
    NSString *params = [self convertToString:mutableDict];
    
    NSString *urlString = hostString.append(@"?").append(params);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    return url;
}

- (NSDictionary *)dictionaryWithJsonData:(NSData *)data {
    if (!data) return nil;
    return [NSJSONSerialization JSONObjectWithData:data
                                           options:NSJSONReadingMutableContainers
                                             error:nil];
}

- (NSString *)convertToString:(NSDictionary *)dict {
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    for (NSString *key in dict.allKeys) {
        NSString *value = dict[key];
        [mutableString appendString:key];
        [mutableString appendString:@"="];
        [mutableString appendString:value];
        [mutableString appendString:@"&"];
    }
    return [mutableString substringToIndex:mutableString.length-1];;
}

@end


