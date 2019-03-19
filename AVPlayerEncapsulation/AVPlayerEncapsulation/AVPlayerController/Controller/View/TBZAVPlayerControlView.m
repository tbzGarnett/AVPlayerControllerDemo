//
//  TBZAVPlayerControlView.m
//  AVPlayerEncapsulation
//
//  Created by apple on 2019/3/18.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TBZAVPlayerControlView.h"
#import "TBZAVPlayerModel.h"
#import <Masonry/Masonry.h>

@interface TBZAVPlayerControlView(){
    BOOL isShow;
    
    BOOL isReadToPlay;
}

@property (nonatomic, strong) UIView *topControlView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIView *botControlView;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UIButton *fullBtn;

@end

@implementation TBZAVPlayerControlView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI{
    [self addSubview:self.topControlView];
    [self.topControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_offset(25);
    }];
    [self.topControlView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.topControlView);
        make.centerX.mas_equalTo(self.topControlView);
        make.left.mas_equalTo(self.topControlView).with.offset(40);
    }];
    [self.topControlView addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topControlView).with.offset(15);
        make.centerY.mas_equalTo(self.topControlView);
        make.size.mas_offset(CGSizeMake(20, 20));
    }];
    
    [self addSubview:self.botControlView];
    [self.botControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self);
        make.height.mas_offset(25);
    }];
    [self.botControlView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.botControlView).with.offset(15);
        make.centerY.mas_equalTo(self.botControlView);
        make.size.mas_offset(CGSizeMake(18, 18));
    }];
    [self.botControlView addSubview:self.fullBtn];
    [self.fullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.botControlView).with.offset(-15);
        make.centerY.mas_equalTo(self.botControlView);
        make.size.mas_offset(CGSizeMake(18, 18));
    }];
    
    isShow = YES;
    isReadToPlay = NO;
    self.isFull = NO;
}

- (void)parseData:(TBZAVPlayerModel *)playerModel{
    self.titleLab.text = playerModel.title;
}

- (void)controlItemStatus:(AVPlayerItemStatus)status{
    switch (status) {
        case AVPlayerItemStatusFailed:
            NSLog(@"item 有误");
            isReadToPlay = NO;
            [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            break;
        case AVPlayerItemStatusReadyToPlay:
            NSLog(@"准好播放了");
            isReadToPlay = YES;
            [_playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
//            self.avSlider.maximumValue = self.item.duration.value / self.item.duration.timescale;
            break;
        case AVPlayerItemStatusUnknown:
            NSLog(@"视频资源出现未知错误");
            isReadToPlay = NO;
            [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)playPauseClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playPauseBtnClick)]) {
        BOOL isPlay = [self.delegate playPauseBtnClick];
        if (isPlay) {
            [_playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        }else{
            [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        }
    }
}

- (void)fullAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fullBtnAction:)]) {
        [self.delegate fullBtnAction:_isFull];
    }
}

- (void)backAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnClick)]) {
        [self.delegate backBtnClick];
    }
}





- (UIView *)topControlView{
    if (!_topControlView) {
        _topControlView = [[UIView alloc] init];
        _topControlView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _topControlView;
}

- (UIView *)botControlView{
    if (!_botControlView) {
        _botControlView = [[UIView alloc] init];
        _botControlView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _botControlView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:16.f];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn addTarget:self action:@selector(playPauseClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)fullBtn{
    if (!_fullBtn) {
        _fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullBtn addTarget:self action:@selector(fullAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullBtn;
}

- (void)setTopControlHeight:(CGFloat)topControlHeight{
    _topControlHeight = topControlHeight;
    
    [self.topControlView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(topControlHeight);
    }];
}

- (void)setBotControlHeight:(CGFloat)botControlHeight{
    _botControlHeight = botControlHeight;
    
    [self.botControlView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(botControlHeight);
    }];
}

- (void)setIsFull:(BOOL)isFull{
    _isFull = isFull;
    if (isFull) {
        [_fullBtn setImage:[UIImage imageNamed:@"min"] forState:UIControlStateNormal];
    }else{
        [_fullBtn setImage:[UIImage imageNamed:@"full"] forState:UIControlStateNormal];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan");
    
    if (isShow) {
        [UIView animateWithDuration:0.5 animations:^{
            self.topControlView.alpha = 0;
            self.botControlView.alpha = 0;
        } completion:^(BOOL finished) {
            self->isShow = !self->isShow;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.topControlView.alpha = 1;
            self.botControlView.alpha = 1;
        } completion:^(BOOL finished) {
            self->isShow = !self->isShow;
        }];
    }
}

@end
