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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^YCAction)();

/**
 *  监听代理， refreshView 和 loacmoreView 可以实现这些方法，做一些动画
 */
@protocol YCKVODelegate <NSObject>

@optional
- (void)scrollView:(UIScrollView *)scrollView changeContentOffset:(NSDictionary *)change;
- (void)scrollView:(UIScrollView *)scrollView changeContentInset:(NSDictionary *)change;
- (void)scrollView:(UIScrollView *)scrollView changeContentSize:(NSDictionary *)change;
- (void)scrollView:(UIScrollView *)scrollView changeFrame:(NSDictionary *)change;

@end

/**
 *  YCRefreshViewDelegate
 */
@protocol YCRefreshViewDelegate <YCKVODelegate>

@required
/**
 *  @return 返回顶部正在刷新状态的高度
 */
- (CGFloat)refreshHeight;
/**
 *  @return 返回顶部下拉能够触发刷新操作的高度
 */
- (CGFloat)totalHeight;

@optional
/**
 *  触发刷新操作时调用，refreshView 可以实现此方法，开始动画
 */
- (void)beginAnimation;
/**
 *  刷新操作结束时调用，refreshView 可以实现此方法，结束动画
 */
- (void)endAnimation;

@end

@protocol YCLoadmoreViewDelegate <YCKVODelegate>

@required
/**
 *  @return loadmoreView 的高度
 */
- (CGFloat)loadmoreHeight;

@optional
/**
 *  触发加载更多操作时调用，loadmoreView 可以实现此方法，开始动画
 */
- (void)beginAnimation;
/**
 *  加载更多操作结束时调用，loadmoreView 可以实现此方法，结束动画
 */
- (void)endAnimation;
/**
 *  设置没有更多数据可以加载的样式
 */
- (void)setNoMoreData:(BOOL)noData;

@end

// 颜色
#define WColorRGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]
#define WColorRGB(r, g, b) WColorRGBA(r, g, b, 1.000f)

// 动态获取屏幕宽高
#define WScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define WScreenWidth ([UIScreen mainScreen].bounds.size.width)

// 随机数
#define WArcNum(x) arc4random_uniform(x)
// 随机颜色
#define WArcColor WColorRGB(WArcNum(128) + 128, WArcNum(128) + 128, WArcNum(128) + 128)

#define WSlowAnimationTime 0.45f

#define WFastAnimationTime 0.25f

// 提示框显示时间
#define WFastLoadingTime 5.0f

#define YCRefreshControlTitle  @"春哥正在为你刷新"

