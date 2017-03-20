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
}

#pragma mark - UIGestureRecognizerDelegate
// 是否允许多手势 操作
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - dealGestureRecognizerEvents
- (void)rotationGestureRecognizer:(UIRotationGestureRecognizer *)sender {
    self.transform =  CGAffineTransformRotate(self.transform, sender.rotation);
    // 手势复位
    [sender setRotation:0];
    
    // 结束手势
    if (sender.state == UIGestureRecognizerStateEnded) {
        // 图像复位
        [UIView animateWithDuration:0.15 animations:^{
            self.transform = CGAffineTransformMakeRotation(0);
        }];
        
    }
}

- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)sender {
    
    self.transform = CGAffineTransformScale(self.transform, sender.scale, sender.scale);
    //复位操作
    [sender setScale:1];
    
    // 手势结束
    if (sender.state == UIGestureRecognizerStateEnded) {
        // 图像缩小了 需要复位
        if (self.frame.origin.x > 0.0f) {
            [UIView animateWithDuration:0.15 animations:^{
                self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            }];
        }
        // 图像超过了伸缩范围 复位
        else if (self.frame.size.width > self.image.size.width) {
            CGFloat scale = self.image.size.width / SCREEN_W;
            [UIView animateWithDuration:0.15 animations:^{
                self.transform = CGAffineTransformMakeScale(scale,scale);
            }];
        }
    }
}

@end
