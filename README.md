# EPLoadingView
UIVIew的Category类用于页面加载状态展示,支持scrollView

使用方法如下
# EPLoadingView使用

```
#import "UIView+EPRequest.h"



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView setReloadBlock:^{
        [weakSelf loadData];
    }];
    
    [self.tableView setNotResultBlock:^{
        [weakSelf loadData];
    }];
    
}

- (void)loadData {
    [self.tableView requestWithStatus:TyLoadingStatus_Loading];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView requestWithStatus:TyLoadingStatus_NotLogin];
//        [self.tableView requestWithStatus:TyLoadingStatus_NotResult];
//        [self.tableView requestWithStatus:TyLoadingStatus_Failure];
        [self.tableView hideRequestView];
    });
}
```
