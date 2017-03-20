//
//  LYPhotoBrowserView.m
//  TaiYangHua
//
//  Created by shangen on 17/3/11.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import "LYPhotoBrowserView.h"
#import "Masonry/Masonry.h"
#import "SGInfiniteView/SGInfiniteView.h"
#import "LYPhotoCell.h"

@interface LYPhotoBrowserView ()<SGInfiniteViewDelegte,SGInfiniteViewDatasource,LYPhotoCellDelegate>
/** 滚动视图 */
@property(nonatomic,weak) SGInfiniteView *infiniteView;
/** 索引标签 */
@property(nonatomic,weak) UILabel *indexLable;
/** 当前显示的图片的索引 */
@property(nonatomic,assign) NSInteger currentIndex;
@end

static NSString *ID = @"InfiniteView_picture_cell_reuseId";

@implementation LYPhotoBrowserView
#pragma mark - init setUp
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpSubview];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpSubview];
}
#pragma mark - SGInfiniteViewDatasource
/** 要循环的view的个数 */
- (NSInteger)numberOfItemsForInfiniteSlideView:(SGInfiniteView *)infiniteView {
    return [self.delegate numberOfItemsForInfiniteSlideView:self];
}

/** 根据所给的索引值 返回要展示的view（不用设置，自动设置为控件的大小） */
- (UIView *)viewForInfiniteSlideView:(SGInfiniteView *)infiniteView inIndex:(NSInteger)index {
    LYPhotoCell *cell = (LYPhotoCell *)[infiniteView sg_dequeueReusableCellWithReuseIdentifier:ID]; // 重用cell
    cell.delegate = self;
    cell.cellIndex = index;
    cell.imagePath =  [self.delegate imageURLForPhotoBrowserView:self inIndex:index];// 传递模型
    return cell;
}
#pragma mark - SGInfiniteViewDelegte
/** 将要展示了第index 视图 */
- (void)viewForInfiniteView:(SGInfiniteView *)infiniteView willShowIndex:(NSInteger)index {
    // 实时更新索引值
    self.currentIndex = index;
}
#pragma mark - LYPhotoCellDelegate
- (void)photoCell:(LYPhotoCell *)cell didLoadImage:(UIImage *)image {
    if ([self.delegate respondsToSelector:@selector(didLoadStartImageIndex:photoBrowserView:)]) {
        [self.delegate didLoadStartImageIndex:cell.cellIndex photoBrowserView:self];
    }
}

#pragma mark - clisk events
// 保存图片
- (void)clickSaveButton:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(photoBrowserView:saveImage:)]) {
        UIImage *image = [(LYPhotoCell *)[self.infiniteView currentVisiableView] imageView].image;
        [self.delegate photoBrowserView:self saveImage:image];
    }
}
#pragma mark - setter
// 更新索引
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    _indexLable.text = [NSString stringWithFormat:@"%zd/%zd", currentIndex + 1,[self.delegate numberOfItemsForInfiniteSlideView:self]];
}

#pragma mark - public mothoeds
// 跳转到指定的位置
- (void)scrollToIndexItem:(NSUInteger)index {
    [self.infiniteView scrollToIndexItem:index];
}
// 设置一个位置的图片
- (void)setInitalIndex:(NSUInteger)initalIndex {
    [self.infiniteView scrollToIndexItem:initalIndex anima:NO];
    [self.infiniteView sg_reloadData];
    self.currentIndex = initalIndex;
}
- (void)setInfifiteCycleEnable:(BOOL)enable {
    [self.infiniteView setInfinite:enable];
}
#pragma mark - add subviews
- (void)setUpSubview {
    self.backgroundColor = [UIColor blackColor];
    // 浏览图片视图
    SGInfiniteView *infiniteView = [[SGInfiniteView alloc] init];
    //[infiniteView setInfinite:NO];
    [self addSubview:infiniteView];
    self.infiniteView = infiniteView;
    infiniteView.dataSource = self;     // 设置数据源
    infiniteView.delegate = self;       // 设置代理
    [infiniteView setPageMargin:10.0f]; // 设置分边距
    // 注册cell
    [infiniteView sg_registerClass:[LYPhotoCell class] forCellWithReuseIdentifier:ID];
    
    // 索引标签
    UILabel *indexLable = [[UILabel alloc] init];
    self.indexLable = indexLable;
    [self addSubview:indexLable];
    indexLable.textColor = [UIColor whiteColor];
    indexLable.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    indexLable.layer.cornerRadius = 5;
    indexLable.layer.masksToBounds = YES;
    indexLable.textAlignment = NSTextAlignmentCenter;
    //self.currentIndex = _currentIndex; // 设置文字
    
    // 保存按钮
    UIButton *saveButton = [[UIButton alloc] init];
    //self.saveBotton = saveButton;
    [self addSubview:saveButton];
    saveButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    saveButton.layer.cornerRadius = 5;
    saveButton.layer.masksToBounds = YES;
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(clickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // 布局设置约束
    __weak typeof(self) weakSelf = self;
    [infiniteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf);
    }];
    
    [indexLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(-20);
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

@end
