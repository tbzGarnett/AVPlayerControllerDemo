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

- (BOOL)fullBtnAction:(BOOL)isFull;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TBZAVPlayerView : UIView

@property (nonatomic, weak) id<TBZAVPlayerViewDelegate> delegate;

- (void)parseData:(TBZAVPlayerModel *)playerModel;

- (void)destroy;

- (void)enterFull;

- (void)exitFull;
@end

NS_ASSUME_NONNULL_END
