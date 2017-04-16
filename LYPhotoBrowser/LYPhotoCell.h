//
//  LYPhotoCell.h
//  TaiYangHua
//
//  Created by admin on 16/12/15.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "SGInfiniteView/SGInfiniteViewCell.h"

@protocol LYPhotoCellDelegate;

#pragma mark - LYPhotoCell
@interface LYPhotoCell : SGInfiniteViewCell

/** url */
@property(nonatomic,copy) NSString *imagePath;

/** imageView */
@property(nonatomic,weak) UIImageView *imageView;

/** cell的排序 */
@property (nonatomic,assign) NSInteger cellIndex;

/** delegate */
@property (nonatomic,weak) id <LYPhotoCellDelegate> delegate;

@end

/*************************************************/

@protocol LYPhotoCellDelegate <NSObject>

/**
 单击了cell

 @param cell 图片cell
 */
- (void)didSingleTapPhotoCell:(LYPhotoCell *)cell;

/**
 cell 加载图片的进度
 
 @param cell 浏览cell
 @param progress 图片下载的进度
 */
- (void)photoCell:(LYPhotoCell *)cell loadImageProgress:(CGFloat)progress;

/**
 cell 加载完成图片回调
 
 @param cell 浏览cell
 @param image 加载完成的图片
 */
- (void)photoCell:(LYPhotoCell *)cell didLoadImage:(UIImage *)image;


/**
 cell 滚动视图开始缩放
 
 @param cell 浏览cell
 @param scrollView cell滚动视图
 */
- (void)photoCell:(LYPhotoCell *)cell beginZoomingScrollView:(UIScrollView *)scrollView;


/**
 cell 滚动视图结束缩放
 
 @param cell 浏览cell
 @param scrollView cell滚动视图
 */
- (void)photoCell:(LYPhotoCell *)cell endZoomingScrollView:(UIScrollView *)scrollView;

@end
