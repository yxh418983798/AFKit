//
//  AFTimerViewController.m
//  AFWorkSpace
//
//  Created by alfie on 2019/6/5.
//  Copyright © 2019 Alfie. All rights reserved.
//

#import "AFTimerViewController.h"
#import <AFKit/AFTimer.h>

@interface AFTimerViewController ()

/** 定时器 */
@property (strong, nonatomic) AFTimer            *timer;

@end

@implementation AFTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开启" style:(UIBarButtonItemStylePlain) target:self action:@selector(controlTimer)];
    
    self.timer = [AFTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:@"参数" repeats:YES forMode:NSRunLoopCommonModes];
    
//    self.timer = [AFTimer displayLinkWithFrameInterval:60 target:self selector:@selector(timerAction:) userInfo:@"参数" forMode:NSRunLoopCommonModes];
    
//    self.timer = [AFTimer GCDTimerWithInterval:1 target:self selector:@selector(timerAction:) userInfo:@"参数" repeats:YES queue:nil];
    self.timer.tag = 1;
    [AFTimer fireWithTag:1];
    
    AFTimer *timer = [AFTimer displayLinkWithFrameInterval:60 target:self selector:@selector(timerAction:) userInfo:@"参数" forMode:NSRunLoopCommonModes];
    timer.tag = 2;
    [timer fire];
}


- (void)controlTimer {
    
    if (self.timer.isValid) {
//        [self.timer invalidate];
//        [AFTimer invalidateWithTag:1];
        [AFTimer releaseTimerWithTag:1];
        [AFTimer invalidateWithTag:2];

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开启" style:(UIBarButtonItemStylePlain) target:self action:@selector(controlTimer)];
    } else {
//        [self.timer fire];
        [AFTimer fireWithTag:1];
        [AFTimer fireWithTag:2];

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:(UIBarButtonItemStylePlain) target:self action:@selector(controlTimer)];
    }
}

- (void)timerAction:(id)userInfo {
    NSLog(@"-------------------------- 定时器时间:%@ --------------------------", userInfo);
}

- (void)dealloc {
    NSLog(@"-------------------------- TimerVC被释放 --------------------------");
//    [self.timer invalidate];
}

@end
