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

static const void *YCRefreshActionKey = &"YCRefreshActionKey";
static const void *YCLoadmoreActionKey = &"YCLoadmoreActionKey";
static const void *YCRefreshManagerKey = &"YCRefreshManagerKey";
static const void *YCRefreshViewKey = &"YCRefreshViewKey";

@interface UIScrollView ()

@property (nonatomic, copy) YCAction refreshAction;
@property (nonatomic, copy) YCAction loadmoreAction;
@property (nonatomic, retain, readonly) YCRefreshManager *refreshManager;

@end

@implementation UIScrollView (YCRefresh)

@dynamic refreshAction;
@dynamic loadmoreAction;

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		Class class = [self class];
		// When swizzling a class method, use the following:
		// Class class = object_getClass((id)self);
		
		SEL originalSelector = @selector(willMoveToSuperview:);
		SEL swizzledSelector = @selector(yc_willMoveToSuperview:);
		
		Method originalMethod = class_getInstanceMethod(class, originalSelector);
		Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
		
		BOOL didAddMethod =
		class_addMethod(class,
						originalSelector,
						method_getImplementation(swizzledMethod),
						method_getTypeEncoding(swizzledMethod));
		
		if (didAddMethod) {
			class_replaceMethod(class,
								swizzledSelector,
								method_getImplementation(originalMethod),
								method_getTypeEncoding(originalMethod));
		} else {
			method_exchangeImplementations(originalMethod, swizzledMethod);
		}
	});
}
- (void)yc_willMoveToSuperview:(UIView *)superView {
	[self yc_willMoveToSuperview:superView];
	[self configRefreshManager];
}

- (YCAction)refreshAction {
	return objc_getAssociatedObject(self, &YCRefreshActionKey);
}
- (YCAction)loadmoreAction {
	return objc_getAssociatedObject(self, &YCLoadmoreActionKey);
}
- (YCRefreshManager *)refreshManager {
	return objc_getAssociatedObject(self, &YCRefreshManagerKey);
}
- (UIView<YCRefreshViewDelegate> *)refreshView {
	return objc_getAssociatedObject(self, &YCRefreshViewKey);
}

- (void)setLoadmoreAction:(YCAction)loadmoreAction {
	if (loadmoreAction != self.loadmoreAction) {
		objc_setAssociatedObject(self,
								 &YCLoadmoreActionKey,
								 loadmoreAction,
								 OBJC_ASSOCIATION_COPY_NONATOMIC);
	}
}
- (void)setRefreshAction:(YCAction)refreshAction {
	if (refreshAction != self.refreshAction) {
		objc_setAssociatedObject(self,
								 &YCRefreshActionKey,
								 refreshAction,
								 OBJC_ASSOCIATION_COPY_NONATOMIC);
	}
}
- (void)setRefreshView:(UIView<YCRefreshViewDelegate> *)refreshView {
	if (![refreshView isEqual:self.refreshView]) {
		[self.refreshView removeFromSuperview];
	
		objc_setAssociatedObject(self,
								 &YCRefreshViewKey,
								 refreshView,
								 OBJC_ASSOCIATION_RETAIN);
		[self addSubview:refreshView];
	}
}
- (void)configRefreshManager {
	if (!self.refreshManager) {
		YCRefreshManager *refreshManager = [[YCRefreshManager alloc] initWithScrollView:self];
		objc_setAssociatedObject(self,
								 &YCRefreshManagerKey,
								 refreshManager,
								 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

- (void)beginRefresh {
	[self.refreshManager beginRefresh];
}
- (void)endRefresh {
	[self.refreshManager endRefresh];
}

@end
