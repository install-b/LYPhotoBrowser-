//
//  UIViewController+LYVisible.h
//  LYPhotoBrowserDemo
//
//  Created by Shangen Zhang on 17/3/19.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LYVisible)

/**
 当前在视图上的控制器 （一般为自己，但如果本身不在Windows上就会找出它modal的控制器）

 @return 控制器
 */
- (instancetype)visibleViewController;

+ (UIViewController *)rootVisibaleViewController;

+ (UIView *)rootVisibaleView;
@end
