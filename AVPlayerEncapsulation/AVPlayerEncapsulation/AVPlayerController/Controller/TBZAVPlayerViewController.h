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

/**
 VC和present的block连接

 @param block 传递block
 */
- (void)btnClickMethod:(ChooseBlock)block;

@end

NS_ASSUME_NONNULL_END
