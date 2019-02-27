# EPLoadingView
UIVIew的Category类用于页面加载状态展示

使用方法如下
#import "UIView+EPRequest.h"

__weak typeof(self) weakSelf = self;
//设置加载失败点击回调
[self.tableView setReloadBlock:^{
    [weakSelf loadData];
}];
//设置无数据点击回调
[self.tableView setNotResultBlock:^{
    [weakSelf loadData];
}];

//加载中
[self.tableView requestWithStatus:TyLoadingStatus_Loading];
//需要登录
[self.tableView requestWithStatus:TyLoadingStatus_NotLogin];
//无数据
[self.tableView requestWithStatus:TyLoadingStatus_NotResult];
//加载失败
[self.tableView requestWithStatus:TyLoadingStatus_Failure];
//隐藏
[self.tableView hideRequestView];
