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

- (NSInteger)numberOfItemsForInfiniteSlideView:(LYPhotoBrowserView *)photoBrowserView;

- (NSString *)imageURLForPhotoBrowserView:(LYPhotoBrowserView *)photoBrowserView inIndex:(NSInteger)index;

- (void)didLoadStartImageIndex:(NSInteger)startIndex photoBrowserView:(LYPhotoBrowserView *)photoBrowserView;

@optional
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
 <#Description#>

 @param initalIndex <#initalIndex description#>
 @param complete <#complete description#>
 */
- (void)setInitalIndex:(NSUInteger)initalIndex compelete:(void(^)())complete;
@end
