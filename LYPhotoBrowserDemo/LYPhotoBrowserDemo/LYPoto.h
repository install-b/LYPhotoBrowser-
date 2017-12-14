//
//  LYPoto.h
//  LYPhotoBrowserDemo
//
//  Created by Shangen Zhang on 2017/12/14.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYPhotoBrowserViewController.h"

@interface LYPoto : NSObject <LYPhotoDataSourceProtocol>
/**  */
@property (nonatomic,copy)NSString * localPath;

/**  */
@property (nonatomic,copy)NSString * url;

+ (NSArray <LYPhotoDataSourceProtocol>*)potoFromImageURLs:(NSArray <NSString *>*)urls;
@end
