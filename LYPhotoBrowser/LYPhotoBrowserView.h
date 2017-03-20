//
//  LYPhotoBrowserView.h
//  TaiYangHua
//
//  Created by shangen on 17/3/11.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYPhotoBrowserView;
@protocol LYPhotoBrowserViewDelegate <NSObject>

@required

// 共有多少图片要展示
- (NSInteger)numberOfItemsForInfiniteSlideView:(LYPhotoBrowserView *)photoBrowserView;

// 返回index值下的图片url
- (NSString *)imageURLForPhotoBrowserView:(LYPhotoBrowserView *)photoBrowserView inIndex:(NSInteger)index;

// 已经加载了index对应的图片
- (void)didLoadStartImageIndex:(NSInteger)startIndex photoBrowserView:(LYPhotoBrowserView *)photoBrowserView;

@optional
// 点击了保存图片
- (void)photoBrowserView:(LYPhotoBrowserView *)photoBrowserView saveImage:(UIImage *)image;

@end

@interface LYPhotoBrowserView : UIView

/**
 *  delegate
 */
@property(nonatomic,weak) id<LYPhotoBrowserViewDelegate> delegate;


/**
 滚动到某个index索引图

 @param index 索引值
 */
- (void)scrollToIndexItem:(NSUInteger)index;


/**
 设置是否需要循环滚动

 @param enable 默认yes
 */
- (void)setInfifiteCycleEnable:(BOOL)enable;

/**
 设置起始位置索引值

 @param initalIndex 起始索引值
 */
- (void)setInitalIndex:(NSUInteger)initalIndex;
@end
