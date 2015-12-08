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


#import <UIKit/UIKit.h>
#import "YCRefreshDefine.h"

@interface UIScrollView (YCRefresh)

/**
 *  设置刷新调用的 block
 *
 *  @param refreshAction block
 */
- (void)yc_setRefreshAction:(YCAction)refreshAction;
/**
 *  刷新的 view ，后期会开放
 */
@property (nonatomic, strong) UIView <YCRefreshViewDelegate> *yc_refreshView;
/**
 *  开始刷新，第一次进入界面可能调用
 */
- (void)yc_beginRefresh;
/**
 *  获取数据后调用
 */
- (void)yc_endRefresh;


/**
 *  设置加载更多的 block
 */
- (void)yc_setLoadmoreAction:(YCAction)loadmoreAction;
/**
 *  加载更多的 view ，后期会开放
 */
@property (nonatomic, strong) UIView <YCLoadmoreViewDelegate> *yc_loadmoreView;
/**
 *  加载更多操作完毕后调用
 */
- (void)yc_endLoadmore;
/**
 *  无更多数据可加载
 */
- (void)yc_setNoMoreData:(BOOL)noData;

@end
