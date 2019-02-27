//
//  UIView+EPRequest.m
//  EPProject
//
//  Created by Jarhom on 2019/2/27.
//  Copyright © 2019 厦门一品威客网络科技有限公司. All rights reserved.
//

#import "UIView+EPRequest.h"

static const char requestViewKey;

static const char reloadBlockKey;
static const char notResultBlockKey;
//static const char notLoginBlockKey;



@implementation UIView (EPRequest)

- (void)requestWithStatus:(TyLoadingStatus)status {
    [self requestWithStatus:status awayTop:0 alpha:1];

}

- (void)requestWithStatus:(TyLoadingStatus)status alpha:(CGFloat)alpha {
    [self requestWithStatus:status awayTop:0 alpha:alpha];
}

- (void)requestWithStatus:(TyLoadingStatus)status awayTop:(NSInteger)height {
    [self requestWithStatus:status awayTop:height alpha:1];
}

- (void)requestWithStatus:(TyLoadingStatus)status awayTop:(NSInteger)height alpha:(CGFloat)alpha{
    EPRequestView *view = [self requestView];
    view.status = status;
    view.frame = CGRectMake(0, height, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-height);
    view.alpha = alpha;
    
    view.hidden = NO;
}

- (void)hideRequestView {
    EPRequestView *view = [self requestView];
    view.status = TyLoadingStatus_None;
    view.hidden = YES;
    [view removeFromSuperview];
    objc_setAssociatedObject(self, &requestViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - set

- (void)setNotResultTitle:(NSString *)title Icon:(UIImage *)image {
    EPRequestView *view = [self requestView];
    [view setNotResultTitle:title Icon:image];
}


-(void)setFailureTitle:(NSString *)title Icon:(UIImage *)image {
    EPRequestView *view = [self requestView];
    [view setFailureTitle:title Icon:image];
}

- (void)setNotLoginTitle:(NSString *)title Icon:(UIImage *)image {
    EPRequestView *view = [self requestView];
    [view setNotLoginTitle:title Icon:image];
}

//设置重新加载block
- (void)setReloadBlock:(void(^)(void))reloadBlock {
    objc_setAssociatedObject(self, &reloadBlockKey, reloadBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

//设置没有数据跳转block
- (void)setNotResultBlock:(void(^)(void))notResultBlock {
    objc_setAssociatedObject(self, &notResultBlockKey, notResultBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (EPRequestView *)requestView {
    
    EPRequestView *view = objc_getAssociatedObject(self, &requestViewKey);
    if (!view) {
        view = [[EPRequestView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        view.backgroundColor = [UIColor whiteColor];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        view.hidden = YES;
        
        view.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContentView:)];
        view.tapGesture.delegate = (id<UIGestureRecognizerDelegate>)view;
        [view addGestureRecognizer:view.tapGesture];
        
        if (!view.superview) {
            // Send the view all the way to the back, in case a header and/or footer is present, as well as for sectionHeaders or any other content
            if (([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]]) && self.subviews.count > 1) {
                [self insertSubview:view atIndex:0];
            }
            else {
                [self addSubview:view];
            }
        }
        objc_setAssociatedObject(self, &requestViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    }
    
    return view;
    
    
}


#pragma mark - private


- (void)didTapContentView:(id)sender {
    EPRequestView *view = [self requestView];

    if (view.status == TyLoadingStatus_NotResult) {
        void (^notResultBlock)(void) = objc_getAssociatedObject(self, &notResultBlockKey);
        if (notResultBlock) notResultBlock();
    } else if (view.status == TyLoadingStatus_Failure) {
        void (^reloadBlock)(void) = objc_getAssociatedObject(self, &reloadBlockKey);
        if (reloadBlock) reloadBlock();
    } else if (view.status == TyLoadingStatus_NotLogin) {
        //未登录点击
        
    }
}





@end
