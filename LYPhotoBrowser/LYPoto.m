//
//  LYPoto.m
//  LYPhotoBrowserDemo
//
//  Created by Shangen Zhang on 2017/12/14.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import "LYPoto.h"

@implementation LYPoto

+ (NSArray <LYPoto *>*)potoFromImageURLs:(NSArray <NSString *>*)urls {
//    if (![urls isKindOfClass:NSArray.class]) {
//        return nil;
//    }
//
//    if (urls.count == 0) {
//        return @[];
//    }
//    NSMutableArray *tempArrayM = [NSMutableArray arrayWithCapacity:urls.count];
//    [urls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        LYPoto *poto = [[self alloc] init];
//        poto.url = obj;
//        [tempArrayM addObject:poto];
//    }];
//    return [NSArray arrayWithArray:tempArrayM];
    return [self potoFromImageURLs:urls placeHolder:nil];
}
+ (NSArray <LYPoto *>*)potoFromImageURLs:(NSArray <NSString *>*)urls placeHolder:(UIImage *)placeHolder{
    if (![urls isKindOfClass:NSArray.class]) {
        return nil;
    }
    
    if (urls.count == 0) {
        return @[];
    }
    NSMutableArray *tempArrayM = [NSMutableArray arrayWithCapacity:urls.count];
    [urls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LYPoto *poto = [[self alloc] init];
        poto.url = obj;
        poto.placeHolderImage = placeHolder;
        [tempArrayM addObject:poto];
    }];
    return [NSArray arrayWithArray:tempArrayM];
}

/**
 展示的图片来源为内存
 优先展示此图片
 可以为空
 */
- (UIImage *)ly_image {
    return nil;
}

/**
 加载的图片为网络图片时 的占位图
 */
- (UIImage *)ly_placeholderImage {
    return self.placeHolderImage;
}

/**
 展示的图片来源为本地磁盘
 当‘- ly_image’方法返回空时候 会调用该方法
 也可以为空
 */
- (NSString *)ly_imageLocalPath {
    return self.localPath;
}


/**
 展示的图片来源为网络
 当 内存图片和本地资源都返回空时  调用
 不能为空
 */
- (NSString *)ly_imageURL {
    return self.url;
}


@end
