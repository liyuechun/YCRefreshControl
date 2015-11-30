# YCRefreshControl
			   ___                   __
			  / (_)_ ____ _____ ____/ /  __ _____
			 / / / // / // / -_) __/ _ \/ // / _ \
			/_/_/\_, /\_,_/\__/\__/_//_/\_,_/_//_/
			    /___/

1.项目贡献者：黎跃春 & 王广威

2.技术讨论群：343640780

3.UIScrollView（UITableView，UICollectionView）的使用方法

UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, WScreenWidth, WScreenHeight)];
    self.scrollView = scrollView;
	[self.view addSubview:scrollView];
	[scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
	@weakify(scrollView);
	[scrollView setRefreshAction:^{
		@strongify(scrollView);
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			self.view.backgroundColor = WArcColor;
			[scrollView endRefresh];
		});
	}];

UITableView和UICollectionView都是UIScrollView的子类，直接将上面的scrollView对象换成UITableView或者UICollectionView的对象即可，当手动下拉时就会触发块方法。


4.UIWebView的使用方法


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


5.UIScrollView（UITableView，UICollectionView），UIWebView的上下拉刷新详见Demo




