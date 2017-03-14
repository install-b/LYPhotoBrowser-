//
//  LYPhotoAminator.h
//  TaiYangHua
//
//  Created by admin on 16/12/22.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LYPhotoAminatorDelegate <NSObject>
/**
 获取开始model位置视图

 @return 返回一个初始化视图
 */
- (UIImageView *)animatePositonView;
@optional

/**
 已经modal完成

 @param animaView 开始model位置视图
 */
- (void)presentingAnimaDidCompleteWithView:(UIView *)animaView;
/**
 已经modal即将开始
 
 @param animaView 开始model位置视图
 */
- (void)presentingAnimaWillPresenting:(UIView *)animaView;
    
@end


@interface LYPhotoAminator : NSObject <UIViewControllerTransitioningDelegate>
/**
 *  delegate
 */
@property(nonatomic,weak) id<LYPhotoAminatorDelegate> delegate;
@end
