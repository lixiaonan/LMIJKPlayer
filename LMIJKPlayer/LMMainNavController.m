
//
//  LMMainNavController.m
//  LMIJKPlayer
//
//  Created by 李小南 on 2017/4/6.
//  Copyright © 2017年 LMIJKPlayer. All rights reserved.
//

#import "LMMainNavController.h"
#import "LMPlayerViewController.h"
#import "LMPlayer.h"

@interface LMMainNavController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic ,strong) id popDelegate;
@end

@implementation LMMainNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    
    // 设置导航控制器的代理
    self.delegate = self;
    
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if(self.childViewControllers.count == 1) { // 根控制器
        // 如果是根控制器,设回手势代理
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    }
    
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count != 0) { // 非根控制器
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:0 target:self action:@selector(back)];
        
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

#pragma mark - orientation
#pragma mark - 控制转屏
// 哪些页面支持自动转屏
- (BOOL)shouldAutorotate{
    
    // LMPlayViewController 控制器支持自动转屏
    if ([self.topViewController isKindOfClass:[LMPlayerViewController class]]) {
        // 调用LMBrightnessViewShared单例记录播放状态是否锁定屏幕方向
        return !LMBrightnessViewShared.isLockScreen; // 未来功能
    }
    return NO;
}

// viewcontroller支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if ([self.topViewController isKindOfClass:[LMPlayerViewController class]]) { // LMPlayViewController这个页面支持转屏方向
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
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
