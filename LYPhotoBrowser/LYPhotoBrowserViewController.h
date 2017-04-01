//
//  LYPhotoBrowserViewController.h
//  TaiYangHua
//
//  Created by admin on 16/12/15.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYPhotoBrowserViewController;

#pragma mark - --------- LYPhotoBrowserViewControllerDelegate --------
@protocol LYPhotoBrowserViewControllerDelegate <NSObject>
@optional

/**
 即将展示的图片索引

 @param PhotoBrowserVc 图片浏览控制器
 @param index 即将展示的索引
 */
- (void)photoBrowserViewController:(LYPhotoBrowserViewController *)PhotoBrowserVc willShowIndex:(NSInteger)index;

/**
 已经展示的图片索引

 @param PhotoBrowserVc 图片浏览控制器
 @param index 已经展示的索引
 */
- (void)photoBrowserViewController:(LYPhotoBrowserViewController *)PhotoBrowserVc didShowIndex:(NSInteger)index;

/**
 是否需要保存 当前图片到相册

 @param PhotoBrowserVc 图片浏览控制器
 @param image 要保存的图片
 @param currentIndex 当前索引
 @return YES 保存至相册， NO 不会进行保存 （默认YES）
 */
- (BOOL)photoBrowserViewController:(LYPhotoBrowserViewController *)PhotoBrowserVc shouldSaveImage:(UIImage *)image withImageIdex:(NSInteger)currentIndex;

/**
 已经保存了一张图片回调

 @param PhotoBrowserVc 图片浏览控制器
 @param image 保存的图片
 @param error 有值得时候代表保存失败
 */
- (void)photoBrowserViewController:(LYPhotoBrowserViewController *)PhotoBrowserVc didSaveImage:(UIImage *)image withError:(NSError *)error;

@end

#pragma mark - --------- LYPhotoBrowserViewController --------

/**
 图片放大浏览器
 */
@interface LYPhotoBrowserViewController : UIViewController

/** 数据源 */
@property(nonatomic,strong) NSArray<NSString *> *imagePaths;

/** delegate */
@property (nonatomic,weak) id <LYPhotoBrowserViewControllerDelegate> delegate;

/** 保存图片到相册的文件夹名称（不设置默认为app名称） */
@property (nonatomic,copy) NSString *photoDirectoryName;

/**
 设置浏览是否需要无限循环滚动浏览

 @param enable 默认为YES
 */
- (void)setInfiniteCycleBrowserEnable:(BOOL)enable;

/**
 *  弹出浏览控制器
 *
 * imageView:从哪里modal出来
 * imageIndex:显示开始第一张图片的索
 */
- (void)presentedWithView:(UIImageView *)imageView imageIndex:(NSInteger)imageIndex;
@end
