//
//  TBZAVPlayerControlView.h
//  AVPlayerEncapsulation
//
//  Created by apple on 2019/3/18.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class TBZAVPlayerModel;

@protocol TBZAVPlayerControlViewDelegate <NSObject>

- (BOOL)playPauseBtnClick;

- (void)fullBtnAction:(BOOL)isFull;

- (void)backBtnClick;

- (void)sliderValueChanged:(float)second;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TBZAVPlayerControlView : UIView

/**
 模型传递参数

 @param playerModel 播放模型
 */
- (void)parseData:(TBZAVPlayerModel *)playerModel;

/**
 处理AVPlayerItem的监听

 @param status 播放单元的状态
 @param item 播放单元
 */
- (void)controlItemStatus:(AVPlayerItemStatus)status playItem:(AVPlayerItem *)item;

/**
 处理AVPlayer的播放监听

 @param item 播放单元
 */
- (void)controlPlayItem:(AVPlayerItem *)item;

@property (nonatomic, weak) id<TBZAVPlayerControlViewDelegate> delegate;

/**
 上控制条的高度
 */
@property (nonatomic, assign) CGFloat topControlHeight;

/**
 下控制条的高度
 */
@property (nonatomic, assign) CGFloat botControlHeight;

/**
 是否全屏的判断，在set方法中做一些处理
 */
@property (nonatomic, assign) BOOL isFull;

@end

NS_ASSUME_NONNULL_END
