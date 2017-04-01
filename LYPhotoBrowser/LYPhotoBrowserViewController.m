//
//  LYPhotoBrowserViewController.m
//  TaiYangHua
//
//  Created by admin on 16/12/15.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "LYPhotoBrowserViewController.h"
#import "LYPhotoBrowserView.h"
#import "SGPictureTool.h"
#import "SDWebImage/SDImageCache.h"
#import "LYPhotoAminator.h"
#import "UIViewController+LYVisible.h"

@interface LYPhotoBrowserViewController () <LYPhotoAminatorDelegate,LYPhotoBrowserViewDelegate,UIGestureRecognizerDelegate>
{
    NSInteger _initalIndex; // 展示起始位置索引值
    BOOL _finishedLoadImageView;
}

/** 开始动画视图 aninatorView */
@property(nonatomic,weak) UIImageView *startImageView;
    
/** modal动画器 */
@property(nonatomic,strong) LYPhotoAminator *animator;
/** 浏览视图(self.view) */
@property(nonatomic,weak) LYPhotoBrowserView *photoBrowserView;
@end

@implementation LYPhotoBrowserViewController
#pragma mark - 控制器视图配置
- (void)loadView {
   
    LYPhotoBrowserView *photoBrowserView = [[LYPhotoBrowserView alloc] init];
    photoBrowserView.frame = [UIScreen mainScreen].bounds;
    self.view = photoBrowserView;
    self.photoBrowserView = photoBrowserView;
    photoBrowserView.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSelfView:)];
    tap.delegate = self;
    [photoBrowserView addGestureRecognizer:tap];
}

#pragma mark - 构造方法
- (instancetype)init {
    if (self = [super init]) {
        _animator = [[LYPhotoAminator alloc] init];
        _animator.delegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self.animator;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

#pragma mark - comstom modal Anima
#pragma mark  消失动画
- (void)touchSelfView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark  modal 动画 public mothed
// modal 处理
- (void)presentedWithView:(UIImageView *)imageView imageIndex:(NSInteger)imageIndex{
    //容错处理
    if (![imageView isKindOfClass:[UIImageView class]]) {
        return;
    }
    // 起始位置索引配置
    _initalIndex = imageIndex;
    // 配置视图控制器起始model位置图片
    self.startImageView = imageView;
    
    // 获取可见的根控制器
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController.visibleViewController;
    
    //modal 浏览器
    [rootVc presentViewController:self animated:YES completion:nil];
}
// 设置无限滚动
- (void)setInfiniteCycleBrowserEnable:(BOOL)enable {
    [(LYPhotoBrowserView *)self.view setInfifiteCycleEnable:enable];
    
}
#pragma mark - 
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIImageView class]]) {
        return NO;
    }
    return YES;
}
#pragma mark - LYPhotoAminatorDelegate 动画代理
// 获取起始图片位置
- (UIImageView *)animatePositonView {
    UIImageView *imageView = self.startImageView;
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
        imageView.center = [UIApplication sharedApplication].keyWindow.rootViewController.view.center;
    }
    return imageView;
}
// 完成model 动画调用
- (void)presentingAnimaDidCompleteWithView:(UIView *)animaView {
    // 设置起始位置
    _finishedLoadImageView = YES;
    [self.photoBrowserView setInitalIndex:_initalIndex];
}
// 即将modal时候调用
- (void)presentingAnimaWillPresenting:(UIView *)animaView {
    self.startImageView = (UIImageView *)animaView;
}

#pragma mark - LYPhotoBrowserViewDelegate 视图代理
// 获取图片个数的总数
- (NSInteger)numberOfItemsForInfiniteSlideView:(LYPhotoBrowserView *)photoBrowserView {
    return self.imagePaths.count;
}
// 获取图片URL
- (NSString *)imageURLForPhotoBrowserView:(LYPhotoBrowserView *)photoBrowserView inIndex:(NSInteger)index {
    return self.imagePaths[index];
}

// 加载第一张图
- (void)didLoadStartImageIndex:(NSInteger)startIndex photoBrowserView:(LYPhotoBrowserView *)photoBrowserView {
    
    if (_finishedLoadImageView && startIndex == _initalIndex) {
        [self.startImageView removeFromSuperview];
        self.startImageView = nil;
        _finishedLoadImageView = NO;
    }
}

// 保存图片
- (void)photoBrowserView:(LYPhotoBrowserView *)photoBrowserView saveImage:(UIImage *)image {
    // 不需要保存
    if ([self.delegate respondsToSelector:@selector(photoBrowserViewController:shouldSaveImage:withImageIdex:)] &&
        ![self.delegate photoBrowserViewController:self shouldSaveImage:image withImageIdex:photoBrowserView.currentIndex]) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    // 保存图片到相册
    [SGPictureTool sg_saveAImage:image withFolferName:self.photoDirectoryName error:^(NSError *error) {
        // 通知代理
        if ([weakSelf.delegate respondsToSelector:@selector(photoBrowserViewController:didSaveImage:withError:)]) {
            [weakSelf.delegate photoBrowserViewController:weakSelf didSaveImage:image withError:error];
        }
    }];
}
// 即将展示的视图索引
- (void)photoBrowserView:(LYPhotoBrowserView *)photoBrowserView willShowIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(photoBrowserView:willShowIndex:)]) {
        [self.delegate photoBrowserViewController:self willShowIndex:index];
    }
}

// 已近展示了第几张图
- (void)photoBrowserView:(LYPhotoBrowserView *)photoBrowserView didShowIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(photoBrowserView:didShowIndex:)]) {
        [self.delegate photoBrowserViewController:self didShowIndex:index];
    }
}
#pragma mark - lazy load
- (NSString *)photoDirectoryName { // 相册名称
    if (!_photoDirectoryName) {
        _photoDirectoryName =  [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleExecutableKey];
    }
    return _photoDirectoryName;
}

@end
