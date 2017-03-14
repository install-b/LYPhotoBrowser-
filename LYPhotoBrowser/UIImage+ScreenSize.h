//
//  UIImage+ScreenSize.h
//  TaiYangHua
//
//  Created by admin on 16/12/22.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ScreenSize)
// 沾满屏幕宽度后尺寸位置
-  (CGRect)getImageScreenFrame;

// 沾满屏幕宽度后尺寸
-  (CGSize)getImageScreenSize;
@end
