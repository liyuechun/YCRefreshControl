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

#import "YCTableViewController.h"
#import "YCRefreshControl.h"

@interface YCTableViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_refreshData;
}

@end

@implementation YCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"UITableView";
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    NSArray *initArray = @[@"有问题请联系->《iOS编程之美》技术讨论群：343640780",@"有问题请联系->微信:Liyuechun2012", @"有问题请联系->QQ:939442932 1244357005",@"春哥：https://github.com/LiYueChun", @"简书地址:http://www.jianshu.com/users/336468483205/latest_articles", @"新浪微博:http://weibo.com/mobiledevelopment", @"新浪博客:http://blog.sina.com.cn/technicalarticle"];
    
    _refreshData = [[NSMutableArray alloc] initWithArray:initArray];
    [self loadScrollView];
    
}
- (void)loadScrollView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
	tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 49, 0);
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.backgroundColor = [UIColor colorWithWhite:0.889 alpha:1.000];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 64;
	[tableView yc_setRefreshAction:^{
		
		// 这里写刷新的方法，可以获取网络数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[_tableView beginUpdates];
			
            [_refreshData insertObject:[NSString stringWithFormat:@"%@", [NSDate date]] atIndex:0];
            [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
			[_tableView endUpdates];
            [tableView yc_endRefresh];
        });
	}];
	
	[tableView yc_setLoadmoreAction:^{
		
		// 这里写加载更多的方法，可以获取网络数据
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[_refreshData addObject:[NSString stringWithFormat:@"%@", [NSDate date]]];
			[_tableView beginUpdates];
			[_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_refreshData.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
			[_tableView endUpdates];
			// 完成后结束加载
			[tableView yc_endLoadmore];
			
			// 设置没有更多数据，可以设置，也可以不设置
			if (_refreshData.count > 10) {
				[_tableView yc_setNoMoreData:YES];
			}else {
				[_tableView yc_setNoMoreData:NO];
			}
		});
	}];
	
    _tableView = tableView;
}

#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _refreshData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        
    }
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont italicSystemFontOfSize:12];
    cell.textLabel.text = _refreshData[indexPath.row % _refreshData.count];
    
    return cell;
}


#pragma mark --UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
