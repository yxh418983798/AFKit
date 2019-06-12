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
    self.navigationItem.title = @"定时器";
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:(CGRectMake(0, 100, 100, 50))];
    [btn1 setTitle:@"开启定时器" forState:(UIControlStateNormal)];
    [btn1 addTarget:self action:@selector(timerAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn1];
    
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:(CGRectMake(0, 100, 100, 50))];
    [btn1 setTitle:@"关闭定时器" forState:(UIControlStateNormal)];
    [btn1 addTarget:self action:@selector(timerAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn1];
    
    //初始化定时器
    AFTimer *timer = [AFTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:@"timer的参数" repeats:YES forMode:NSRunLoopCommonModes];
    timer.tag = 1;
}



- (void)fireTimer {
    [AFTimer fireWithTag:1];
}


- (void)invalidTimer {
    [AFTimer invalidateWithTag:1];
}


- (void)timerAction:(AFTimer *)timer {
    NSLog(@"-------------------------- 执行定时器方法，userInfo:%@ --------------------------", timer.userInfo);
}



@end
