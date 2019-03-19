//
//  TBZAVPresent.h
//  AVPlayerEncapsulation
//
//  Created by apple on 2019/3/18.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TBZAVPlayerViewController;

NS_ASSUME_NONNULL_BEGIN

@interface TBZAVPresent : NSObject
- (void)addView:(TBZAVPlayerViewController *)playerViewController;

- (void)playEnd:(TBZAVPlayerViewController *)playerViewController;
@end

NS_ASSUME_NONNULL_END
