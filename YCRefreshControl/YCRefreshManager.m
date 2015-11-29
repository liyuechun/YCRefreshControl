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

#import "YCRefreshManager.h"
#import "UIScrollView+YCRefresh.h"

#import "YCSlimeRefreshView.h"
#import "ScrollViewFrameAccessor.h"

typedef enum : NSUInteger {
	YCRefreshStateNormal,
	YCRefreshStateShow,
	YCRefreshStateAnimating,
	
} YCRefreshState;

@interface YCRefreshManager ()
{
	
	/** 记录scrollView刚开始的inset */
	UIEdgeInsets _originalInset;
	
	/** 所管理的 UIScrollView */
	__weak UIScrollView *_scrollView;
	
	YCRefreshState _refreshState;
	YCRefreshState _loadmoreState;
	
	CGFloat _pullUpPercent;
	CGFloat _pullDownPercent;
	
	BOOL _needReset;
	BOOL _isPullingDown;
	BOOL _isPullingUp;
}
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) YCRefreshState refreshState;
@property (nonatomic, assign) YCRefreshState loadmoreState;

@end

@implementation YCRefreshManager

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
	if (self = [super init]) {
		[self setupWith:scrollView];
		_refreshState = YCRefreshStateNormal;
		_pullUpPercent = 0.0f;
		_pullDownPercent = 0.0f;
		_isPullingDown = NO;
		_needReset = NO;
        self.scrollView.alwaysBounceVertical = YES;
	}
	return self;
}

- (void)setupWith:(UIScrollView *)scrollView {
	self.scrollView = scrollView;
	self.panGestureRecognizer = scrollView.panGestureRecognizer;
	_originalInset = self.scrollView.contentInset;
	
	[self addObserverFor:scrollView];
	
}
- (void)addObserverFor:(UIScrollView *)scrollView {
	[self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
	[self.scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
	[self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
	[self.scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
	[self.scrollView.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)removeObserver {
	[self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
	[self.scrollView removeObserver:self forKeyPath:@"contentInset"];
	[self.scrollView removeObserver:self forKeyPath:@"contentSize"];
	[self.scrollView removeObserver:self forKeyPath:@"frame"];
	[self.scrollView.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([object isKindOfClass:[UIScrollView class]]) {
		if([keyPath isEqualToString:@"contentInset"])
		{
			[self handleContentInsetChange:change];
		}else {
			
		}
		if([keyPath isEqualToString:@"contentOffset"])
		{
			[self handleContentOffsetChange:change];
		}
		else if([keyPath isEqualToString:@"contentSize"])
		{
			
		}
		else if([keyPath isEqualToString:@"frame"])
		{
			
		}
	}
	else if([keyPath isEqualToString:@"state"])
	{
		[self handleGecognizerChange:change];
	}
}
- (void)handleGecognizerChange:(NSDictionary *)change {
//	WLog(@"%@", self.panGestureRecognizer);
	if (self.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
		if (_refreshState == YCRefreshStateAnimating) {
			CGFloat resetOffsetY = _originalInset.top;
			if (!_needReset) {
				resetOffsetY += [self.scrollView.refreshView refreshHeight];
			}
			[UIView animateWithDuration:WSlowAnimationTime animations:^{
				self.scrollView.contentInsetTop = resetOffsetY;
			} completion:^(BOOL finished) {
				if (_needReset && finished) {
					_refreshState = YCRefreshStateNormal;
					_needReset = NO;
				}
			}];
		}
	}
}
- (void)handleContentOffsetChange:(NSDictionary *)change {
	CGFloat offsetY = _scrollView.contentOffsetY + _scrollView.contentInsetTop;
	if (self.scrollView.refreshView && [self.scrollView.refreshView respondsToSelector:@selector(scrollView:changeContentOffset:)]) {
		[self.scrollView.refreshView scrollView:self.scrollView changeContentOffset:change];
	}
	if (offsetY <= 0) {
		if (!_scrollView.refreshAction) {
			return;
		}else if (!_scrollView.refreshView) {
			_scrollView.refreshView = [[YCSlimeRefreshView alloc] initWithFrame:CGRectMake(0, -[_scrollView.refreshView totalHeight] + _originalInset.top, _scrollView.frame.size.width, -[_scrollView.refreshView totalHeight])];
			
		}
		if (-offsetY <= [_scrollView.refreshView totalHeight]) {
			
		}else if(_refreshState != YCRefreshStateAnimating) {
			_refreshState = YCRefreshStateAnimating;
			_scrollView.refreshAction();
			if (!self.scrollView.isTracking) {
				[UIView animateWithDuration:WFastAnimationTime animations:^{
					[self.scrollView setContentOffset:CGPointMake(0, -(_originalInset.top + [_scrollView.refreshView refreshHeight])) animated:YES];
					
				}];
			}
		}
		
	}
}
- (void)handleContentInsetChange:(NSDictionary *)change {
//	WLog(@"%@", NSStringFromUIEdgeInsets(self.scrollView.contentInset));
	if (_refreshState != YCRefreshStateAnimating) {
		_originalInset = _scrollView.contentInset;
		_scrollView.refreshView.frame = CGRectMake(0, -[_scrollView.refreshView totalHeight], _scrollView.frame.size.width, [_scrollView.refreshView totalHeight]);
	}
	
	if (_scrollView.refreshView && [_scrollView.refreshView respondsToSelector:@selector(scrollView:changeContentInset:)]) {
		[_scrollView.refreshView scrollView:_scrollView changeContentInset:change];
	}
}

- (void)beginRefresh {
	if (_refreshState != YCRefreshStateAnimating) {
		if (!_scrollView.refreshAction) {
			return;
		}else if (!_scrollView.refreshView) {
			_scrollView.refreshView = [[YCSlimeRefreshView alloc] initWithFrame:CGRectMake(0, -[_scrollView.refreshView totalHeight] + _originalInset.top, _scrollView.frame.size.width, -[_scrollView.refreshView totalHeight])];
			
		}
		[_scrollView setContentOffset:CGPointMake(0, -(_originalInset.top + [_scrollView.refreshView totalHeight] + 5)) animated:YES];
	}
}
- (void)endRefresh {
//	WLog(@"%@", NSStringFromUIEdgeInsets(_originalInset));
	[_scrollView.refreshView endAnimation];
	if (!self.scrollView.isTracking) {
		[UIView animateWithDuration:WSlowAnimationTime animations:^{
			self.scrollView.contentInsetTop = _originalInset.top;
			self.scrollView.contentOffset = CGPointMake(0, -_originalInset.top);
		} completion:^(BOOL finished) {
			_refreshState = YCRefreshStateNormal;
		}];
	}else {
		_needReset = YES;
	}
}

- (void)dealloc {
	[self removeObserver];
}

@end
