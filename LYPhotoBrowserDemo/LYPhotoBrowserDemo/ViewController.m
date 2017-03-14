//
//  ViewController.m
//  LYPhotoBrowserDemo
//
//  Created by shangen on 17/3/11.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LYPhotoBrowserViewController.h"
@interface ViewController () <LYPhotoBrowserViewControllerDelegate>
/** imageView */
@property (nonatomic,weak) UIImageView *imageView;
@end
#define starIndex 3

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:imageView];
    imageView.center = self.view.center;
    imageView.backgroundColor = [UIColor redColor];
    // 设置图片
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataSource[starIndex]]  placeholderImage:nil options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
    }];
    self.imageView = imageView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 照片浏览器
    LYPhotoBrowserViewController *pbVc = [[LYPhotoBrowserViewController alloc] init];
    
    pbVc.imagePaths = self.dataSource;
    pbVc.delegate = self;
    UIImageView *imageView = self.imageView;
    
    [pbVc presentedWithView:imageView imageIndex:starIndex];
}
    
    
- (void)photoBrowserViewController:(LYPhotoBrowserViewController *)PhotoBrowserVc didSaveImage:(UIImage *)image withError:(NSError *)error {
    
    error ? NSLog(@"保存失败-----") : NSLog(@"保存成功-----");
//    if (error) {
//        // 保存失败弹框
//        NSLog(@"保存成功-----");
//    }else {
//        // 保存成功弹框
//        
//    }
    
}
- (NSArray *)dataSource {
    
    return @[
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1489320830007&di=17e8f2cccbde5aec773d738069d2a367&imgtype=0&src=http%3A%2F%2Ffile27.mafengwo.net%2FM00%2FB2%2F12%2FwKgB6lO0ahWAMhL8AAV1yBFJDJw20.jpeg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1489320830459&di=790991b97b49dbb0813fe385848352a9&imgtype=0&src=http%3A%2F%2Fs3.lvjs.com.cn%2Ftrip%2Foriginal%2F20140818131550_1792868513.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1489320830459&di=9ad582bb5d176fda622719b2235f5a59&imgtype=0&src=http%3A%2F%2Fexp.cdn-hotels.com%2Fhotels%2F4000000%2F3900000%2F3893200%2F3893187%2F3893187_25_y.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1489320830459&di=bf5287c09eace7086e259a5d49c1584e&imgtype=0&src=http%3A%2F%2Fs3.lvjs.com.cn%2Ftrip%2Foriginal%2F20140818131519_1500748202.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1489320830459&di=f654fd2112b288e0af9cff8449118c0f&imgtype=0&src=http%3A%2F%2Ffile25.mafengwo.net%2FM00%2F0A%2FAC%2FwKgB4lMC26CAWsKoAALb5778DWg60.rbook_comment.w1024.jpeg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1489320830459&di=fde10f666163397cdd0c0c6534f661c0&imgtype=0&src=http%3A%2F%2Fmedia-cdn.tripadvisor.com%2Fmedia%2Fphoto-s%2F02%2Fe1%2F79%2Fd3%2Fpension-tupuna.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1489320830459&di=28272d6712dd880f8f7ac19aab40de07&imgtype=0&src=http%3A%2F%2Fb3-q.mafengwo.net%2Fs10%2FM00%2F44%2F54%2FwKgBZ1h7JMaAc8PeAAFC76SybfM74.jpeg%3FimageView2%2F2%2Fw%2F600%2Fh%2F600%2Fq%2F90",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1489320830458&di=28b15b65dca8b1e75d76a3830dee6c1f&imgtype=0&src=http%3A%2F%2Fi2.hdslb.com%2Fvideo%2Fcf%2Fcff97285a56736d2f30dc64b6c02f88a.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1489320830458&di=db01318f15f598452d3972c9679d481c&imgtype=0&src=http%3A%2F%2Fimg.blog.163.com%2Fphoto%2FpApeVTVVgnoLF-NkyAKI7w%3D%3D%2F5401223328101533813.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1489320830457&di=afcd9113ff1c08c8e9a3bfe02de39f32&imgtype=0&src=http%3A%2F%2Fimg157.ph.126.net%2FGWifUpASa8sjBaUJPWCp_g%3D%3D%2F1471551178244630614.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1489320830457&di=090a5df4b79f154ccb17289258ecb003&imgtype=0&src=http%3A%2F%2Fr-cc.bstatic.com%2Fimages%2Fhotel%2F840x460%2F473%2F47386232.jpg",
             ];
    
}

@end
