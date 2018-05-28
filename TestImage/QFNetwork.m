//
//  QFNetwork.m
//  HttpUrlRequest
//
//  Created by dqf on 2017/10/11.
//  Copyright © 2017年 Rainer. All rights reserved.
//

#import "QFNetwork.h"
#import "QFDataConversion.h"

#define KDefaultTimeoutInterval  30.0

@interface QFNetwork () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation QFNetwork

#pragma mark - 同步网络请求
- (NSString *)getSyncData:(NSString *)urlString {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:KDefaultTimeoutInterval];
    
    NSError *error;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    return [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
}
- (NSString *)postSyncData:(NSString *)urlString param:(NSDictionary *)paramDict {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:KDefaultTimeoutInterval];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[[paramDict toLinkString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    return [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
}

#pragma mark - 异步网络请求
- (void)getAsyncData:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:KDefaultTimeoutInterval];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
- (void)postAsyncData:(NSString *)urlString param:(NSDictionary *)paramDict {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:KDefaultTimeoutInterval];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[paramDict toJsonData]];
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - 异步请求代理
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.receiveData = [NSMutableData data];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receiveData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.connection cancel];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.connection cancel];
}

@end

