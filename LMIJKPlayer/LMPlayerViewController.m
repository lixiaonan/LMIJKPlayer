
//
//  LMPlayerViewController.m
//  LMIJKPlayer
//
//  Created by 李小南 on 2017/4/6.
//  Copyright © 2017年 LMIJKPlayer. All rights reserved.
//

#import "LMPlayerViewController.h"
#import "LMPlayer.h"
#import <Masonry.h>

@interface LMPlayerViewController ()<LMVideoPlayerDelegate>
/** 状态栏的背景 */
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) LMVideoPlayer *player;
@property (nonatomic, strong) UIView *playerFatherView;
@property (nonatomic, strong) LMPlayerModel *playerModel;

/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
/** 离开页面时候是否开始过播放 */
@property (nonatomic, assign) BOOL isStartPlay;


/** 新视频按钮 */
@property (nonatomic, strong) UIButton *nextVideoBtn;
/** 下一页 */
@property (nonatomic, strong) UIButton *nextPageBtn;
@end

@implementation LMPlayerViewController

- (void)dealloc {
    NSLog(@"---------------dealloc------------------");
    [self.player destroyVideo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.isStartPlay = NO;
    
    [self.view addSubview:self.nextVideoBtn];
    [self.view addSubview:self.nextPageBtn];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.playerFatherView];
    
    [self makePlayViewConstraints];
    
    LMPlayerModel *model = [[LMPlayerModel alloc] init];
    model.videoURL = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1456734464766B(13).mp4"];
    
    LMVideoPlayer *player = [LMVideoPlayer videoPlayerWithView:self.playerFatherView delegate:self playerModel:model];
    self.player = player;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    // pop回来时候是否自动播放
    if (self.player && self.isPlaying) {
        self.isPlaying = NO;
        [self.player playVideo];
    }
    LMBrightnessViewShared.isStartPlay = self.isStartPlay;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    // push出下一级页面时候暂停
    if (self.player && !self.player.isPauseByUser) {
        self.isPlaying = YES;
        [self.player pauseVideo];
    }
    
    LMBrightnessViewShared.isStartPlay = NO;
}


- (void)nextVideoBtnClick {
    if (self.isStartPlay) {
        LMPlayerModel *model = [[LMPlayerModel alloc] init];
        model.videoURL = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1456231710844S(24).mp4"];
        [self.player resetToPlayNewVideo:model];
    }
}

- (void)nextPageBtnClick {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor purpleColor];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 添加子控件的约束
- (void)makePlayViewConstraints {
    
    if (IS_IPHONE_4) {
        [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.leading.trailing.mas_equalTo(0);
            // 这里宽高比16：9,可自定义宽高比
            make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(2.0f/3.0f);
        }];
    } else {
        [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.leading.trailing.mas_equalTo(0);
            // 这里宽高比16：9,可自定义宽高比
            make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
        }];
    }
    
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_offset(20);
    }];
    
    [self.nextVideoBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-130);
        make.height.mas_offset(30);
        make.width.mas_offset(150);
    }];
    
    [self.nextPageBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-80);
        make.height.mas_offset(30);
        make.width.mas_offset(150);
    }];
}

#pragma mark - 屏幕旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        [self.playerFatherView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(20);
        }];
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        [self.playerFatherView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
        }];
    }
}

#pragma mark - LMVideoPlayerDelegate
/** 返回按钮被点击 */
- (void)playerBackButtonClick {
    [self.player destroyVideo];
    [self.navigationController popViewControllerAnimated:YES];
}

/** 控制层封面点击事件的回调 */
- (void)controlViewTapAction {
    if (_player) {
        [self.player autoPlayTheVideo];
        self.isStartPlay = YES;
    }
}


#pragma mark - getter
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor blackColor];
    }
    return _topView;
}

- (UIView *)playerFatherView {
    if (!_playerFatherView) {
        _playerFatherView = [[UIView alloc] init];
    }
    return _playerFatherView;
}

- (LMPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel = [[LMPlayerModel alloc] init];
    }
    return _playerModel;
}

- (UIButton *)nextVideoBtn {
    if (!_nextVideoBtn) {
        _nextVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextVideoBtn setTitle:@"当前页播放新视频" forState:UIControlStateNormal];
        _nextVideoBtn.backgroundColor = [UIColor redColor];
        [_nextVideoBtn addTarget:self action:@selector(nextVideoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextVideoBtn;
}

- (UIButton *)nextPageBtn {
    if (!_nextPageBtn) {
        _nextPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextPageBtn setTitle:@"下一页" forState:UIControlStateNormal];
        _nextPageBtn.backgroundColor = [UIColor redColor];
        [_nextPageBtn addTarget:self action:@selector(nextPageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextPageBtn;
}

@end
