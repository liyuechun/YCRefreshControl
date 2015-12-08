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

#import <objc/runtime.h>
#import "UIScrollView+YCRefresh.h"

#import "YCRefreshManager.h"
#import "YCSlimeRefreshView.h"
#import "YCNormalLoadmoreView.h"

static const void *YCRefreshManagerKey = &"YCRefreshManagerKey";
static const void *YCRefreshViewKey = &"YCRefreshViewKey";
static const void *YCLoadmoreViewKey = &"YCLoadmoreViewKey";

@interface UIScrollView ()
@property (nonatomic, retain, readonly) YCRefreshManager *yc_refreshManager;

@end

@implementation UIScrollView (YCRefresh)
@dynamic yc_refreshView, yc_loadmoreView;

- (YCRefreshManager *)yc_refreshManager {
	return objc_getAssociatedObject(self, &YCRefreshManagerKey);
}
- (UIView<YCRefreshViewDelegate> *)yc_refreshView {
	return objc_getAssociatedObject(self, &YCRefreshViewKey);
}
- (UIView<YCLoadmoreViewDelegate> *)yc_loadmoreView {
	return objc_getAssociatedObject(self, &YCLoadmoreViewKey);
}

- (void)configRefreshManager {
	if (!self.yc_refreshManager) {
		YCRefreshManager *refreshManager = [[YCRefreshManager alloc] initWithScrollView:self];
		objc_setAssociatedObject(self,
								 &YCRefreshManagerKey,
								 refreshManager,
								 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}
- (void)setYc_refreshView:(UIView<YCRefreshViewDelegate> *)refreshView {
	if (![refreshView isEqual:self.yc_refreshView]) {
		[self.yc_refreshView removeFromSuperview];
	
		objc_setAssociatedObject(self,
								 &YCRefreshViewKey,
								 refreshView,
								 OBJC_ASSOCIATION_RETAIN);
		refreshView.frame = CGRectMake(0, -[refreshView totalHeight], self.frame.size.width, [refreshView totalHeight]);
		[self addSubview:refreshView];
	}
}
- (void)setYc_loadmoreView:(UIView<YCLoadmoreViewDelegate> *)loadmoreView {
	UIEdgeInsets newInset = self.contentInset;
	if (self.yc_loadmoreView) {
		newInset.bottom -= [self.yc_loadmoreView loadmoreHeight];
	}
	newInset.bottom += [loadmoreView loadmoreHeight];
	self.contentInset = newInset;
	if (![loadmoreView isEqual:self.yc_loadmoreView]) {
		[self.yc_loadmoreView removeFromSuperview];
		
		objc_setAssociatedObject(self,
								 &YCLoadmoreViewKey,
								 loadmoreView,
								 OBJC_ASSOCIATION_RETAIN);
		loadmoreView.frame = CGRectMake(0, self.contentSize.height, self.frame.size.width, [loadmoreView loadmoreHeight]);
		
		[self addSubview:loadmoreView];
	}
}

- (void)yc_setRefreshAction:(YCAction)refreshAction {
	[self configRefreshManager];
	self.yc_refreshManager.refreshAction = refreshAction;
	[self initRefreshView];
}
- (void)yc_setLoadmoreAction:(YCAction)loadmoreAction {
	[self configRefreshManager];
	self.yc_refreshManager.loadmoreAction = loadmoreAction;
	[self initLoadmoreView];
}

// 如果没有设置自定义的 refreshView，提供默认的一个
- (void)initRefreshView {
	if (!self.yc_refreshView) {
		self.yc_refreshView = [[YCSlimeRefreshView alloc] init];
	}
}
// 如果没有设置自定义的 loadmoreView，提供默认的一个
- (void)initLoadmoreView {
	if (!self.yc_loadmoreView) {
		self.yc_loadmoreView = [[YCNormalLoadmoreView alloc] init];
	}
}
- (void)yc_beginRefresh {
	[self.yc_refreshManager beginRefresh];
}
- (void)yc_endRefresh {
	[self.yc_refreshManager endRefresh];
}

- (void)yc_endLoadmore {
	[self.yc_refreshManager endLoadmore];
}
- (void)yc_setNoMoreData:(BOOL)noData {
	[self.yc_refreshManager setNoMoreData:noData];
}

@end
