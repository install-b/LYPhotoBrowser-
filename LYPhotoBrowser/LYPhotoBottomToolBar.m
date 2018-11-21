//
//  LYPhotoBottomToolBar.m
//  LYPhotoBrowserDemo
//
//  Created by Shangen Zhang on 2017/4/16.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import "LYPhotoBottomToolBar.h"
#import "Masonry.h"


@interface LYPhotoBottomToolBar ()
/** save button */
@property (nonatomic,weak) UIButton *saveButton ;

/** 索引标签 */
@property(nonatomic,weak) UILabel *indexLable;

@end
@implementation LYPhotoBottomToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setSubViews];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSubViews];
}

- (void)setSubViews {
     __weak typeof(self) weakSelf = self;
    // 索引标签
    UILabel *indexLable = [[UILabel alloc] init];
    self.indexLable = indexLable;
    [self addSubview:indexLable];
    indexLable.textColor = [UIColor whiteColor];
    indexLable.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    indexLable.layer.cornerRadius = 5;
    indexLable.layer.masksToBounds = YES;
    indexLable.textAlignment = NSTextAlignmentCenter;
    
    // 保存按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [self addSubview:saveButton];
    saveButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    saveButton.layer.cornerRadius = 5;
    saveButton.layer.masksToBounds = YES;
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveButton = saveButton;
    
    [indexLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.width.equalTo(@(49));
    }];
    
    [saveButton sizeToFit];
    CGFloat width = saveButton.bounds.size.width + 20 ;
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-20);
        make.centerY.equalTo(indexLable);
        make.width.equalTo(@(width));
    }];

}

- (void)saveButtonAddTarget:(id _Nonnull )target action:(nonnull SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self.saveButton addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setCurrentIndex:(NSInteger)currentIndex totalItemsCount:(NSInteger)totalCount {
    _indexLable.text = [NSString stringWithFormat:@"%d/%d", (int)(currentIndex + 1),(int)totalCount];
}
@end
