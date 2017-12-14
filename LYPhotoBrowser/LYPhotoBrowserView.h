//
//  LYPhotoBrowserView.h
//  TaiYangHua
//
//  Created by shangen on 17/3/11.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYPhotoBrowserView;
@protocol LYPhotoDataSourceProtocol;
@protocol LYPhotoBrowserViewDelegate;


@interface LYPhotoBrowserView : UIView
/** 当前显示的图片的索引 */
@property(nonatomic,assign,readonly) NSInteger currentIndex;

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


/**
 获取当前的图片

 @return 图片视图
 */
- (UIImageView *)currentImageView;

@end




@protocol LYPhotoBrowserViewDelegate <NSObject>
@required
// 共有多少图片要展示
- (NSInteger)numberOfItemsForInfiniteSlideView:(LYPhotoBrowserView *)photoBrowserView;

// 展示的图片
- (id <LYPhotoDataSourceProtocol>)photoForPhotoBrowserView:(LYPhotoBrowserView *)photoBrowserView inIndex:(NSInteger)index;

// 已经加载了index对应的图片
- (void)didLoadStartImageIndex:(NSInteger)startIndex photoBrowserView:(LYPhotoBrowserView *)photoBrowserView;

// 单击了视图
- (void)didSingleTapPhotoBrowserView:(LYPhotoBrowserView *)browserView;

// 即将展示的视图索引
- (void)photoBrowserView:(LYPhotoBrowserView *)photoBrowserView willShowIndex:(NSInteger)index;

// 已近展示了第几张图
- (void)photoBrowserView:(LYPhotoBrowserView *)photoBrowserView didShowIndex:(NSInteger)index;
@end
