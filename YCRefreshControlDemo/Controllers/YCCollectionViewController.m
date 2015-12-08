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

#import "YCCollectionViewController.h"
#import "YCRefreshControl.h"
#import "CollectionViewCell.h"

@interface YCCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *_refreshData;
}


@end

@implementation YCCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"UICollectionView";
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, WScreenWidth, WScreenHeight - 64) collectionViewLayout:flowLayout];
	collectionView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
	collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
    collectionView.backgroundColor = [UIColor colorWithWhite:0.889 alpha:1.000];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    UINib *nibName = [UINib nibWithNibName:@"CollectionViewCell" bundle:nil];
    [collectionView registerNib:nibName forCellWithReuseIdentifier:@"cellID"];
	
    [collectionView yc_setRefreshAction:^{
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[_refreshData insertObject:[NSString stringWithFormat:@"%@", [NSDate date]] atIndex:0];
			
			[collectionView performBatchUpdates:^{
				[collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
			} completion:^(BOOL finished) {
				if (finished) {
					[collectionView yc_endRefresh];
				}
			}];
        });
    }];
	[collectionView yc_setLoadmoreAction:^{
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[_refreshData addObject:[NSString stringWithFormat:@"%@", [NSDate date]]];
			
			[collectionView performBatchUpdates:^{
				[collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_refreshData.count - 1 inSection:0]]];
			} completion:^(BOOL finished) {
				if (finished) {
					[collectionView yc_endLoadmore];
				}
			}];
		});
	}];
	
    NSArray *initArray = @[@"有问题请联系->《iOS编程之美》技术讨论群：343640780",@"有问题请联系->微信:Liyuechun2012", @"有问题请联系->QQ:939442932 1244357005",@"春哥：https://github.com/LiYueChun", @"简书地址:http://www.jianshu.com/users/336468483205/latest_articles", @"新浪微博:http://weibo.com/mobiledevelopment", @"新浪博客:http://blog.sina.com.cn/technicalarticle"];
    
    _refreshData = [[NSMutableArray alloc] initWithArray:initArray];
    
}

#pragma mark --UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _refreshData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *const cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
    
    
    NSString *title = _refreshData[indexPath.item];
    cell.textLabel.text = title;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.item < _refreshData.count;;
}

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.item < _refreshData.count;;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

static CGFloat const kInteritemSpacing = 2.0f;

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
#warning kItemsPerRow如果修改成2就是两列
    static NSUInteger const kItemsPerRow = 1;
    CGFloat const availableWidth = CGRectGetWidth(collectionView.frame) - (kItemsPerRow + 1) * kInteritemSpacing;
    return CGSizeMake(floorf(availableWidth/kItemsPerRow), 44.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kInteritemSpacing;
}


@end












