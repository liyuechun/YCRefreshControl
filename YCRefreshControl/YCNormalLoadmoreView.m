//
//  YCNormalLoadmoreView.m
//  YCRefreshControlDemo
//
//  Created by 王广威 on 15/12/8.
//  Copyright © 2015年 王广威. All rights reserved.
//

#import "YCNormalLoadmoreView.h"

@interface YCNormalLoadmoreView () {
	BOOL _refreshing;
	UILabel *_tipLabel;
	UIActivityIndicatorView *_activity;
}

@end

@implementation YCNormalLoadmoreView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_refreshing = NO;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self initTipLabel];
		[self initActivityView];
		[self resetLoadmoreView];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	_tipLabel.center = CGPointMake(self.frame.size.width / 2.f + 20 * _refreshing, [self loadmoreHeight] / 2.f);
	_activity.center = CGPointMake(floor(_tipLabel.frame.origin.x - 20 * _refreshing), floor([self loadmoreHeight] / 2));
	
}

- (void)initTipLabel {
	_tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [self loadmoreHeight] / 2, self.frame.size.width, 20)];
	_tipLabel.font = [UIFont systemFontOfSize:14];
	_tipLabel.textAlignment = NSTextAlignmentCenter;
	_tipLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	_tipLabel.textColor = [UIColor colorWithRed:0.349 green:0.368 blue:0.389 alpha:1.000];
	[self addSubview:_tipLabel];
	
}

- (void)initActivityView {
	_activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_activity.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	[self addSubview:_activity];
}
- (CGFloat)loadmoreHeight {
	return 44;
}

- (void)resetLoadmoreView {
	_tipLabel.text = @"上拉或点击加载更多数据";
	[_tipLabel sizeToFit];
	[self layoutIfNeeded];
}
- (void)beginAnimation {
	_refreshing = YES;
	[_activity startAnimating];
	_tipLabel.text = @"正在加载更多数据";
	[_tipLabel sizeToFit];
	[self layoutIfNeeded];
}
- (void)endAnimation {
	_refreshing = NO;
	[_activity stopAnimating];
	_tipLabel.text = @"加载完毕";
	[_tipLabel sizeToFit];
	[self layoutIfNeeded];
	[self resetLoadmoreView];
}
- (void)setNoMoreData:(BOOL)noData {
	if (noData) {
		[_activity stopAnimating];
		_tipLabel.text = @"没有更多数据了，请点击重试";
		[_tipLabel sizeToFit];
		[self layoutIfNeeded];
	}
}

@end
