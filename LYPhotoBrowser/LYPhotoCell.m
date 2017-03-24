//
//  LYPhotoCell.m
//  TaiYangHua
//
//  Created by admin on 16/12/15.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "LYPhotoCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ScreenSize.h"
#import "LYProgressView.h"
#import "UIViewController+LYVisible.h"
@interface LYPhotoCell () <LYPhotoImageViewDelegate>
    
/** scrollViewu查看长图 */
@property(nonatomic,weak) UIScrollView *scrollView;

/** 进度条 */
@property(nonatomic,weak) LYProgressView *progreView;

@end

@implementation LYPhotoCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    
    LYPhotoImageView *imageView = [[LYPhotoImageView alloc] init];
    imageView.delegate = self;
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    LYProgressView *progressView = [[LYProgressView alloc] init];
    [self addSubview:progressView];
    self.progreView = progressView;
    self.cellIndex = -1;
    
    __weak typeof(self) weakSelf = self;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf);
    }];
    
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.height.width.equalTo(@(100));
    }];
}

- (void)setImagePath:(NSString *)imagePath {
    
    _imagePath = imagePath;
    
    // 复用重置操作
    self.imageView.userInteractionEnabled = NO;
    self.imageView.transform = CGAffineTransformIdentity;
    self.imageView.image = nil;
    self.progreView.hidden = NO;
    self.progreView.progress = 0;
    self.scrollView.contentSize = CGSizeZero;
    [self bringSubviewToFront:self.progreView];

    // 加载图片
    // 本地加载
    if (![imagePath containsString:@"://"]) {
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        [self didLoadImage:image];
        return;
    }
    
    // 网络加载 SDWebImage
    __weak typeof(self) weakSelf = self;
    __block CGFloat preogress;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize ,NSURL *url) {
        preogress = 1.0 * receivedSize / expectedSize;
        // 经度是在子线程回调的
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.progreView setProgress:preogress];
            !weakSelf.progress ?: weakSelf.progress(preogress);
        });
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf didLoadImage:image];
    }];
}

// 图片加载完毕
- (void)didLoadImage:(UIImage *)image {
    
    if (image) {
        self.progreView.hidden = YES;
        self.imageView.image = image;
        self.imageView.frame = [image getImageScreenFrame];
        [self bringSubviewToFront:self.imageView];
        self.imageView.userInteractionEnabled = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(photoCell:didLoadImage:)]) {
        [self.delegate photoCell:self didLoadImage:image];
    }
}

#pragma mark - LYPotoImageDelegate
- (void)photoImageView:(LYPhotoImageView *)photoImageView willTransferToSize:(CGSize)tranferSize locationPoint:(CGPoint)locationPoint {
    return [self photoImageView:photoImageView willTransferToSize:tranferSize locationPoint:locationPoint duration:0.25];
}
- (void)photoImageView:(LYPhotoImageView *)photoImageView needTransferToSize:(CGSize)tranferSize locationPoint:(CGPoint)locationPoint {
    return [self photoImageView:photoImageView willTransferToSize:tranferSize locationPoint:locationPoint duration:0.0];
}

#pragma mark - image transfer
- (void)photoImageView:(LYPhotoImageView *)photoImageView willTransferToSize:(CGSize)tranferSize locationPoint:(CGPoint)locationPoint duration:(NSTimeInterval)duration {
   
    CGPoint screenP = [photoImageView convertPoint:locationPoint toView:[UIViewController rootVisibaleView]];
    
    CGSize oringeSize = photoImageView.bounds.size;
    
    CGFloat offsetX = locationPoint.x * tranferSize.width  /  oringeSize.width - screenP.x;
    CGFloat offsetY = locationPoint.y * tranferSize.height / oringeSize.height - screenP.y;
    CGFloat maxOffsetX = tranferSize.width - SCREEN_W;
    CGFloat maxOffsetY = tranferSize.height - SCREEN_H;
    maxOffsetX = (maxOffsetX > 0) ? maxOffsetX : 0;
    maxOffsetY = (maxOffsetY > 0) ? maxOffsetY : 0;
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    if (offsetY > maxOffsetY) {
        offsetY = maxOffsetY;
    }
    
    if (tranferSize.width <= SCREEN_W) {
        offsetX = 0;
    }
    
    if (tranferSize.height <= SCREEN_H) {
        offsetY = 0;
    }
    
    CGPoint contenOffset = CGPointMake((offsetX > 0) ? offsetX : 0, (offsetY > 0) ? offsetY : 0);
    
    self.scrollView.contentSize = tranferSize;
    CGFloat tempY = (SCREEN_H - tranferSize.height) * 0.5;
    CGFloat tempX = (tranferSize.width -  SCREEN_W) * 0.5;
    [self.scrollView setContentOffset:contenOffset animated:YES];
    
    [UIView animateWithDuration:duration animations:^{
        self.imageView.frame = CGRectMake(tempX >= 0 ? 0 : -tempX,  (tempY >=0) ? tempY : 0 , tranferSize.width, tranferSize.height);
        [self layoutIfNeeded];
    }completion:^(BOOL finished) {
        
    }];

}
@end
