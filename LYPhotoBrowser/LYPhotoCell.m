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

@interface LYPhotoCell () <LYPhotoImageViewDelegate>
    
/** scrollViewu查看长图 */
@property(nonatomic,weak) UIScrollView *scrollView;

/** 进度条 */
@property(nonatomic,weak) LYProgressView *progreView;

@end

@implementation LYPhotoCell
- (instancetype)init {
    if (self = [super init]) {
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
- (void)photoImageView:(LYPhotoImageView *)photoImageView willTransferToSize:(CGSize)tranferSize {
    self.scrollView.contentSize = tranferSize;
    CGFloat temp = (SCREEN_H - tranferSize.height) * 0.5;

    [UIView animateWithDuration:0.12 animations:^{
        self.imageView.frame = CGRectMake(0,  (temp >=0) ? temp : 0 , tranferSize.width, tranferSize.height);
    }];
    
}
- (void)photoImageView:(LYPhotoImageView *)photoImageView needTransferToSize:(CGSize)tranferSize {
    self.scrollView.contentSize = tranferSize;
    CGFloat Y = (SCREEN_H - tranferSize.height) * 0.5;
    
    self.imageView.frame = CGRectMake(0, (Y >=0) ? Y : 0 , tranferSize.width, tranferSize.height);
}

@end
