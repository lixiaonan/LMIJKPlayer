//
//  LMMainTabBarController.m
//  LMIJKPlayer
//
//  Created by 李小南 on 2017/4/6.
//  Copyright © 2017年 LMIJKPlayer. All rights reserved.
//

#import "LMMainTabBarController.h"
#import "LMPlayer.h"
#import "LMPlayerViewController.h"
#import "LMMainNavController.h"
#import "LMVC1ViewController.h"

@interface LMMainTabBarController ()

@end

@implementation LMMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LMVC1ViewController *vc1 = [[LMVC1ViewController alloc] init];
    [self addChileVcWithTitle:@"动态" vc:vc1 imageName:@"btn_动态" selImageName:@"btn_动态选中"];
    
    
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.view.backgroundColor = [UIColor purpleColor];
    [self addChileVcWithTitle:@"首页" vc:vc2 imageName:@"btn_首页" selImageName:@"btn_首页选中"];
    
    self.selectedIndex = 0;
}

- (void)addChileVcWithTitle:(NSString *)title vc:(UIViewController *)vc imageName:(NSString *)imageName selImageName:(NSString *)selImageName {
    [vc.tabBarItem setTitle:title];
    [vc.tabBarItem setImage:[UIImage imageNamed:imageName]];
    [vc.tabBarItem setSelectedImage:[self imageWithOriginalRenderingMode:selImageName]];
    LMMainNavController *navVc = [[LMMainNavController alloc] initWithRootViewController:vc];
    [self addChildViewController:navVc];
}

/**
 *  加载不要被渲染的图片
 *
 *  @param imageName 图片名
 *
 *  @return 受保护的图片
 */
- (UIImage *)imageWithOriginalRenderingMode:(NSString *)imageName {
    
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

#pragma mark - 控制转屏
// 哪些页面支持自动转屏
- (BOOL)shouldAutorotate {
    
    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    
    // LMPlayViewController 控制器支持自动转屏
    if ([nav.topViewController isKindOfClass:[LMPlayerViewController class]]) {
        // 调用LMBrightnessViewShared单例记录播放状态是否锁定屏幕方向
        return !LMBrightnessViewShared.isLockScreen; // 未来功能
    }
    return NO;
}

// viewcontroller支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    if ([nav.topViewController isKindOfClass:[LMPlayerViewController class]]) { // LMPlayViewController这个页面支持转屏方向
        if (LMBrightnessViewShared.isStartPlay) {
            return UIInterfaceOrientationMaskAllButUpsideDown;
        } else {
            return UIInterfaceOrientationMaskPortrait;
        }
        
    }
    // 其他页面
    return UIInterfaceOrientationMaskPortrait;
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
