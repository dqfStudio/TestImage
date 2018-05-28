//
//  QFNetwork.h
//  HttpUrlRequest
//
//  Created by dqf on 2017/10/11.
//  Copyright © 2017年 Rainer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QFNetwork : NSObject

#pragma mark - 同步网络请求
- (NSString *)getSyncData:(NSString *)urlString;
- (NSString *)postSyncData:(NSString *)urlString param:(NSDictionary *)paramDict;

#pragma mark - 异步网络请求
- (void)getAsyncData:(NSString *)urlString;
- (void)postAsyncData:(NSString *)urlString param:(NSDictionary *)paramDict;

@end
