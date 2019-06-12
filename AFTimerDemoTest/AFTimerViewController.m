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
    btn1.backgroundColor = UIColor.grayColor;
    [btn1 setTitle:@"开启定时器" forState:(UIControlStateNormal)];
    [btn1 addTarget:self action:@selector(fireTimer) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn1];
    
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:(CGRectMake(0, 200, 100, 50))];
    btn2.backgroundColor = UIColor.grayColor;
    [btn2 setTitle:@"关闭定时器" forState:(UIControlStateNormal)];
    [btn2 addTarget:self action:@selector(invalidTimer) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn2];
    
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
    static UILabel *label;
    static int count = 0;
    if (!label) {
        label = [[UILabel alloc] initWithFrame:(CGRectMake(150, 100, 100, 50))];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = UIColor.grayColor;
        [self.view addSubview:label];
    }
    count ++;
    label.text = [NSString stringWithFormat:@"%d", count];
    NSLog(@"-------------------------- 执行定时器方法，userInfo:%@ --------------------------", timer.userInfo);
}



@end
