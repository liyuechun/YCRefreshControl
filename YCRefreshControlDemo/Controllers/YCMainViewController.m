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

#import "YCMainViewController.h"
#import "YCTableViewController.h"
#import "YCCollectionViewController.h"
#import "YCScrollViewController.h"
#import "YCUIWebViewController.h"
@interface YCMainViewController ()

@end

@implementation YCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self  configureViewControllers];
    
}

#pragma mark --配置控制器
- (void)configureViewControllers {

    YCTableViewController *tableVC = [[YCTableViewController alloc] init];
    UINavigationController *tableNav = [[UINavigationController alloc] initWithRootViewController:tableVC];
    tableNav.tabBarItem.title = @"UITableView";
    
    YCScrollViewController *scrollVC = [[YCScrollViewController alloc] init];
    UINavigationController *scrollNav = [[UINavigationController alloc] initWithRootViewController:scrollVC];
    scrollNav.tabBarItem.title = @"UIScrollView";
    
    
    YCCollectionViewController *collectionVC = [[YCCollectionViewController alloc] init];
    UINavigationController *collectionNav = [[UINavigationController alloc] initWithRootViewController:collectionVC];
    collectionNav.tabBarItem.title = @"UICollectionView";
    
    YCUIWebViewController *webViewVC = [[YCUIWebViewController alloc] init];
    UINavigationController *webViewNav = [[UINavigationController alloc] initWithRootViewController:webViewVC];
    webViewNav.tabBarItem.title = @"UIWebView";
    
    self.viewControllers = @[tableNav, scrollNav, collectionNav, webViewNav];
    
}



@end










