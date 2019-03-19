//
//  TBZAVFullViewController.m
//  AVPlayerEncapsulation
//
//  Created by apple on 2019/3/18.
//  Copyright © 2019 apple. All rights reserved.
//

#import "TBZAVFullViewController.h"

@interface TBZAVFullViewController ()

@end

@implementation TBZAVFullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
}

//这是正确的
- (BOOL)prefersStatusBarHidden{
    return NO;
}

#pragma mark - 直接根据type强制将屏幕旋转
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if (self.type) {
        return UIInterfaceOrientationLandscapeLeft;
    }else {
        return UIInterfaceOrientationLandscapeRight;
    }
}

@end
