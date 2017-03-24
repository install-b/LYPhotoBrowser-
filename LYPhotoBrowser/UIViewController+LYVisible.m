//
//  UIViewController+LYVisible.m
//  LYPhotoBrowserDemo
//
//  Created by Shangen Zhang on 17/3/19.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import "UIViewController+LYVisible.h"

@implementation UIViewController (LYVisible)

- (instancetype)visibleViewController {
    if (self.view.window) {
        return self;
    }
    // 递归寻找 当前控制器的可视 控制器
    return [self.presentedViewController visibleViewController];
}
+ (UIViewController *)rootVisibaleViewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController.visibleViewController;
}

+ (UIView *)rootVisibaleView {
    return [UIApplication sharedApplication].keyWindow.rootViewController.visibleViewController.view;
}

@end
