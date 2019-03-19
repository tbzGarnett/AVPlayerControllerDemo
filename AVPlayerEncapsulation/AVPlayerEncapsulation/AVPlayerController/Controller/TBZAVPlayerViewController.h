//
//  TBZAVPlayerViewController.h
//  AVPlayerEncapsulation
//
//  Created by apple on 2019/3/18.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TBZAVPlayerView;

typedef void (^ChooseBlock)(NSInteger i);

NS_ASSUME_NONNULL_BEGIN

@interface TBZAVPlayerViewController : UIViewController
@property (nonatomic, strong) TBZAVPlayerView *playerView;

- (void)btnClickMethod:(ChooseBlock)block;

@end

NS_ASSUME_NONNULL_END
