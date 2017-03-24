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
//    // 旋转手势
//    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureRecognizer:)];
//    rotation.delegate = self;
//    [self addGestureRecognizer:rotation];
    
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
   
     CGPoint point = [doubleTap locationInView:doubleTap.view];
    // 双击放大
    (self.bounds.size.width > SCREEN_W) ? [self resetImageSizeAnimate:point] : [self seeBigImageAmimate:point];
}

//- (void)rotationGestureRecognizer:(UIRotationGestureRecognizer *)sender {
//    
////    if (sender.state == UIGestureRecognizerStateBegan) {
////        self.rotationStartP = [sender locationInView:sender.view];
////    }
////    
////    CGPoint moveP =  [sender locationInView:sender.view];
//    self.transform =  CGAffineTransformRotate(self.transform, sender.rotation);
//    // 手势复位
//    [sender setRotation:0];
//    
//    // 结束手势
//    if (sender.state == UIGestureRecognizerStateEnded) {
//        [self resetImageSizeAnimate];
//    }
//}

- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [sender locationInView:sender.view];
        if (self.bounds.size.width / self.image.size.width > 1) {
            [self seeBigImageAmimate:point];
        } else if (self.bounds.size.width / SCREEN_W < 1) {
            [self resetImageSizeAnimate:point];
        }
        return;
    }

    
    if ([self.delegate respondsToSelector:@selector(photoImageView:needTransferToSize:locationPoint:)]) {
        CGPoint point = [sender locationInView:sender.view];
        CGFloat scale = sender.scale;
        CGSize size = self.bounds.size;
        
        CGFloat w = size.width * scale;
        CGFloat h = size.height * scale;
        // 放大到最大时候给一个阻滞感
        if ((w > self.image.size.width || h > self.image.size.height) && scale > 1) {
            w = size.width  * (1 + 0.007 /scale );
            h = size.height * (1 + 0.007 /scale );
        }
        
        [self.delegate photoImageView:self needTransferToSize:CGSizeMake(w, h) locationPoint:point];
        // 复位
        [sender setScale:1];
    }

    
}

#pragma mark - shrink animation
// 复位动画
- (void)resetImageSizeAnimate:(CGPoint)point {
    
    if ([self.delegate respondsToSelector:@selector(photoImageView:willTransferToSize:locationPoint:)]) {
        [self.delegate photoImageView:self willTransferToSize:[self.image getImageScreenSize] locationPoint:point];
    }

}
// 放大动画
- (void)seeBigImageAmimate:(CGPoint)point {
    
    if ([self.delegate respondsToSelector:@selector(photoImageView:willTransferToSize:locationPoint:)]) {
        [self.delegate photoImageView:self willTransferToSize:self.image.size locationPoint:point];
    }
}
@end
