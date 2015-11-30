# YCRefreshControl


               ___                   __
              / (_)_ ____ _____ ____/ /  __ _____
             / / / // / // / -_) __/ _ \/ // / _ \
            /_/_/\_, /\_,_/\__/\__/_//_/\_,_/_//_/
                /___/


##YCRefreshControl是什么?
这是一款基于UIScrollView的轻量级，简易的的零配置的上下拉刷新控件。

##YCRefreshControl使用方法？

* 下载demo，直接将YCRefreshControl文件夹拖拽到工程中，在您要使用刷新的控制器里面直接导入YCRefreshControl.h头文件即可。


* 因为UICollectionView，UITableView都是UIScrollView的子类，所以UIScrollView，UICollectionView，UITableView的使用方法一样
<html>

       
    @weakify(scrollView);
    [scrollView setRefreshAction:^{
        @strongify(scrollView);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [scrollView endRefresh];
        });
    }];

</html>

* UIWebView不是UIScrollView的子类，但是UIWebView有一个scrollView属性， UIWebView的使用方法如下。


     UIScrollView *scrollView = webView.scrollView;
     [scrollView setRefreshAction:^{
        @strongify(scrollView);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [scrollView endRefresh];
        }); 
        }];
        
##有问题反馈
在使用中有任何问题，欢迎反馈给我，可以用以下联系方式跟我交流

* 邮件:(liyuechun2009@163.com)
* QQ群: 343640780
* weibo: [@千锋教育黎跃春](http://weibo.com/mobiledevelopment)

##您的鼓励是我前进的动力
在兴趣的驱动下,写一个`免费`的东西，有欣喜，也还有汗水，希望你喜欢我的作品，同时也能支持一下。有钱的捧个钱场，没钱的回家拿钱捧个钱场，star一下。


##项目贡献者


<table border = '1'>
    <tr align = 'center' height = '50'>
        <td width = '150' height = '50'>项目贡献者</td>
        <td width = '150' height = '50'>联系QQ</td>
    </tr>
    <tr align = 'center' height = '50'>
        <td width = '150' height = '50'>黎跃春[笑傲人生]</td>
        <td width = '150' height = '50'>939442932</td>
    </tr>
    <tr align = 'center' height = '50'>
        <td width = '150' height = '50'>王广威</td>
        <td width = '150' height = '50'>524968369</td>
    </tr>
</table>









