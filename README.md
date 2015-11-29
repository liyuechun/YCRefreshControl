# YCRefreshControl
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
项目贡献者：黎跃春 王广威
使用说明：这是一款基于UIScrollView轻量级，易使用的上下拉刷新。
1.下载YCRefreshControldemo，将demo中的YCRefreshControl文件夹直接拖拽到工程中，在pch文件或者您要使用上下拉下刷新的控制器中导入YCRefreshControl.h头文件

2.UIScrollView(UITableView，UICollectionView)使用方法：
UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, WScreenWidth, WScreenHeight)];
    self.scrollView = scrollView;
	[self.view addSubview:scrollView];
	[scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
	@weakify(scrollView);
	<!---->下拉时所触发的方法
	[scrollView setRefreshAction:^{
		@strongify(scrollView);
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			self.view.backgroundColor = WArcColor;
			[scrollView endRefresh];
		});
	}];
	具体案例见demo
	3.UIwebView使用方法
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
