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

@interface TBZAVPlayerView()<TBZAVPlayerControlViewDelegate>
@property (nonatomic, strong) AVPlayer *player;//播放器
@property (nonatomic, strong) AVPlayerItem *playerItem;//播放单元
@property (nonatomic, strong) AVPlayerLayer *playerLayer;//播放界面

@property (nonatomic, strong) TBZAVPlayerControlView *controlView;
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
    
    [self destroy];
    
    self.playerItem = [AVPlayerItem playerItemWithURL:[[NSURL alloc] initFileURLWithPath:playerModel.playLink]];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*0.6);
    [self.layer addSublayer:self.playerLayer];
    
    //添加监听
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    //将控制视图移到最上方
    [self bringSubviewToFront:self.controlView];
    
    [self.player play];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] intValue];
        [self.controlView controlItemStatus:status];
    }
}

- (void)destroy{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    if (self.player || self.playerItem || self.playerLayer) {
        [self.player pause];
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        self.playerItem = nil;
        self.player = nil;
        [self.playerLayer removeFromSuperlayer];
    }
}

- (void)enterFull{
    self.playerLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

- (void)exitFull{
    self.playerLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*0.6);
}

- (BOOL)playPauseBtnClick{
    if ([self.player rate] > 0) {
        [self.player pause];
        return NO;
    }else{
        [self.player play];
        return YES;
    }
}

- (BOOL)fullBtnAction:(BOOL)isFull{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(fullBtnAction:)]) {
        return [self.delegate fullBtnAction:isFull];
    }else{
        return isFull;
    }
}

@end
