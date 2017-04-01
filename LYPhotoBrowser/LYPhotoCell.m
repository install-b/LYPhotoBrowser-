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

@interface LYPhotoCell () <UIScrollViewDelegate>
    
/** scrollViewu查看长图 */
@property(nonatomic,weak) UIScrollView *scrollView;

/** 进度条 */
@property(nonatomic,weak) LYProgressView *progreView;

// 图片在屏幕展示的位置尺寸
@property(nonatomic,assign) CGRect imageScreenFrame;

@end

@implementation LYPhotoCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpSubViews];
    }
    return self;
}
#pragma mark setups
- (void)setUpSubViews {
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView = scrollView;
    scrollView.delegate = self;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [imageView addGestureRecognizer:doubleTapGestureRecognizer];
    
    
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

- (void)reuseSetUp {
    // 复用重置操作
    self.imageView.userInteractionEnabled = NO;
    self.imageView.transform = CGAffineTransformIdentity;
    self.imageView.image = nil;
    self.progreView.hidden = NO;
    self.progreView.progress = 0;
    self.scrollView.contentSize = CGSizeZero;
    [self bringSubviewToFront:self.progreView];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 1.0;
    self.imageScreenFrame = CGRectZero;
}

#pragma mark - setter
- (void)setImagePath:(NSString *)imagePath {
    // 属性赋值
    _imagePath = imagePath;
    
    // 重用初始化
    [self reuseSetUp];
    
    // 加载图片
    [self loadImageWithImageURL:imagePath];
}

#pragma mark - load image
- (void)loadImageWithImageURL:(NSString *)imagePath {
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
            if ([weakSelf.delegate respondsToSelector:@selector(photoCell:loadImageProgress:)]) {
                [weakSelf.delegate photoCell:weakSelf loadImageProgress:preogress];
            }
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
        self.imageScreenFrame = self.imageView.frame;
        [self bringSubviewToFront:self.imageView];
        self.imageView.userInteractionEnabled = YES;
        CGFloat scale = image.size.width / [UIScreen mainScreen].bounds.size.width;
        
        if (scale < 1) {
            scale = 1.0f;
        }else if (scale > 3) {
            scale = 3.0f;
        }
        self.scrollView.maximumZoomScale = scale;
    }
    
    if ([self.delegate respondsToSelector:@selector(photoCell:didLoadImage:)]) {
        [self.delegate photoCell:self didLoadImage:image];
    }
}
#pragma mark - double tap
- (void)doubleTap:(UITapGestureRecognizer *)tap {
    
    CGFloat maxZoom = self.scrollView.maximumZoomScale;
    // 校验
    if (!(maxZoom > 1.0f && maxZoom < 5.0f )) {
        return;
    }
    
    float newscale =  (self.scrollView.zoomScale == 1.0) ? maxZoom : 1.0;
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[tap locationInView:tap.view]];
    //重新定义其cgrect的x和y值
    [self.scrollView zoomToRect:zoomRect animated:YES];
}
#pragma mark  tap zoom
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = [_scrollView frame].size.height / scale;
    zoomRect.size.width  = [_scrollView frame].size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  * 0.5);
    zoomRect.origin.y    = center.y - (zoomRect.size.height * 0.5);
    
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollVie{
    return self.imageView;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    
    if ([self.delegate respondsToSelector:@selector(photoCell:beginZoomingScrollView:)]) {
        [self.delegate photoCell:self beginZoomingScrollView:self.scrollView];
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    
    if (scale < 1) {
        [scrollView setZoomScale:1.0 animated:YES];
    }
    else if (scrollView.zoomScale > scrollView.maximumZoomScale) {
        [scrollView setZoomScale:scrollView.maximumZoomScale animated:YES];
    }
    
    if ([self.delegate respondsToSelector:@selector(photoCell:endZoomingScrollView:)]) {
        [self.delegate photoCell:self endZoomingScrollView:self.scrollView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {

    (scrollView.zoomScale >= 1.0) ? [self dealLargenZoom:scrollView] : [self dealShrinkZoom:scrollView];
}

#pragma mark - deal offset
// 放大时候
- (void)dealLargenZoom:(UIScrollView *)scrollView {
    CGFloat offset = self.imageView.frame.origin.y;

    if (offset <= 0) return;
    
    CGFloat topInset = (SCREEN_H - _imageView.frame.size.height) * 0.5 - offset;
    
    // 计算最大的offset
    CGFloat maxTopInset = (SCREEN_H - self.imageScreenFrame.size.height) * 0.5;
    
    // 越界处理
    if (maxTopInset + topInset < 0) {
        topInset = -maxTopInset;
    }
    
    self.scrollView.contentInset = UIEdgeInsetsMake(topInset, 0, -topInset, 0);
}
// 缩小的时候
- (void)dealShrinkZoom:(UIScrollView *)scrollView {
    
    CGFloat zoom = (1 - scrollView.zoomScale) * 0.5;
    
    scrollView.contentOffset = CGPointMake(- self.imageScreenFrame.size.width * zoom, - self.imageScreenFrame.size.height * zoom);
}
@end
