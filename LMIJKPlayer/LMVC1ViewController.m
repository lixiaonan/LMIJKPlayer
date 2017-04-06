//
//  LMVC1ViewController.m
//  LMIJKPlayer
//
//  Created by 李小南 on 2017/4/6.
//  Copyright © 2017年 LMIJKPlayer. All rights reserved.
//

#import "LMVC1ViewController.h"
#import "LMPlayerViewController.h"

@interface LMVC1ViewController ()

@end

@implementation LMVC1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"进入视频播放页" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    btn.frame = CGRectMake(100, 150, 180, 30);
    [btn addTarget:self action:@selector(goPlayerView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)goPlayerView {
    LMPlayerViewController *playerVC = [[LMPlayerViewController alloc] init];
    [self.navigationController pushViewController:playerVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
