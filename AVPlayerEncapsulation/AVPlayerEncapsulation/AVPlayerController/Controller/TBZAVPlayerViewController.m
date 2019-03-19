//
//  TBZAVPlayerViewController.m
//  AVPlayerEncapsulation
//
//  Created by apple on 2019/3/18.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TBZAVPlayerViewController.h"
#import "TBZAVPresent.h"
#import "TBZAVPlayerView.h"
#import "TBZAVFullViewController.h"
#import <Masonry/Masonry.h>

#define iPhoneX ([[UIScreen mainScreen] bounds].size.width == 375.f && [[UIScreen mainScreen] bounds].size.height == 812.f ? YES : NO)
#define StatusBarAndNavigationBarHeight (iPhoneX ? 44.f : 20.f)

@interface TBZAVPlayerViewController ()<TBZAVPlayerViewDelegate>{
    CGRect playViewBeforeRect;
    CGPoint playViewBeforeCenter;
    
    BOOL isFull;
}
@property (nonatomic, strong) TBZAVPresent *avPresent;
@property (nonatomic, copy) ChooseBlock block;

@property (nonatomic, strong) TBZAVFullViewController *fullVC;
//@property (nonatomic, strong) UIView *contentView;
@end

@implementation TBZAVPlayerViewController

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.playerView destroy];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.playerView];
    [self loadUI];
    [self.avPresent addView:self];
    
    isFull = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)loadUI{
    CGFloat width = 30;
    for (int i = 0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor purpleColor];
        btn.tag = 100+i;
        btn.frame = CGRectMake(20+i*(width + 10), self.playerView.frame.origin.y+self.playerView.frame.size.height + 15, width, width);
        [btn addTarget:self action:@selector(chooseEpisode:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)chooseEpisode:(UIButton *)sender{
    if (self.block) {
        self.block(sender.tag - 100);
    }
}

- (TBZAVPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [[TBZAVPlayerView alloc] init];
        _playerView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*0.6);
        _playerView.delegate = self;
        _playerView.backgroundColor = [UIColor grayColor];
    }
    return _playerView;
}

- (TBZAVPresent *)avPresent{
    if (!_avPresent) {
        _avPresent = [TBZAVPresent new];
    }
    return _avPresent;
}


- (void)btnClickMethod:(ChooseBlock)block{
    self.block = block;
}


- (void)fullBtnAction:(BOOL)isFull{
    if (isFull) {
        //退出全屏
        [self exitFullScreen];
    }else{
        //进入全屏
        [self enterFullScreen:NO];
    }
}

- (void)backBtnClick{
    if (isFull) {
        [self exitFullScreen];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        [self.playerView destroy];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}

- (void)enterFullScreen:(BOOL)rightOrLeft{
    playViewBeforeRect = _playerView.frame;
    playViewBeforeCenter = _playerView.center;
    
    TBZAVFullViewController *vc = [[TBZAVFullViewController alloc] init];
    vc.type = rightOrLeft;
    self.fullVC = vc;
    
    __weak TBZAVPlayerViewController *weakSelf = self;
    
    [self.navigationController presentViewController:vc animated:false completion:^{
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.playerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        } completion:^(BOOL finished) {
            [weakSelf.playerView enterFull];
            [weakSelf.fullVC.view addSubview:weakSelf.playerView];
            [UIApplication.sharedApplication.keyWindow insertSubview:UIApplication.sharedApplication.keyWindow.rootViewController.view belowSubview:vc.view.superview];
            
            self->isFull = YES;
        }];
    }];
}

- (void)exitFullScreen{
    __weak TBZAVPlayerViewController *weakSelf = self;
    [self.fullVC dismissViewControllerAnimated:false completion:^{
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.playerView.frame = self->playViewBeforeRect;
        } completion:^(BOOL finished) {
            [weakSelf.playerView exitFull];
            [weakSelf.view addSubview:weakSelf.playerView];
            
            self->isFull = NO;
        }];
    }];
}

- (void)dealloc{
    NSLog(@"dealloc");
}

- (void)deviceOrientationDidChange{
    switch (UIDevice.currentDevice.orientation) {
        case UIDeviceOrientationPortrait:
        {
            if (isFull) {
                [self exitFullScreen];
            }else{
                [self.playerView exitFull];
            }
        }
            break;
            break;
        case UIDeviceOrientationLandscapeLeft:
        {
            if (isFull) {
                
            }else{
                [self enterFullScreen:NO];
            }
        }
            break;
        case UIDeviceOrientationLandscapeRight:
        {
            if (isFull) {
                
            }else{
                [self enterFullScreen:YES];
            }
        }
            break;
        default:
            break;
    }
}

@end
