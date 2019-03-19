//
//  TBZAVPlayerView.h
//  AVPlayerEncapsulation
//
//  Created by apple on 2019/3/18.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TBZAVPlayerModel;

@protocol TBZAVPlayerViewDelegate <NSObject>

- (void)fullBtnAction:(BOOL)isFull;

- (void)backBtnClick;

- (void)playEnd;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TBZAVPlayerView : UIView

@property (nonatomic, weak) id<TBZAVPlayerViewDelegate> delegate;

/**
 播放模型的传递

 @param playerModel 播放model
 */
- (void)parseData:(TBZAVPlayerModel *)playerModel;

/**
 销毁，处理一些置空，取消监听
 */
- (void)destroy;

/**
 进入全屏，处理一下AVPlayerLayer的frame
 */
- (void)enterFull;

/**
 退出全屏，处理一下AVPlayerLayer的frame
 */
- (void)exitFull;
@end

NS_ASSUME_NONNULL_END
