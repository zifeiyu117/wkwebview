//
//  ViewController.m
//  PracticeDemo
//
//  Created by xyt on 2018/5/15.
//  Copyright © 2018年 xyt. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "XMCenter.h"
#import <WebKit/WebKit.h>


@interface ViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,WKScriptMessageHandler>
@property (weak, nonatomic) IBOutlet UIImageView *sdImageview;
@property (weak, nonatomic) IBOutlet WKWebView *wkWebView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [XMCenter sendRequest:^(RequestModel *model) {
        model.header = @"header";
        model.body = @"body";
        model.url = @"http://www.baidu.com";
    }];
    
    NSString *urlStr = @"http://localhost:8888/test.html";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wkWebView loadRequest:request];
    self.wkWebView.UIDelegate=self;
    self.wkWebView.navigationDelegate =self;

    [[self.wkWebView configuration].userContentController addScriptMessageHandler:self name:@"JSBridge"];
    

    
}


-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSString *js = @"(function() {var script =document.createElement('script');script.type = 'text/JS';script.src= 'https://xteko.blob.core.windows.net/neo/eruda-loader.js';document.body.appendChild(script);})();";
    [self.wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"加载完成");
    }];
}

-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}


-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.body isKindOfClass:[NSString class]]) {
        NSDictionary *msgInfo = [NSJSONSerialization
                                 JSONObjectWithData:[message.body dataUsingEncoding:NSUTF8StringEncoding]
                                 options:NSJSONReadingAllowFragments error:nil];
        UIImage *image = [[UIImage alloc] initWithData:[NSData
                                                        dataWithContentsOfURL:[NSURL URLWithString:msgInfo[@"url"]]]];
        if (image) {
            UIImageWriteToSavedPhotosAlbum(image, self,
                                           @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),
                                           nil);
    }
}
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error==nil) {
        NSString *script = @"change_state(true);";
        [self.wkWebView evaluateJavaScript:script completionHandler:^(id _Nullable msg, NSError * _Nullable error) {
            
        }];
    }

    }
    

@end
