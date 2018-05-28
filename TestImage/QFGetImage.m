//
//  QFGetImage.m
//  TestImage
//
//  Created by dqf on 2017/9/22.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "QFGetImage.h"
#import "QFFileHelper.h"
#import "NSString+QFUtil.h"

@interface QFGetImage ()
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSString *path;
@end


@implementation QFGetImage

+ (QFGetImage *)share {
    static QFGetImage *ss = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        ss = [[self alloc] init];
    });
    return ss;
}

- (void)getImageWithKeywords:(NSString *)keywords toFolderPath:(NSString *)path {
    _keywords = keywords;
    _path = path;
    [self writeToFileWithUrlString:[self getUrlString]];
}

- (void)writeToFileWithUrlString:(NSString *)urlString {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *dict = [self dictionaryWithJsonData:data];
    NSArray *arr = dict[@"imgs"];
    
    for (NSDictionary *dic in arr) {
        NSString *value = dic[@"objURL"];
        NSString *name = [value lastPathComponent];
        NSURL *url = [NSURL URLWithString:value];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        if (![[_path substringFromIndex:_path.length-1] isEqualToString:@"/"]) {
            _path = _path.append(@"/");
        }
        
        [QFFileHelper createFileAtPath:_path.append(name) contents:data attributes:nil];
    }
    
}

- (NSString *)getUrlString {
    NSString *hostString = @"http://image.baidu.com/search/avatarjson";
    
    NSString *keyWord = [_keywords encode];
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setObject:@"resultjsonavatarnew" forKey:@"tn"];
    [mutableDict setObject:@"utf-8" forKey:@"ie"];
    [mutableDict setObject:keyWord forKey:@"word"];
    [mutableDict setObject:@"girl" forKey:@"cg"];
    [mutableDict setObject:@"" forKey:@"pn"];
    [mutableDict setObject:@"60" forKey:@"rn"];
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
    
    return urlString;
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
