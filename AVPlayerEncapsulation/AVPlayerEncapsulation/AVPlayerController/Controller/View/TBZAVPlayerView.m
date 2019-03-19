//
//  TBZAVPlayerView.m
//  AVPlayerEncapsulation
//
//  Created by apple on 2019/3/18.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TBZAVPlayerView.h"
#import "TBZAVPlayerModel.h"
#import "TBZAVPlayerControlView.h"
#import <Masonry/Masonry.h>
#import <AVFoundation/AVFoundation.h>

@interface TBZAVPlayerView()<TBZAVPlayerControlViewDelegate>{
    BOOL isReadyToPlay;
}
@property (nonatomic, strong) AVPlayer *player;//播放器
@property (nonatomic, strong) AVPlayerItem *playerItem;//播放单元
@property (nonatomic, strong) AVPlayerLayer *playerLayer;//播放界面

@property (nonatomic, strong) TBZAVPlayerControlView *controlView;

@property (nonatomic, strong) id timeObserver;
@end

@implementation TBZAVPlayerView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.controlView = [[TBZAVPlayerControlView alloc] init];
        self.controlView.delegate = self;
        self.controlView.topControlHeight = 30;
        self.controlView.botControlHeight = 35;
        [self addSubview:self.controlView];
        [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)parseData:(TBZAVPlayerModel *)playerModel{
    NSLog(@"%@",playerModel.title);
    
    [self.controlView parseData:playerModel];
    
    [self destroy];
    
    self.playerItem = [AVPlayerItem playerItemWithURL:[[NSURL alloc] initFileURLWithPath:playerModel.playLink]];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*0.6);
    [self.layer addSublayer:self.playerLayer];
    
    //添加监听
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    __weak AVPlayer *weakAVPlayer = self.player;
    __weak TBZAVPlayerView *weakSelf = self;
    //监听播放进度，需要再destory方法中，释放timeObserve
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, NSEC_PER_SEC) queue:NULL usingBlock:^(CMTime time) {
        CGFloat progress = CMTimeGetSeconds(weakAVPlayer.currentItem.currentTime) / CMTimeGetSeconds(weakAVPlayer.currentItem.duration);
        if (progress == 1.0f) {
            //视频播放完毕
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(playEnd)]) {
                [weakSelf.delegate playEnd];
            }
        }else{
            [weakSelf.controlView controlPlayItem:weakAVPlayer.currentItem];
        }
        NSLog(@"%f",progress);
    }];
    
    //将控制视图移到最上方
    [self bringSubviewToFront:self.controlView];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] intValue];
        if (status == AVPlayerItemStatusReadyToPlay) {
            isReadyToPlay = YES;
            [self.player play];
        }else{
            //预留
            isReadyToPlay = NO;
        }
        [self.controlView controlItemStatus:status playItem:object];
    }
}

- (void)destroy{
    if (self.player || self.playerItem || self.playerLayer) {
        [self.player pause];
        if (self.timeObserver) {
            [self.player removeTimeObserver:self.timeObserver];
        }
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        self.playerItem = nil;
        self.player = nil;
        [self.playerLayer removeFromSuperlayer];
    }
}

- (void)enterFull{
    self.playerLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.controlView.isFull = YES;
}

- (void)exitFull{
    self.playerLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*0.6);
    self.controlView.isFull = NO;
}

#pragma mark - TBZAVPlayerControlView 的delegate方法
- (BOOL)playPauseBtnClick{
    if ([self.player rate] > 0) {
        [self.player pause];
        return NO;
    }else{
        [self.player play];
        return YES;
    }
}

- (void)fullBtnAction:(BOOL)isFull{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(fullBtnAction:)]) {
        [self.delegate fullBtnAction:isFull];
    }
}

- (void)backBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnClick)]) {
        [self.delegate backBtnClick];
    }
}

- (void)sliderValueChanged:(float)second{
    CMTime startTime = CMTimeMakeWithSeconds(second, self.player.currentItem.currentTime.timescale);
    [self.player seekToTime:startTime completionHandler:^(BOOL finished) {
        if (self->isReadyToPlay) {
            [self.player play];
        }
    }];
}

@end
