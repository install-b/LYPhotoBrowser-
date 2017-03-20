//
//  UIImage+ScreenSize.m
//  TaiYangHua
//
//  Created by admin on 16/12/22.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "UIImage+ScreenSize.h"

@implementation UIImage (ScreenSize)

-  (CGRect)getImageScreenFrame {
    
    CGSize size = self.size;
    CGFloat W = SCREEN_W;
    CGFloat H = W * size.height / size.width;
    CGFloat X = 0;
    CGFloat Y = (SCREEN_H - H) * 0.5;
    if (Y < 0) Y = 0;
    
    return CGRectMake(X, Y, W, H);
}

-  (CGSize)getImageScreenSize {
    return [self getImageScreenFrame].size;
}

@end
