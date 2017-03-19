//
//  UIImage+ScreenSize.h
//  TaiYangHua
//
//  Created by admin on 16/12/22.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface UIImage (ScreenSize)
// 沾满屏幕宽度后尺寸位置
-  (CGRect)getImageScreenFrame;

// 沾满屏幕宽度后尺寸
-  (CGSize)getImageScreenSize;
@end
