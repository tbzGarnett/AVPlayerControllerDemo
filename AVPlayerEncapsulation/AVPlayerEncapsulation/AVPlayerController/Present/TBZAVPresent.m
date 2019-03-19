//
//  TBZAVPresent.m
//  AVPlayerEncapsulation
//
//  Created by apple on 2019/3/18.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TBZAVPresent.h"
#import "TBZAVPlayerViewController.h"
#import "TBZAVPlayerView.h"
#import "TBZAVPlayerModel.h"

@interface TBZAVPresent()
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) NSInteger playIndex;
@end

@implementation TBZAVPresent

- (void)addView:(TBZAVPlayerViewController *)playerViewController{
    [self loadData];
    
    [playerViewController.playerView parseData:self.dataArr[0]];
    _playIndex = 0;
    __weak TBZAVPresent *weakself = self;
    __weak TBZAVPlayerViewController *weakPlayerVC = playerViewController;
    [playerViewController btnClickMethod:^(NSInteger i) {
        [weakPlayerVC.playerView parseData:weakself.dataArr[i]];
        weakself.playIndex = i;
    }];
}

- (void)playEnd:(TBZAVPlayerViewController *)playerViewController{
    [playerViewController.playerView parseData:self.dataArr[self.dataArr.count - 1 -self.playIndex]];
    self.playIndex = self.dataArr.count-1-self.playIndex;
}

- (void)loadData{
    //网络请求数据相关
    self.dataArr = [NSMutableArray array];
    for (int i = 0; i<2; i++) {
        TBZAVPlayerModel *model = [[TBZAVPlayerModel alloc] init];
        if (i == 0) {
            model.title = @"剑桥国际少儿英语Kid＇s Box 2第3单元小故事";
            
        }else{
            model.title = @"混沌大学1";
        }
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *urlString = [bundle pathForResource:model.title ofType:@"mp4"];
        model.playLink = urlString;
        [self.dataArr addObject:model];
    }
}

@end
