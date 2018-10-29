//
//  ViewController.m
//  WKWebCallJSDemo
//
//  Created by Nasheng Yu on 2018/10/29.
//  Copyright © 2018年 Nasheng Yu. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
@interface ViewController ()<WKNavigationDelegate,UIScrollViewDelegate,WKUIDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    config.preferences = [[WKPreferences alloc]init];
    config.preferences.minimumFontSize = 10;

    config.userContentController = [[WKUserContentController alloc]init];
    
    [config.userContentController addScriptMessageHandler:self name:@"filstClick"];
    [config.userContentController addScriptMessageHandler:self name:@"secondClick"];
//    [config.userContentController addScriptMessageHandler:self name:@"playSound"];
//    [config.userContentController addScriptMessageHandler:self name:@"playSound"];
    config.processPool = [[WKProcessPool alloc]init];
    
    self.view.backgroundColor = [UIColor blueColor];
    
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.webView];
    
    //加载本地html必须这么写
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    //    UIWebView *web =[[UIWebView alloc]initWithFrame:self.view.bounds];
    //    [web loadRequest:[NSURLRequest requestWithURL:url]];
    //    [self.view addSubview:web];
    
    
    
    
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    //原生调用js
    [webView evaluateJavaScript:@"pushCode('你好','不好')" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
    }];
    

    
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"filstClick"]) {
        NSLog(@"第一个按钮传递的参数为：%@",message.body);
    }
    if ([message.name isEqualToString:@"secondClick"]) {
        NSLog(@"第2个按钮传递的参数为：%@",message.body);
        NSDictionary *dic = (NSDictionary *)message.body;
        NSLog(@"%@",dic[@"name"]);
        
        
    }
    
    
    
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
  
}

@end
