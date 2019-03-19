//
//  ViewController.m
//  AVPlayerEncapsulation
//
//  Created by apple on 2019/3/18.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ViewController.h"
#import "TBZAVPlayerViewController.h"
#import <Masonry/Masonry.h>

@interface ViewController ()<UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.delegate = self;
    
    UIButton *gotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gotoBtn.backgroundColor = [UIColor redColor];
    [gotoBtn setTitle:@"播放" forState:UIControlStateNormal];
    [gotoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    gotoBtn.frame = CGRectMake(0, 0, 200, 100);
    gotoBtn.center = self.view.center;
    [gotoBtn addTarget:self action:@selector(gotoAVPlayerVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gotoBtn];
}

- (void)gotoAVPlayerVC{
    TBZAVPlayerViewController *vc = [[TBZAVPlayerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    BOOL isShowNavigationBar = NO;
    
    if ([viewController isKindOfClass:[TBZAVPlayerViewController class]]) {
        isShowNavigationBar = YES;
    }
    
    [self.navigationController setNavigationBarHidden:isShowNavigationBar animated:YES];
}

@end
