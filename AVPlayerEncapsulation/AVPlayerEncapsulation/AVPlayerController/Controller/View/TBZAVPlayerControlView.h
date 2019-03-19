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

@end

NS_ASSUME_NONNULL_BEGIN

@interface TBZAVPlayerControlView : UIView

- (void)parseData:(TBZAVPlayerModel *)playerModel;

- (void)controlItemStatus:(AVPlayerItemStatus)status;

@property (nonatomic, weak) id<TBZAVPlayerControlViewDelegate> delegate;

@property (nonatomic, assign) CGFloat topControlHeight;

@property (nonatomic, assign) CGFloat botControlHeight;

@property (nonatomic, assign) BOOL isFull;

@end

NS_ASSUME_NONNULL_END
