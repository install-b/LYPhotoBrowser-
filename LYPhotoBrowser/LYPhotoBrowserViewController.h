//
//  LYPhotoBrowserViewController.h
//  TaiYangHua
//
//  Created by admin on 16/12/15.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 图片浏览数据源 协议
 */
@protocol LYPhotoDataSourceProtocol <NSObject>
@required

/**
 展示的图片来源为内存
 优先展示此图片
 可以为空
 */
- (UIImage *)ly_image;

/**
 加载的图片为网络图片时 的占位图
 */
- (UIImage *)ly_placeholderImage;

/**
 展示的图片来源为本地磁盘
 当‘- ly_image’方法返回空时候 会调用该方法
 也可以为空
 */
- (NSString *)ly_imageLocalPath;


/**
 展示的图片来源为网络
 当 内存图片和本地资源都返回空时  调用
 不能为空
 */
- (NSString *)ly_imageURL;

@end









@protocol LYPhotoBrowserViewControllerDelegate;
#pragma mark - --------- LYPhotoBrowserViewController --------
/**
 图片浏览器
 */
@interface LYPhotoBrowserViewController : UIViewController

/**
 构造方法 初始化数据源
 */
- (instancetype)initWithDataSource:(NSArray <LYPhotoDataSourceProtocol> *)dataSource;

/** 数据源 */
@property (nonatomic,strong) NSArray <LYPhotoDataSourceProtocol> * dataSource;

/** delegate */
@property (nonatomic,weak) id <LYPhotoBrowserViewControllerDelegate> delegate;

/** 保存图片到相册的文件夹名称（不设置默认为app名称） */
@property (nonatomic,copy) NSString *photoDirectoryName;

/** 
 是否隐藏底部工具条 hidden bottom toolbar 
        默认为 NO
        当设置为YES时候可以自定义工具条
 */
@property(nonatomic,assign,getter=isHiddenBottomToolBar) BOOL hiddenBottomToolBar;


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









#pragma mark - --------- LYPhotoBrowserViewControllerDelegate --------
@protocol LYPhotoBrowserViewControllerDelegate <NSObject>
@optional

/**
 返回一个浏览器消失动画的视图
 
 @param imageIndex 即将消失的图片索引
 @param PhotoBrowserVc 图片浏览器
 @return 消失的位置 可以为空
 */
- (UIView *)viewForDisMissWithImageIndex:(NSInteger)imageIndex photoBrowserViewController:(LYPhotoBrowserViewController *)PhotoBrowserVc;

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
