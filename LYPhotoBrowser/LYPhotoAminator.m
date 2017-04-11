//
//  LYPhotoAminator.m
//  TaiYangHua
//
//  Created by admin on 16/12/22.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "LYPhotoAminator.h"
#import "UIImage+ScreenSize.h"

//
@interface LYHpotoPresentationController : UIPresentationController
@end

#pragma mark - 动画展示器 *****************************************
@interface LYPhotoAminator ()<UIViewControllerAnimatedTransitioning>
/** 记录消失还是展示  */
@property(nonatomic,assign) BOOL presented;
@end

@implementation LYPhotoAminator
#pragma mark - <UIViewControllerAnimatedTransitioning> 负责如何展示动画消失
//设置动画的时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.25f;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
//设置怎样展示动画 无论是弹出还是销毁都会调用这个方法来设置动画
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    UIView *containnerView = [transitionContext containerView];
  
    if (self.presented) { // modal时候
        //    1.获取toView
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        [containnerView addSubview:toView];
        toView.hidden = YES;
        
        UIImageView *imageCell = [self.delegate animatePositonView];
        UIImage *image = [imageCell.image copy];
        CGRect fromFrame = [imageCell convertRect:imageCell.bounds toView:containnerView];
        CGRect toFrame = [image getImageScreenFrame];
        
        // modal图片动画
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = fromFrame;
        [containnerView addSubview:imageView];
        
        if ([self.delegate respondsToSelector:@selector(presentingAnimaWillPresenting:)]) {
             [self.delegate presentingAnimaWillPresenting:imageView];
        }
       
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0 options:0 animations:^{
            containnerView.alpha = 1.0;
            imageView.frame = toFrame;
            
            [toView layoutIfNeeded];
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(presentingAnimaDidCompleteWithView:)]) {
                [self.delegate presentingAnimaDidCompleteWithView:imageView];
            }
            toView.hidden = NO;
            //  等动画结束的时候,要告诉系统动画已经结束
            [transitionContext completeTransition:YES];
        }];
        
    }
    
    else{ // dissmiss时候
        
        UIView *tagetView = [self.delegate targetDisMissView];
        
        //  缩放动画
        if (tagetView && tagetView.window) {
            UIImageView *imageView = [self.delegate disMissIamgeView];
            
            UIView * presentedView = [transitionContext viewForKey:UITransitionContextFromViewKey];
            
            CGRect fromFrame = [imageView convertRect:imageView.bounds toView:containnerView];
            
            imageView.frame = fromFrame;
            
            [containnerView addSubview:imageView];
            
            presentedView.alpha  = 0.0f;
            
            CGRect toframe = [tagetView convertRect:tagetView.bounds toView:containnerView];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                imageView.frame = toframe;
            } completion:^(BOOL finished) {
                //  等动画结束的时候,要告诉系统动画已经结束
                [transitionContext completeTransition:YES];
            }];
            return;
        }
        
        // 消失动画
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            containnerView.alpha = 0.01;
            containnerView.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
            [containnerView layoutIfNeeded];
        }completion:^(BOOL finished) {
            //  等动画结束的时候,要告诉系统动画已经结束
            [transitionContext completeTransition:YES];
        }];
    }
}

#pragma mark -  <UIViewControllerTransitioningDelegate> 控制由谁来展示 消失
// 负责展示的动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.presented = YES;
    
    return self;
}

// 负责消失的动画
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.presented = NO;
    return self;
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[LYHpotoPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

@end

#pragma mark - 动画执行视图控制器 *****************************************
#pragma mark LYHpotoPresentationController 负责管理控制器
@implementation LYHpotoPresentationController

//用来布局containerView中子控件的frame
- (void)containerViewDidLayoutSubviews{
    //NSLog(@"%s",__func__);
    self.presentedView.frame = self.containerView.bounds;
}

- (void)presentationTransitionWillBegin{
    
    [self.containerView addSubview:self.presentedView];
    //NSLog(@"%s",__func__);
}

- (void)dismissalTransitionDidEnd:(BOOL)completed{
    //[self.containerView removeFromSuperview];
    [self.containerView addSubview:self.presentedView];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    //NSLog(@"%s",__func__);
}
- (void)dismissalTransitionWillBegin {
    //NSLog(@"%s",__func__);
}
@end

