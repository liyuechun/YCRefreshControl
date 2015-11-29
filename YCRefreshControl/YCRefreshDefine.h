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

@protocol YCRefreshViewDelegate <NSObject>

@optional
- (void)scrollView:(UIScrollView *)scrollView changeContentOffset:(NSDictionary *)change;
- (void)scrollView:(UIScrollView *)scrollView changeContentInset:(NSDictionary *)change;
- (void)scrollView:(UIScrollView *)scrollView changeContentSize:(NSDictionary *)change;
- (void)scrollView:(UIScrollView *)scrollView changeFrame:(NSDictionary *)change;

- (void)beginAnimation;
- (void)endAnimation;

@required
- (CGFloat)refreshHeight;
- (CGFloat)totalHeight;

@end

/**
 *  是否开启自定义打印
 *	1.开启 0.关闭
 */
#define isShowLog 1
#if isShowLog
#define WLog(Format, ...) fprintf(stderr,"%s: %s->%d\n%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __FUNCTION__, __LINE__, [[NSString stringWithFormat:Format, ##__VA_ARGS__] UTF8String])
#else
#define WLog(Format, ...)
#endif


// 颜色
#define WColorRGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]
#define WColorRGB(r, g, b) WColorRGBA(r, g, b, 1.000f)
// RGB十六进制表示颜色
#define WColorFromRGB(rgbValue) WColorRGB(\
								(float)((rgbValue & 0xFF0000) >> 16))/255.0,\
								(float)((rgbValue & 0xFF00) >> 16))/255.0,\
								(float)((rgbValue & 0xFF) >> 16))/255.0)

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

