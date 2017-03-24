//
//  LYPhotoImageView.h
//  LYPhotoBrowserDemo
//
//  Created by Shangen Zhang on 17/3/19.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYPhotoImageView;
@protocol LYPhotoImageViewDelegate <NSObject>

- (void)photoImageView:(LYPhotoImageView *)photoImageView willTransferToSize:(CGSize)tranferSize locationPoint:(CGPoint)locationPoint;

- (void)photoImageView:(LYPhotoImageView *)photoImageView needTransferToSize:(CGSize)tranferSize locationPoint:(CGPoint)locationPoint;

@end

@interface LYPhotoImageView : UIImageView

/**  delegate */
@property(nonatomic,weak) id<LYPhotoImageViewDelegate> delegate;

@end
