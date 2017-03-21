//
//  LYPhotoImageView.m
//  LYPhotoBrowserDemo
//
//  Created by Shangen Zhang on 17/3/19.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import "LYPhotoImageView.h"
#import "UIImage+ScreenSize.h"

@interface LYPhotoImageView () <UIGestureRecognizerDelegate>
///** <#statements#> */
//@property(nonatomic,assign) CGPoint pinchStartP;
//
///** <#statements#> */
//@property(nonatomic,assign) CGPoint pinchMoveP;


@end

@implementation LYPhotoImageView
#pragma mark - initalized
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addGestureRecognizers];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addGestureRecognizers];
}

#pragma mark - addGestureRecognizer
- (void)addGestureRecognizers {
    // 旋转手势
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureRecognizer:)];
    rotation.delegate = self;
    [self addGestureRecognizer:rotation];
    
    // 捏合手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizer:)];
    pinch.delegate = self;
    [self addGestureRecognizer:pinch];
    
    // 单击手势
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [self addGestureRecognizer:singleTapGestureRecognizer];
    // 双击手势
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognizer:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTap];
    // 双击手势建立在单击手势上
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTap];
}

#pragma mark - UIGestureRecognizerDelegate
// 是否允许多手势 操作
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    if ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        return  self.frame.origin.x > 0;
    }
    return YES;
}

#pragma mark - dealGestureRecognizerEvents
- (void)singleTapGestureRecognizer:(UITapGestureRecognizer *)sigleTap {
    // 单击返回原值 do noting
    //[self resetImageSizeAnimate];
}
- (void)doubleTapGestureRecognizer:(UITapGestureRecognizer *)doubleTap {
   // 双击放大
    if (self.bounds.size.width > SCREEN_W) {
        [self resetImageSizeAnimate];
    } else {
        [self seeBigImageAmimate];
    }
    
}

- (void)rotationGestureRecognizer:(UIRotationGestureRecognizer *)sender {
    
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        self.rotationStartP = [sender locationInView:sender.view];
//    }
//    
//    CGPoint moveP =  [sender locationInView:sender.view];
    self.transform =  CGAffineTransformRotate(self.transform, sender.rotation);
    // 手势复位
    [sender setRotation:0];
    
    // 结束手势
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self resetImageSizeAnimate];
    }
}

- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)sender {
    
    if ([self.delegate respondsToSelector:@selector(photoImageView:needTransferToSize:)]) {
        CGFloat scale = sender.scale;
        CGSize size = self.bounds.size;
        [self.delegate photoImageView:self needTransferToSize:CGSizeMake(size.width * scale, size.height * scale)];
    }
    
    // 复位
    [sender setScale:1];
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.bounds.size.width / self.image.size.width > 1) {
            [self seeBigImageAmimate];
        } else if (self.bounds.size.width / SCREEN_W < 1) {
            [self resetImageSizeAnimate];
        }
    }
    
//    self.transform = CGAffineTransformScale(self.transform, sender.scale, sender.scale);
//    //复位操作
//    [sender setScale:1];
////
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        self.pinchStartP = [sender locationInView:sender.view];
//    }
//    
//   self.pinchMoveP = [sender locationInView:sender.view];
//    
//    
//    // 手势结束
//    if (sender.state == UIGestureRecognizerStateEnded) {
//        // 图像缩小了 需要复位
//        if (self.frame.origin.x > 0.0f) {
////            [UIView animateWithDuration:0.15 animations:^{
////                self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
////            }];
//            [self resetImageSizeAnimate];
//        }
//        // 图像超过了伸缩范围 复位
//        else if (self.frame.size.width > self.image.size.width) {
//            [self seeBigImageAmimate];
//        }
//        
//        else {
//            // 其他情况
//            if ([self.delegate respondsToSelector:@selector(photoImageView:willTransferToSize:)]) {
//                [self.delegate photoImageView:self willTransferToSize:self.frame.size];
//            }
//        }
//    }
}

#pragma mark - shrink animation
// 复位动画
- (void)resetImageSizeAnimate {
//    if ([self.delegate respondsToSelector:@selector(photoImageView:willTransferToSize:)]) {
//        [self.delegate photoImageView:self willTransferToSize:self.image.size];
//    }
//    [UIView animateWithDuration:0.15 animations:^{
//        self.transform = CGAffineTransformIdentity;
//    }];
    
    if ([self.delegate respondsToSelector:@selector(photoImageView:willTransferToSize:)]) {
        [self.delegate photoImageView:self willTransferToSize:[self.image getImageScreenSize]];
    }

}
// 放大动画
- (void)seeBigImageAmimate {
    
    if ([self.delegate respondsToSelector:@selector(photoImageView:willTransferToSize:)]) {
        [self.delegate photoImageView:self willTransferToSize:self.image.size];
    }
//    CGFloat scale = self.image.size.width / SCREEN_W;
//    if ([self.delegate respondsToSelector:@selector(photoImageView:willTransferToSize:)]) {
//        [self.delegate photoImageView:self willTransferToSize:CGSizeMake(self.image.size.width * scale, self.image.size.height * scale)];
//    }
//    [UIView animateWithDuration:0.15 animations:^{
//        self.transform = CGAffineTransformMakeScale(scale,scale);
//    }];
}
@end
