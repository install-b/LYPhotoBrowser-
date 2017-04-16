//
//  LYPhotoAminator.h
//  TaiYangHua
//
//  Created by admin on 16/12/22.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LYPhotoAminatorDelegate;
@interface LYPhotoAminator : NSObject <UIViewControllerTransitioningDelegate>
/**
 *  delegate
 */
@property(nonatomic,weak) id<LYPhotoAminatorDelegate> delegate;
@end
#pragma mark - ------- LYPhotoAminatorDelegate ---------
@protocol LYPhotoAminatorDelegate <NSObject>
/**
 获取开始modal位置视图
 
 @return 返回一个初始化视图
 */
- (UIImageView *)initalPositonAnimateViewWithPhotoAminator:(LYPhotoAminator *)animator;

/**
 获取结束modal位置的视图
 
 @return 返回一个结束位置的视图
 */
- (UIView *)dismissToViewWithPhotoAminator:(LYPhotoAminator *)animator;

/**
 结束动画的图片视图
 
 @return 返回一个需结束动画的图片视图
 */
- (UIImageView *)dismissFromImageViewWithPhotoAminator:(LYPhotoAminator *)animator;
@optional

/**
 已经控制完成modal

 @param animator modal动画器
 @param animaView 开始model位置视图
 */
- (void)photoAminator:(LYPhotoAminator *)animator didPresectedWithView:(UIView *)animaView;

/**
 即将modal控制器

 @param animator modal动画器
 @param animaView 开始model位置视图
 */
- (void)photoAminator:(LYPhotoAminator *)animator willPresentingWithView:(UIView *)animaView;
@end
