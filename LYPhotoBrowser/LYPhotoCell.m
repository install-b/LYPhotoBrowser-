//
//  LYPhotoCell.m
//  TaiYangHua
//
//  Created by admin on 16/12/15.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "LYPhotoCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import <DACircularProgressView.h>
#import "UIImage+ScreenSize.h"

@interface LYPhotoCell ()
    
/** scrollViewu查看长图 */
@property(nonatomic,weak) UIScrollView *scrollView;

/** 进度条 */
@property(nonatomic,weak) DACircularProgressView *progreView;

@end

@implementation LYPhotoCell
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    scrollView.contentSize = CGSizeZero;
    self.scrollView = scrollView;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    DACircularProgressView *progressView = [[DACircularProgressView alloc] init];
    [self addSubview:progressView];
    self.progreView = progressView;
    progressView.progressTintColor  = [UIColor colorWithWhite:0.98 alpha:0.99];
    
    __weak typeof(self) weakSelf = self;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf);
    }];
    
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.height.width.equalTo(@(120));
    }];
}

- (void)setImagePath:(NSString *)imagePath {
    _imagePath = imagePath;
    self.progreView.hidden = NO;
    self.progreView.progress = 0;
    [self bringSubviewToFront:self.progreView];
    
    if (![imagePath containsString:@"://"]) {
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        self.imageView.frame = [image getImageScreenFrame];
        [self bringSubviewToFront:self.imageView];
        self.progreView.hidden = YES;
        self.imageView.image = image;
        if (_complete) {
            _complete();
        }
        return;
    }
    
    NSURL *url = [NSURL URLWithString:imagePath];
    __weak typeof(self) weakSelf = self;
    [self.imageView sd_setImageWithURL:url placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize ,NSURL *url) {
        self.progreView.progress = 1.0 * receivedSize / expectedSize;
        if (_progress) {
            _progress(1.0 * receivedSize / expectedSize);
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.progreView.hidden = YES;
            weakSelf.imageView.frame = [image getImageScreenFrame];
            [weakSelf bringSubviewToFront:weakSelf.imageView];
            if (_complete) {
                _complete();
            }
        }
    }];

}
@end
