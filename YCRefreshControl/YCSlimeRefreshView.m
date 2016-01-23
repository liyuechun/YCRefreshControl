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

#import "YCSlimeRefreshView.h"
#import "YCRefreshDefine.h"

#define kOpenedViewHeight   60
#define kMinTopPadding      6
#define kMaxTopPadding      6
#define kMinTopRadius       8
#define kMaxTopRadius       12
#define kMinBottomRadius    3
#define kMaxBottomRadius    12
#define kMinBottomPadding   6
#define kMaxBottomPadding   6
#define kMinArrowSize       2
#define kMaxArrowSize       3
#define kMinArrowRadius     4
#define kMaxArrowRadius     6
#define kMaxDistance        44
#define kActivityFollowTop NO

#define kTotalViewHeight    (kMaxTopPadding + kMaxBottomPadding + kMaxTopRadius + kMaxBottomRadius + kMaxDistance)

static inline CGFloat lerp(CGFloat a, CGFloat b, CGFloat p)
{
	return a + (b - a) * p;
}

@interface YCSlimeRefreshView () {
	CAShapeLayer *_shapeLayer;
	CAShapeLayer *_arrowLayer;
	CAShapeLayer *_highlightLayer;
	UIActivityIndicatorView *_activity;
	UILabel *_tipLabel;
	BOOL _refreshing;
}

@property (nonatomic, strong) UIColor *tintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorViewStyle UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *activityIndicatorViewColor UI_APPEARANCE_SELECTOR;

@end

@implementation YCSlimeRefreshView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_refreshing = NO;
//		self.backgroundColor = WArcColor;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_tintColor = [UIColor colorWithRed:155.0 / 255.0 green:162.0 / 255.0 blue:172.0 / 255.0 alpha:1.0];
		[self initTipLabel];
		[self initShapeLayer];
		[self initArrowLayer];
		[self initHightLayer];
		[self initActivityView];
	}
	return self;
}
- (void)initTipLabel {
	_tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTotalViewHeight - 20, WScreenWidth, 20)];
	_tipLabel.font = [UIFont systemFontOfSize:14];
	_tipLabel.textAlignment = NSTextAlignmentCenter;
	_tipLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	_tipLabel.textColor = [UIColor colorWithRed:0.349 green:0.368 blue:0.389 alpha:1.000];
	_tipLabel.center = CGPointMake(WScreenWidth / 2.f, kTotalViewHeight - _tipLabel.frame.size.height / 2 - kMinBottomPadding);
	
	[self addSubview:_tipLabel];
	
}
- (void)initShapeLayer {
	_shapeLayer = [CAShapeLayer layer];
	_shapeLayer.fillColor = [_tintColor CGColor];
	_shapeLayer.strokeColor = [[[UIColor darkGrayColor] colorWithAlphaComponent:0.5] CGColor];
	_shapeLayer.lineWidth = 0.5;
	_shapeLayer.shadowColor = [[UIColor blackColor] CGColor];
	_shapeLayer.shadowOffset = CGSizeMake(0, 1);
	_shapeLayer.shadowOpacity = 0.4;
	_shapeLayer.shadowRadius = 0.5;
	[self.layer addSublayer:_shapeLayer];
}
- (void)initArrowLayer {
	_arrowLayer = [CAShapeLayer layer];
	_arrowLayer.strokeColor = [[[UIColor darkGrayColor] colorWithAlphaComponent:0.5] CGColor];
	_arrowLayer.lineWidth = 0.5;
	_arrowLayer.fillColor = [[UIColor whiteColor] CGColor];
	[_shapeLayer addSublayer:_arrowLayer];
}
- (void)initHightLayer {
	_highlightLayer = [CAShapeLayer layer];
	_highlightLayer.fillColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.2] CGColor];
	[_shapeLayer addSublayer:_highlightLayer];
}
- (void)initActivityView {
	_activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_activity.center = CGPointMake(floor(self.frame.size.width / 2), kTotalViewHeight - 40);
	_activity.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	[self addSubview:_activity];
}

- (void)setTintColor:(UIColor *)tintColor {
	_tintColor = tintColor;
	_shapeLayer.fillColor = [_tintColor CGColor];
}

- (CGFloat)refreshHeight {
	return kOpenedViewHeight;
}
- (CGFloat)totalHeight {
	return kTotalViewHeight;
}
-(void)scrollView:(UIScrollView *)scrollView changeContentOffset:(NSDictionary *)change {
	CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;
	
	if (_refreshing) return;
	
	BOOL triggered = NO;
	
	CGMutablePathRef path = CGPathCreateMutable();
	
	//Calculate some useful points and values
	CGFloat verticalShift = MAX(0, -((kMaxTopRadius + kMaxBottomRadius + kMaxTopPadding + kMaxBottomPadding) + offset));
	CGFloat distance = MIN(kMaxDistance, fabs(verticalShift));
	CGFloat percentage = 1 - (distance / kMaxDistance);
	
	CGFloat currentTopPadding = lerp(kMinTopPadding, kMaxTopPadding, percentage);
	CGFloat currentTopRadius = lerp(kMinTopRadius, kMaxTopRadius, percentage);
	CGFloat currentBottomRadius = lerp(kMinBottomRadius, kMaxBottomRadius, percentage);
	CGFloat currentBottomPadding =  lerp(kMinBottomPadding, kMaxBottomPadding, percentage);
	
	CGPoint bottomOrigin = CGPointMake(floor(self.bounds.size.width / 2), self.bounds.size.height - currentBottomPadding -currentBottomRadius);
	CGPoint topOrigin = CGPointZero;
	if (distance == 0) {
		topOrigin = CGPointMake(floor(self.bounds.size.width / 2), bottomOrigin.y);
	} else {
		topOrigin = CGPointMake(floor(self.bounds.size.width / 2), self.bounds.size.height + offset + currentTopPadding + currentTopRadius);
		if (percentage == 0) {
			bottomOrigin.y -= (fabs(verticalShift) - kMaxDistance);
			triggered = YES;
		}
	}
	
	//Top semicircle
	CGPathAddArc(path, NULL, topOrigin.x, topOrigin.y, currentTopRadius, 0, M_PI, YES);
	
	//Left curve
	CGPoint leftCp1 = CGPointMake(lerp((topOrigin.x - currentTopRadius), (bottomOrigin.x - currentBottomRadius), 0.1), lerp(topOrigin.y, bottomOrigin.y, 0.2));
	CGPoint leftCp2 = CGPointMake(lerp((topOrigin.x - currentTopRadius), (bottomOrigin.x - currentBottomRadius), 0.9), lerp(topOrigin.y, bottomOrigin.y, 0.2));
	CGPoint leftDestination = CGPointMake(bottomOrigin.x - currentBottomRadius, bottomOrigin.y);
	
	CGPathAddCurveToPoint(path, NULL, leftCp1.x, leftCp1.y, leftCp2.x, leftCp2.y, leftDestination.x, leftDestination.y);
	
	//Bottom semicircle
	CGPathAddArc(path, NULL, bottomOrigin.x, bottomOrigin.y, currentBottomRadius, M_PI, 0, YES);
	
	//Right curve
	CGPoint rightCp2 = CGPointMake(lerp((topOrigin.x + currentTopRadius), (bottomOrigin.x + currentBottomRadius), 0.1), lerp(topOrigin.y, bottomOrigin.y, 0.2));
	CGPoint rightCp1 = CGPointMake(lerp((topOrigin.x + currentTopRadius), (bottomOrigin.x + currentBottomRadius), 0.9), lerp(topOrigin.y, bottomOrigin.y, 0.2));
	CGPoint rightDestination = CGPointMake(topOrigin.x + currentTopRadius, topOrigin.y);
	
	CGPathAddCurveToPoint(path, NULL, rightCp1.x, rightCp1.y, rightCp2.x, rightCp2.y, rightDestination.x, rightDestination.y);
	CGPathCloseSubpath(path);
	
	if (!triggered) {
		// Set paths
		_shapeLayer.path = path;
		_shapeLayer.shadowPath = path;
		
		// Add the arrow shape
		CGFloat currentArrowSize = lerp(kMinArrowSize, kMaxArrowSize, percentage);
		CGFloat currentArrowRadius = lerp(kMinArrowRadius, kMaxArrowRadius, percentage);
		CGFloat arrowBigRadius = currentArrowRadius + (currentArrowSize / 2);
		CGFloat arrowSmallRadius = currentArrowRadius - (currentArrowSize / 2);
		CGMutablePathRef arrowPath = CGPathCreateMutable();
		CGPathAddArc(arrowPath, NULL, topOrigin.x, topOrigin.y, arrowBigRadius, 0, 3 * M_PI_2, NO);
		CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x, topOrigin.y - arrowBigRadius - currentArrowSize);
		CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x + (2 * currentArrowSize), topOrigin.y - arrowBigRadius + (currentArrowSize / 2));
		CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x, topOrigin.y - arrowBigRadius + (2 * currentArrowSize));
		CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x, topOrigin.y - arrowBigRadius + currentArrowSize);
		CGPathAddArc(arrowPath, NULL, topOrigin.x, topOrigin.y, arrowSmallRadius, 3 * M_PI_2, 0, YES);
		CGPathCloseSubpath(arrowPath);
		_arrowLayer.path = arrowPath;
		[_arrowLayer setFillRule:kCAFillRuleEvenOdd];
		CGPathRelease(arrowPath);
		
		// Add the highlight shape
		
		CGMutablePathRef highlightPath = CGPathCreateMutable();
		CGPathAddArc(highlightPath, NULL, topOrigin.x, topOrigin.y, currentTopRadius, 0, M_PI, YES);
		CGPathAddArc(highlightPath, NULL, topOrigin.x, topOrigin.y + 1.25, currentTopRadius, M_PI, 0, NO);
		
		_highlightLayer.path = highlightPath;
		[_highlightLayer setFillRule:kCAFillRuleNonZero];
		CGPathRelease(highlightPath);
		
	}else {
		// 拉断动画
		CGFloat radius = lerp(kMinBottomRadius, kMaxBottomRadius, 0.2);
		CABasicAnimation *pathMorph = [CABasicAnimation animationWithKeyPath:@"path"];
		pathMorph.duration = 0.15;
		pathMorph.fillMode = kCAFillModeForwards;
		pathMorph.removedOnCompletion = NO;
		CGMutablePathRef toPath = CGPathCreateMutable();
		CGPathAddArc(toPath, NULL, topOrigin.x, topOrigin.y, radius, 0, M_PI, YES);
		CGPathAddCurveToPoint(toPath, NULL, topOrigin.x - radius, topOrigin.y, topOrigin.x - radius, topOrigin.y, topOrigin.x - radius, topOrigin.y);
		CGPathAddArc(toPath, NULL, topOrigin.x, topOrigin.y, radius, M_PI, 0, YES);
		CGPathAddCurveToPoint(toPath, NULL, topOrigin.x + radius, topOrigin.y, topOrigin.x + radius, topOrigin.y, topOrigin.x + radius, topOrigin.y);
		CGPathCloseSubpath(toPath);
		pathMorph.toValue = (__bridge id)toPath;
		[_shapeLayer addAnimation:pathMorph forKey:nil];
		CABasicAnimation *shadowPathMorph = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
		shadowPathMorph.duration = 0.15;
		shadowPathMorph.fillMode = kCAFillModeForwards;
		shadowPathMorph.removedOnCompletion = NO;
		shadowPathMorph.toValue = (__bridge id)toPath;
		[_shapeLayer addAnimation:shadowPathMorph forKey:nil];
		CGPathRelease(toPath);
		CABasicAnimation *shapeAlphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		shapeAlphaAnimation.duration = 0.1;
		shapeAlphaAnimation.beginTime = CACurrentMediaTime() + 0.1;
		shapeAlphaAnimation.toValue = [NSNumber numberWithFloat:0];
		shapeAlphaAnimation.fillMode = kCAFillModeForwards;
		shapeAlphaAnimation.removedOnCompletion = NO;
		[_shapeLayer addAnimation:shapeAlphaAnimation forKey:nil];
		CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		alphaAnimation.duration = 0.1;
		alphaAnimation.toValue = [NSNumber numberWithFloat:0];
		alphaAnimation.fillMode = kCAFillModeForwards;
		alphaAnimation.removedOnCompletion = NO;
		[_arrowLayer addAnimation:alphaAnimation forKey:nil];
		[_highlightLayer addAnimation:alphaAnimation forKey:nil];
		
		[self startAnimation];
	}
	
	CGPathRelease(path);
}

- (void)startAnimation {
	// 动画展示 activity
	[_activity startAnimating];
	_activity.alpha = 1;
	_activity.layer.transform = CATransform3DIdentity;
	CAKeyframeAnimation *aniamtion = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	
	aniamtion.values = [NSArray arrayWithObjects:
						[NSValue valueWithCATransform3D:
						 CATransform3DRotate(CATransform3DMakeScale(0.01, 0.01, 0.1),
											 -M_PI, 0, 0, 1)],
						[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.25, 1.25, 1)],
						[NSValue valueWithCATransform3D:CATransform3DIdentity],nil];
	aniamtion.keyTimes = [NSArray arrayWithObjects:
						  [NSNumber numberWithFloat:0],
						  [NSNumber numberWithFloat:0.5],
						  [NSNumber numberWithFloat:1], nil];
	aniamtion.timingFunctions = [NSArray arrayWithObjects:
								 [CAMediaTimingFunction functionWithName:
								  kCAMediaTimingFunctionEaseInEaseOut],
								 [CAMediaTimingFunction functionWithName:
								  kCAMediaTimingFunctionEaseInEaseOut],
								 nil];
	aniamtion.duration = 1.f;
	[_activity.layer addAnimation:aniamtion forKey:@"activityScaleAnimate"];
	_tipLabel.text = YCRefreshControlTitle;
	_tipLabel.alpha = 1;
	_refreshing = YES;
}

- (void)endAnimation {
	if (_refreshing) {
		_tipLabel.text = @"刷新完成";
		[UIView animateWithDuration:WFastAnimationTime animations:^{
			_tipLabel.alpha = 0.5;
			_activity.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
		} completion:^(BOOL finished) {
			_tipLabel.alpha = 0;
			[_activity stopAnimating];
			[_shapeLayer removeAllAnimations];
			_shapeLayer.path = nil;
			_shapeLayer.shadowPath = nil;
			_shapeLayer.position = CGPointZero;
			[_arrowLayer removeAllAnimations];
			_arrowLayer.path = nil;
			[_highlightLayer removeAllAnimations];
			_highlightLayer.path = nil;
			_refreshing = NO;
		}];
	}
}

@end
