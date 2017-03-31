//
//  LYPhotoCell.h
//  TaiYangHua
//
//  Created by admin on 16/12/15.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "SGInfiniteView/SGInfiniteViewCell.h"


@class LYPhotoCell;
@protocol LYPhotoCellDelegate <NSObject>

- (void)photoCell:(LYPhotoCell *)cell didLoadImage:(UIImage *)image;

- (void)photoCell:(LYPhotoCell *)cell beginZoomingScrollView:(UIScrollView *)scrollView;

- (void)photoCell:(LYPhotoCell *)cell endZoomingScrollView:(UIScrollView *)scrollView;

@end

@interface LYPhotoCell : SGInfiniteViewCell

/** url */
@property(nonatomic,copy) NSString *imagePath;

/** imageView */
@property(nonatomic,weak) UIImageView *imageView;

/** 图片下载进度监听 */
@property(nonatomic,copy) void(^progress)(CGFloat progress);

/** cell的排序 */
@property (nonatomic,assign) NSInteger cellIndex;

/** delegate */
@property (nonatomic,weak) id <LYPhotoCellDelegate> delegate;

@end
