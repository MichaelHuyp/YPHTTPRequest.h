//
//  ViewController.m
//  0921-网络请求的封装
//
//  Created by 胡云鹏 on 15/9/21.
//  Copyright (c) 2015年 MichaelPPP. All rights reserved.
//

#import "ViewController.h"
#import "YPHTTPRequest.h"

@interface ViewController () <NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /**
     *  假如服务器返回的是文本格式,可以用NSData接收,也可以用NSString
     *  假如返回的是图片,视频,音频文件,pdf,doc,只能用NSData接收
     */
    
    // 1.初始化请求
    YPHTTPRequest *request = [[YPHTTPRequest alloc] initWithUrl:[NSURL URLWithString:@"https://github.com/MichaelHuyp"]];
    
    // 2.设置回调
    [request setHTTPRequestFinishBlock:^(YPHTTPRequest *request) {
        // 刷新
        // code
        
        NSLog(@"---%@",request.responseString);
    }];
    
    // 3.设置进度回调
    [request setRecevieProgessBlock:^(float progress) {
        NSLog(@"%f",progress);
    }];
    
    // 3.开始请求
    [request startHttpRequest];
    
    
}
@end



































