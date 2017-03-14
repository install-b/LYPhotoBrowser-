//
//  LYPhotoBrowserViewController.h
//  TaiYangHua
//
//  Created by admin on 16/12/15.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYPhotoBrowserViewController;

@protocol LYPhotoBrowserViewControllerDelegate <NSObject>
@optional
    
/**
 已经保存了一张图片回调

 @param PhotoBrowserVc 图片浏览控制器
 @param image 保存的图片
 @param error 有值得时候代表保存失败
 */
- (void)photoBrowserViewController:(LYPhotoBrowserViewController *)PhotoBrowserVc didSaveImage:(UIImage *)image withError:(NSError *)error;
@end

@interface LYPhotoBrowserViewController : UIViewController

/** 数据源 */
@property(nonatomic,strong) NSArray<NSString *> *imagePaths;

/** delegate */
@property (nonatomic,weak) id<LYPhotoBrowserViewControllerDelegate> delegate;

/** 保存图片到相册的文件夹名称（不设置默认为app名称） */
@property (nonatomic,copy) NSString *photoDirectoryName;
    
/**
 *  弹出浏览控制器
 *
 * imageView:从哪里modal出来
 * imageIndex:显示开始第一张图片的索
 */
- (void)presentedWithView:(UIImageView *)imageView imageIndex:(NSInteger)imageIndex;
@end
