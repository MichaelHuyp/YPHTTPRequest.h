//
//  YPHTTPRequest.m
//  0921-网络请求的封装
//
//  Created by 胡云鹏 on 15/9/21.
//  Copyright (c) 2015年 MichaelPPP. All rights reserved.
//

#import "YPHTTPRequest.h"

@interface YPHTTPRequest()
{
    YPHTTPRequestFinishBlock _requestFinishedBlock;
    YPHTTPRequestErrorBlock _requestErrorBlock;
    YPHTTPRequestDidReceiveProgessBlock _requestProgressBlock;
    
    // 请求的url
    NSURL *_url;
    
    // 文件总大小
    long long _fileSize;
}

@property (nonatomic, strong) NSMutableData *requestData;


@end

@implementation YPHTTPRequest


#pragma mark - 初始化方法 -
- (instancetype)initWithUrl:(NSURL *)url
{
    if (self = [super init]) {
        _url = url;
    }
    return self;
}

#pragma mark - 发送异步请求 -
- (void)startHttpRequest
{
    if (!_url) {
        return;
    }
    
    // 发送异步请求
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - getter方法 -
- (NSMutableData *)requestData
{
    if (!_requestData) {
        _requestData = [NSMutableData data];
    }
    return _requestData;
}

#pragma mark - setter方法 -
/**
 *  设置回调
 */
- (void)setHTTPRequestFinishBlock:(YPHTTPRequestFinishBlock)block
{
    // 赋值
    _requestFinishedBlock = block;
}

#pragma mark - NSURLConnectionDelegate -
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // 清空数据
    self.requestData.length = 0;
    
    // 获取文件总大小
    _fileSize = [response expectedContentLength];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 1.追加数据
    [self.requestData appendData:data];
    
    // 2.计算进度
    float progress = (float)self.requestData.length / _fileSize;
    
    if (_requestProgressBlock) {
        _requestProgressBlock(progress);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 赋值
    self.responseData = self.requestData;
    
    self.responseString = [[NSString alloc] initWithData:self.requestData encoding:NSUTF8StringEncoding];
    
    // block对象不为空
    if (_requestFinishedBlock) {
        // 回调
        _requestFinishedBlock(self);
    }
    
}


- (void)GET:(NSString *)urlString success:(YPHTTPRequestFinishBlock)successBlock failure:(YPHTTPRequestErrorBlock)failureBlock
{
    _requestFinishedBlock = successBlock;
    _requestErrorBlock = failureBlock;
    
    _url = [NSURL URLWithString:urlString];
    [self startHttpRequest];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{

}

- (void)setRecevieProgessBlock:(YPHTTPRequestDidReceiveProgessBlock)progressBlock
{
    _requestProgressBlock = progressBlock;
}


//- (void)请求完成的代理方法
//{
//    [self.delegate endMessage:数据];
//}
//
//- (void)请求失败的代理方法
//{
//    [self.delegate endMessage:失败原因];
//}

@end
