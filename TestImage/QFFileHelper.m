//
//  QFFileHelper.m
//  QFReadFile
//
//  Created by dqf on 2017/8/18.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "QFFileHelper.h"

@interface QFFileHelper ()
@property (nonatomic, copy) NSString *timeString;
@end

@implementation QFFileHelper

+ (QFFileHelper *)share {
    static QFFileHelper *ss = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        ss = [[self alloc] init];
    });
    return ss;
}

+ (NSString *)homePath {
    return @"/Users/issuser/Desktop/";
}

+ (NSString *)timePath {
    if (![self share].timeString) {
        [self share].timeString = [self homePath].append([self timeStamp]).append(@"/");
    }
    return [self share].timeString;
}

+ (NSString *)timeStamp {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    
    return [formatter stringFromDate:[NSDate date]];
}

+ (void)folderPath:(NSString *)path block:(void(^)(NSString *path))callback {
    [self folderPath:path filter:nil block:callback];
}

+ (void)folderPath:(NSString *)path filter:(NSString *)filter block:(void(^)(NSString *path))callback {
    
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil];
    files = [self getClassPathInArr:files filter:filter];
    
    if (callback) {
        for(NSString *path in files){
            callback(path);
        }
    }
}

+ (void)folderPath:(NSString *)path filterArr:(NSArray *)filterArr block:(void(^)(NSString *path))callback {
    
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil];
    files = [self getClassPathInArr:files filterArr:filterArr];
    
    if (callback) {
        for(NSString *path in files){
            callback(path);
        }
    }
}

+ (NSArray *)getClassPathInArr:(NSArray *)arr filter:(NSString *)filter {
    NSMutableArray *pathArray = [NSMutableArray array];
    for(NSString *path in arr){
        NSString *lastComponent = [path lastPathComponent];
        if(filter && ![lastComponent hasSuffix:filter]) {
            continue;
        }
        [pathArray addObject:path];
    }
    return pathArray;
}

+ (NSArray *)getClassPathInArr:(NSArray *)arr filterArr:(NSArray *)filterArr {
    NSMutableArray *pathArray = [NSMutableArray array];
    for(NSString *path in arr) {
        NSString *lastComponent = [path lastPathComponent];
        for(NSString *filter in filterArr) {
            if(filter && ![lastComponent hasSuffix:filter]) {
                continue;
            }
            [pathArray addObject:path];
        }
    }
    return pathArray;
}

+ (void)file:(NSString *)path block:(void(^)(NSString *lineStr))callback {
    
    const char *filePath = [path UTF8String];
    FILE *fp1;//定义文件流指针，用于打开读取的文件
    char textStr[10241];//定义一个字符串数组，用于存储读取的字符
    fp1 = fopen(filePath,"r");//只读方式打开文件a.txt
    while(fgets(textStr,10240,fp1)!=NULL)//逐行读取fp1所指向文件中的内容到text中
    {
        NSString *lineStr = [NSString stringWithCString:textStr encoding:NSUTF8StringEncoding];
        if (callback && lineStr) {
            callback(lineStr);
        }
    }
    fclose(fp1);//关闭文件a.txt，有打开就要有关闭
}

+ (void)file:(NSString *)path append:(NSString *)content {
    
    [self file:path append:content wrap:YES];
}

+ (void)file:(NSString *)path append:(NSString *)content wrap:(BOOL)isWrap {
    
    [self createFileAtPath:path contents:nil attributes:nil];
    
    NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:path];
    
    //找到并定位到outFile的末尾位置(在此后追加文件)
    [outFile seekToEndOfFile];
    
    if (isWrap) {
        content = [NSString stringWithFormat:@"%@\n",content];
    }
    
    NSData *buffer = [content dataUsingEncoding:NSUTF8StringEncoding];
    [outFile writeData:buffer];
    //关闭读写文件
    [outFile closeFile];
}

+ (void)createFileAtPath:(NSString *)path contents:(nullable NSData *)data attributes:(nullable NSDictionary<NSString *, id> *)attr {
    
    NSArray *arr = [path pathComponents];
    //跳过lastPathComponent
    if (arr.count >= 2) {
        //循环创建文件夹
        for (NSInteger i=0; i<arr.count-1; i++) {
            NSRange range = NSMakeRange(0, i+1);
            NSArray *tmpArr = [arr subarrayWithRange:range];
            NSString *tmpPath = [NSString pathWithComponents:tmpArr];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:tmpPath]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
        }
    }
    
    //创建文件
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:attr];
    }
    
}

@end

