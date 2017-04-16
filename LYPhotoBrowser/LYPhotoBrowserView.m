//
//  LYPhotoBrowserView.m
//  TaiYangHua
//
//  Created by shangen on 17/3/11.
//  Copyright © 2017年 hhly. All rights reserved.
//

#import "LYPhotoBrowserView.h"
#import "Masonry.h"
#import "SGInfiniteView/SGInfiniteView.h"
#import "LYPhotoCell.h"

@interface LYPhotoBrowserView ()<SGInfiniteViewDelegte,SGInfiniteViewDatasource,LYPhotoCellDelegate>
/** 滚动视图 */
@property(nonatomic,weak) SGInfiniteView *infiniteView;

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

- (UIImageView *)currentImageView {
    return [(LYPhotoCell *)self.infiniteView.currentVisiableView imageView];
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
    [self.delegate photoBrowserView:self willShowIndex:index];
}
/** 已经展示了第index 视图 */
- (void)viewForInfiniteView:(SGInfiniteView *)infiniteView didShowIndex:(NSInteger)index{
    [self.delegate photoBrowserView:self didShowIndex:index];
}
#pragma mark - LYPhotoCellDelegate
- (void)didSingleTapPhotoCell:(LYPhotoCell *)cell {
    if ([self.delegate respondsToSelector:@selector(didSingleTapPhotoBrowserView:)]) {
        [self.delegate didSingleTapPhotoBrowserView:self];
    }
}
// 图片下载的进度progress
- (void)photoCell:(LYPhotoCell *)cell loadImageProgress:(CGFloat)progress {
    // code here do something when image downloading
}
// 图片下载完成
- (void)photoCell:(LYPhotoCell *)cell didLoadImage:(UIImage *)image {
    if ([self.delegate respondsToSelector:@selector(didLoadStartImageIndex:photoBrowserView:)]) {
        [self.delegate didLoadStartImageIndex:cell.cellIndex photoBrowserView:self];
    }
}
#pragma mark set infiniteview roll enbale
- (void)photoCell:(LYPhotoCell *)cell beginZoomingScrollView:(UIScrollView *)scrollView {
    [self.infiniteView setScrollEnable:NO];
}

- (void)photoCell:(LYPhotoCell *)cell endZoomingScrollView:(UIScrollView *)scrollView {
    if (scrollView.zoomScale == 1.0f) {
        [self.infiniteView setScrollEnable:YES];
    }
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
}
- (void)setInfifiteCycleEnable:(BOOL)enable {
    [self.infiniteView setInfinite:enable];
}
#pragma mark - add subviews
- (void)setUpSubview {
    self.backgroundColor = [UIColor blackColor];
    // 浏览图片视图
    SGInfiniteView *infiniteView = [[SGInfiniteView alloc] init];
    [self addSubview:infiniteView];
    self.infiniteView = infiniteView;
    infiniteView.dataSource = self;     // 设置数据源
    infiniteView.delegate = self;       // 设置代理
    [infiniteView setPageMargin:10.0f]; // 设置分边距
    // 注册cell
    [infiniteView sg_registerClass:[LYPhotoCell class] forCellWithReuseIdentifier:ID];
    
    // 布局设置约束
    __weak typeof(self) weakSelf = self;
    [infiniteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf);
    }];
    
}

@end
