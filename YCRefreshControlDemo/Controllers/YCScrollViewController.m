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

#import "YCScrollViewController.h"
#import "YCRefreshControl.h"

@interface YCScrollViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation YCScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"UIScrollView";
    
    self.view.backgroundColor = [UIColor yellowColor];
	
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
	
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, WScreenWidth, 50)];
    lable.text = @"直接下拉刷新背景颜色";
    lable.textColor = [UIColor brownColor];
    lable.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:lable];
    
    
    UIButton *beginButton = [[UIButton alloc] initWithFrame:CGRectMake((WScreenWidth - 200)/2.0, 200, 200, 50)];
    beginButton.backgroundColor = [UIColor brownColor];
    [beginButton setTitle:@"开始刷新" forState:UIControlStateNormal];
    [beginButton addTarget:self action:@selector(beginRefresh) forControlEvents:UIControlEventTouchUpInside];
    [beginButton setTitleColor:[UIColor cyanColor] forState:UIControlStateHighlighted];
    [scrollView addSubview:beginButton];
}

//开始刷新
- (void)beginRefresh {

    [_scrollView beginRefresh];
    
}


@end
















