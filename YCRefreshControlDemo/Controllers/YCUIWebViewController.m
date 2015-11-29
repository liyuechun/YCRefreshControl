//===============================================================
//			   ___                   __
//			  / (_)_ ____ _____ ____/ /  __ _____
//			 / / / // / // / -_) __/ _ \/ // / _ \
//			/_/_/\_, /\_,_/\__/\__/_//_/\_,_/_//_/
//			    /___/
//
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝= = ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//     Created by 黎跃春 on 1314/05/20.
//     Copyright (c) 2015年 王广威. All rights reserved.
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝= = ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//    《iOS编程之美》技术讨论群：343640780
//     电子邮件:liyuechun2009@163.com
//     微信:Liyuechun2012
//     QQ:939442932[春哥]  1244357005[广威]
//     github:https://github.com/LiYueChun
//     简书地址:http://www.jianshu.com/users/336468483205/latest_articles
//     新浪微博:http://weibo.com/mobiledevelopment
//     新浪博客:http://blog.sina.com.cn/technicalarticle
//================================================================

#import "YCUIWebViewController.h"
#import "YCRefreshControl.h"
@interface YCUIWebViewController ()
{
    NSArray *_initArray;
}

@end

@implementation YCUIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"UIWebView";
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, WScreenWidth, WScreenHeight - 64)];
    [self.view addSubview:webView];
    
    UIScrollView *scrollView = webView.scrollView;
    _initArray = @[@"https://github.com/LiYueChun", @"http://www.jianshu.com/users/336468483205/latest_articles", @"http://weibo.com/mobiledevelopment", @"http://blog.sina.com.cn/technicalarticle"];
    @weakify(scrollView);
    @weakify(webView);
    [scrollView setRefreshAction:^{
        @strongify(scrollView);
        @strongify(webView);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSInteger randomCount = arc4random_uniform(4);
            NSString *path = _initArray[randomCount];
            NSURL *url = [NSURL URLWithString:path];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [webView loadRequest:request];
            [scrollView endRefresh];
        });
    }];

    NSString *path = @"http://weibo.com/mobiledevelopment";
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}



@end



























