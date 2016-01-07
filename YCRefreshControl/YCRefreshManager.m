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

typedef enum : NSUInteger {
	YCRefreshStateUnset, // 未设置 refreshView
	YCRefreshStateNormal, // 普通状态，未激活 refreshView
	YCRefreshStatePulling, // 正在下拉状态，refresh 已经显示
	YCRefreshStateRefreshing, // 正在刷新状态
	YCRefreshStateRefreshed, // 刷新完成状态，可能用户还在下拉
} YCRefreshState;

typedef enum : NSUInteger {
	YCLoadmoreStateUnset, // 未设置 loadmoreView
	YCLoadmoreStateNormal, // 普通状态，未激活 loadmoreView
	YCLoadmoreStatePulling, // 正在上拉状态，loadmoreView 已经显示
	YCLoadmoreStateLoading, // 正在加载数据状态
	YCLoadmoreStateNoData, // 没有更多数据了
} YCLoadmoreState;

@interface YCRefreshManager ()
{
	// scrollView 初始 Inset
	UIEdgeInsets _originalInset;
	
	// scrollView 开始拖动的 contentOffset
	CGPoint _originalOffset;
}
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPanGestureRecognizer *panGestureRecognizer;
/**
 *  刷新状态
 */
@property (nonatomic, assign) YCRefreshState refreshState;
/**
 *	加载更多状态
 */
@property (nonatomic, assign) YCLoadmoreState loadmoreState;

@end

@implementation YCRefreshManager

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
	if (self = [super init]) {
		// 初始化刷新状态
		_refreshState = YCRefreshStateNormal;
		_loadmoreState = YCLoadmoreStateNormal;
		
		// 设置监控的 scrollView
		[self setupWith:scrollView];
	}
	return self;
}

// 根据传入的 scrollView 进行一些设置
- (void)setupWith:(UIScrollView *)scrollView {
	// 首次传入时候，将 _originalInset 设置为 scrollView 的 contentInset
	_originalInset = scrollView.contentInset;
	_originalOffset = scrollView.contentOffset;
	
	// 将 scrollView 和 scrollView 的滑动手势设置为成员变量
	self.scrollView = scrollView;
	self.panGestureRecognizer = scrollView.panGestureRecognizer;
	
	// 设置 scrollView 的弹簧效果开启
	self.scrollView.alwaysBounceVertical = YES;
	
	// 添加 kvo 监控 scrollView 的一些属性值变化
	[self addObserver];
}
// 监听属性
- (void)addObserver {
	[self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
	[self.scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
	[self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
	[self.scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
	[self.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
	
	[self.scrollView addObserver:self forKeyPath:@"yc_loadmoreView" options:NSKeyValueObservingOptionNew context:nil];
	[self.scrollView addObserver:self forKeyPath:@"yc_refreshView" options:NSKeyValueObservingOptionNew context:nil];
}
// 移除监听
- (void)removeObserver {
	[self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
	[self.scrollView removeObserver:self forKeyPath:@"contentInset"];
	[self.scrollView removeObserver:self forKeyPath:@"contentSize"];
	[self.scrollView removeObserver:self forKeyPath:@"frame"];
	[self.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
	
	[self.scrollView removeObserver:self forKeyPath:@"yc_loadmoreView"];
	[self.scrollView removeObserver:self forKeyPath:@"yc_refreshView"];
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
			[self handleContentSizeChange:change];
		}
		else if([keyPath isEqualToString:@"frame"])
		{
			
		}
		else if([keyPath isEqualToString:@"yc_loadmoreView"])
		{
			[self handleLoadmoreViewChange:change];
		}
		else if([keyPath isEqualToString:@"yc_refreshView"])
		{
			[self handleRefreshViewChange:change];
		}
	}
	else if([keyPath isEqualToString:@"state"])
	{
		[self handleGecognizerChange:change];
	}
}
- (void)handleGecognizerChange:(NSDictionary *)change {
	// 根据手势的 state 和 refresh 执行相应的操作
	[self setScrollContent];
}
// 如果 scrollView 的 contentInset 改变，若是用户改变，则改变 _originalInset 的值
- (void)handleContentInsetChange:(NSDictionary *)change {
	if (self.refreshState == YCRefreshStateNormal) {
		_originalInset.top = _scrollView.contentInset.top;
	}
	if (self.loadmoreState == YCLoadmoreStateNormal) {
		_originalInset.bottom = _scrollView.contentInset.bottom;
	}
}
- (void)handleContentSizeChange:(NSDictionary *)change {
	if (self.refreshAction) {
		_scrollView.yc_refreshView.frame = CGRectMake(0, -[_scrollView.yc_refreshView totalHeight], _scrollView.contentSize.width, [_scrollView.yc_refreshView totalHeight]);
	}
	if (self.loadmoreAction) {
		_scrollView.yc_loadmoreView.frame = CGRectMake(0, _scrollView.contentSize.height, _scrollView.contentSize.width, [_scrollView.yc_loadmoreView loadmoreHeight]);
	}
}
- (void)handleLoadmoreViewChange:(NSDictionary *)change {
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
	[_scrollView.yc_loadmoreView addGestureRecognizer:tap];
	[_scrollView.yc_loadmoreView setUserInteractionEnabled:YES];
	[tap addTarget:self action:@selector(tapLoadmoreView)];
}
- (void)handleRefreshViewChange:(NSDictionary *)change {
	
}
- (void)handleContentOffsetChange:(NSDictionary *)change {
	// scrollview 当前滑动到的位置，去掉 contentInset 的影响
	CGFloat offsetY = _scrollView.contentOffset.y + _scrollView.contentInset.top;
	if (offsetY < 0 && _loadmoreState != YCLoadmoreStateLoading) {
		// 如果设置了 refreshAction ，并且现在不处于刷新状态才继续进行
		if (self.refreshAction && _refreshState != YCRefreshStateRefreshing && _refreshState != YCRefreshStateRefreshed) {
			
			// 如果当前滑动的位置没有到设定的最大高度
			if (-offsetY <= [_scrollView.yc_refreshView totalHeight]) {
				// 更新 refreshState 为正在下拉
				_refreshState = YCRefreshStatePulling;
			}
			// 如果达到了最大高度
			else {
				// 将 refreshState 更新为正在刷新
				_refreshState = YCRefreshStateRefreshing;
				
				// 并执行 refreshAction，并做其他的操作，如 更新 _scrollView 的 contentOffset、contentInset
				[self refreshing];
			}
			if (_scrollView.yc_refreshView && [_scrollView.yc_refreshView respondsToSelector:@selector(scrollView:changeContentOffset:)]) {
				[_scrollView.yc_refreshView scrollView:_scrollView changeContentOffset:change];
			}
		}
	}
	
	if (self.loadmoreAction && _refreshState != YCRefreshStateRefreshing && _refreshState != YCRefreshStateRefreshed) {
		CGFloat boundHeight = _scrollView.bounds.size.height;
		CGFloat contentHeight = _scrollView.contentSize.height;
		offsetY = contentHeight - boundHeight - _scrollView.contentOffset.y + _scrollView.contentInset.bottom;
		
		NSValue *newValue = [change objectForKey:@"new"];
		if (_scrollView.isTracking && contentHeight > 0 && [newValue CGPointValue].y > _originalOffset.y) {
			if (_loadmoreState != YCLoadmoreStateNoData && _loadmoreState != YCLoadmoreStateLoading) {
				if (offsetY >= [_scrollView.yc_loadmoreView loadmoreHeight]) {
					_loadmoreState = YCLoadmoreStatePulling;
				}
				else {
					// 将 loadmoreState 更新为正在加载
					_loadmoreState = YCLoadmoreStateLoading;
					
					// 并执行 refreshAction，并做其他的操作，如 更新 _scrollView 的 contentOffset、contentInset
					[self loading];
				}
				
				if (_scrollView.yc_loadmoreView && [_scrollView.yc_loadmoreView respondsToSelector:@selector(scrollView:changeContentOffset:)]) {
					[_scrollView.yc_loadmoreView scrollView:_scrollView changeContentOffset:change];
				}
			}
		}
	}
}

- (void)beginRefresh {
	// 当主动调用 beginRefresh 方法，先判断是否正在刷新，或者是否设置了 refreshAction
	if (_refreshState != YCRefreshStateRefreshing && self.refreshAction) {
		// 设置 _scrollView 的 contentOffset 到足够大，kvo 监测并触发刷新的方法。
		[_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x, -(_originalInset.top + [_scrollView.yc_refreshView totalHeight] + 5)) animated:YES];
	}
}
- (void)refreshing {
	// 调用刷新 block
	self.refreshAction();
	// 如果 scrollView 没有处于 tracking 状态，直接设置 scrollView 合适的 contentInset
	if (!_scrollView.isTracking) {
		[self setScrollContent];
	}
}
- (void)loading {
	// 调用加载更多数据的 block
	self.loadmoreAction();
	if (_scrollView.yc_loadmoreView && [_scrollView.yc_loadmoreView respondsToSelector:@selector(beginAnimation)]) {
		[_scrollView.yc_loadmoreView beginAnimation];
	}
}
- (void)setScrollContent {
	// 如果手势刚结束
	if (self.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
		// 如果处在正在刷新状态，继续
		if (_refreshState == YCRefreshStateRefreshing) {
			// 在上部添加 contentInset 显示 refreshView 动画
			[self setScrollViewContentInsetForRefreshingAnimated:YES];
		}else if(_refreshState == YCRefreshStateRefreshed) {
			// 重置 scrollView 的 contentInset 到原始数值
			[self resetScrollViewContentInsetWithCompletion:^(BOOL finished) {
				// 说明已经执行过 endRefresh 将 refreshState 重置
				_refreshState = YCRefreshStateNormal;
			}];
		}
	}
	// 手势可用，未触发
	else if (self.panGestureRecognizer.state == UIGestureRecognizerStatePossible) {
		if (_refreshState == YCRefreshStateRefreshing) {
			[self setScrollViewContentInsetForRefreshingAnimated:YES];
		}else if(_refreshState == YCRefreshStateRefreshed) {
			[self resetScrollViewContentInsetWithCompletion:^(BOOL finished) {
				// 说明已经执行过 endRefresh 将 refreshState 重置
				_refreshState = YCRefreshStateNormal;
			}];
		}
		
	}
	// 手势开始触发
	else if (self.panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
		_originalOffset = _scrollView.contentOffset;
	}
}
- (void)tapLoadmoreView {
	if (_loadmoreState != YCLoadmoreStateLoading) {
		_loadmoreState = YCLoadmoreStateLoading;
		[self loading];
	}
}
// 结束刷新
- (void)endRefresh {
	// 如果当前处于正在刷新状态才会有效果
	if (_refreshState == YCRefreshStateRefreshing) {
		// 结束 refreshView 的动画
		if (_scrollView.yc_refreshView && [_scrollView.yc_refreshView respondsToSelector:@selector(endAnimation)]) {
			[_scrollView.yc_refreshView endAnimation];
		}
		// 将 refreshState 设置为 YCRefreshStateRefreshed ，代表刷新完成
		_refreshState = YCRefreshStateRefreshed;
		// 如果 scrollView 没有处于 tracking 状态，直接设置 scrollView 合适的 contentInset
		if (!_scrollView.isTracking) {
			[self setScrollContent];
		}
	}
}
// 结束加载更多数据
- (void)endLoadmore {
	// 如果当前处于正在加载更多数据状态才会有效果
	if (_loadmoreState == YCLoadmoreStateLoading || _loadmoreState == YCLoadmoreStateNoData) {
		// 结束 loadmoreView 的动画
		if (_scrollView.yc_loadmoreView && [_scrollView.yc_loadmoreView respondsToSelector:@selector(endAnimation)]) {
			[_scrollView.yc_loadmoreView endAnimation];
		}
		
		if (_loadmoreState != YCLoadmoreStateNoData) {
			// 将 loadmoreState 设置为 YCLoadmoreStateNormal ，代表加载数据完成
			_loadmoreState = YCLoadmoreStateNormal;
		}
		
		// 如果 scrollView 没有处于 tracking 状态，直接设置 scrollView 合适的 contentInset
		if (!_scrollView.isTracking) {
			[self setScrollContent];
		}
	}
}
// 设置没有更多数据可以加载
- (void)setNoMoreData:(BOOL)noData {
	if (noData) {
		_loadmoreState = YCLoadmoreStateNoData;
	}else {
		_loadmoreState = YCLoadmoreStateNormal;
	}
	if (_scrollView.yc_loadmoreView && [_scrollView.yc_loadmoreView respondsToSelector:@selector(setNoMoreData:)]) {
		[_scrollView.yc_loadmoreView setNoMoreData:noData];
	}
}

// animated contentInset
- (void)setScrollViewContentInset:(UIEdgeInsets)inset animated:(BOOL)animated complete:(void(^)(BOOL finished))completion {
	void (^updateBlock)(void) = ^{
		self.scrollView.contentInset = inset;
	};
	
	dispatch_async(dispatch_get_main_queue(), ^{
		if (animated) {
			[UIView animateWithDuration:WSlowAnimationTime
								  delay:0
								options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn)
							 animations:updateBlock
							 completion:completion];
		} else {
			updateBlock();
		}
	});
}

- (void)resetScrollViewContentInsetWithCompletion:(void(^)(BOOL finished))completion {
	[self setScrollViewContentInset:_originalInset animated:YES complete:completion];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)insetes forLoadingAnimated:(BOOL)animated {
	[self setScrollViewContentInset:insetes animated:animated complete:nil];
}

- (void)setScrollViewContentInsetForRefreshingAnimated:(BOOL)animated {
	UIEdgeInsets loadingInset = _originalInset;
	loadingInset.top += [_scrollView.yc_refreshView refreshHeight];
	[self setScrollViewContentInset:loadingInset forLoadingAnimated:animated];
}
- (void)setScrollViewContentInsetForNormalAnimated:(BOOL)animated {
	[self setScrollViewContentInset:_originalInset forLoadingAnimated:animated];
}

// dealloc 时候移除监听
- (void)dealloc {
	[self removeObserver];
}

@end
