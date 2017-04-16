//
//  LYPhotoBottomToolBar.h
//  LYPhotoBrowserDemo
//
//  Created by Shangen Zhang on 2017/4/16.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYPhotoBottomToolBar : UIView

- (void)saveButtonAddTarget:(id _Nonnull )target action:(nonnull SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)setCurrentIndex:(NSInteger)currentIndex totalItemsCount:(NSInteger)totalCount;

@end
