//
//  AFTimer.m
//  AFWorkSpace
//
//  Created by alfie on 2019/6/5.
//  Copyright © 2019 Alfie. All rights reserved.
//

#import "AFTimer.h"
#import <QuartzCore/CADisplayLink.h>

typedef NS_ENUM(NSInteger, AFTimerOption) {
    AFTimerOptionTimerTarget,
    AFTimerOptionDisplayLink,
    AFTimerOptionGCD,
};


@interface AFTimer ()

@property (class, strong, nonatomic) NSMutableDictionary  *timerCache;

/** 定时器 */
@property (strong, nonatomic) NSTimer            *timer;

/** displayLink */
@property (strong, nonatomic) CADisplayLink      *displayLink;

/** gcd定时器 */
@property (strong, nonatomic) dispatch_source_t  gcd_timer;

/** target */
@property (weak, nonatomic) id                   target;

/** 执行方法 */
@property (assign, nonatomic) SEL                selector;

/** 间隔时间 */
@property (assign, nonatomic) NSTimeInterval     interval;

/** 是否重复 */
@property (assign, nonatomic) BOOL               repeats;

/** runloopMode */
@property (assign, nonatomic) NSRunLoopMode      runloopMode;

/** 定时器类型 */
@property (assign, nonatomic) AFTimerOption      timerOption;

/** gcd定时器的线程 */
@property (strong, nonatomic) dispatch_queue_t   queue;

@end


static NSMutableDictionary *_timerCache;
static AFTimer *_timerManager;


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@implementation AFTimer
#pragma mark -- 生命周期
+ (AFTimer *)timerWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats forMode:(NSRunLoopMode)mode {
    
    AFTimer *timer = [AFTimer new];
    timer.target = target ?: timer;
    timer.selector = selector;
    timer.runloopMode = mode;
    timer.interval = interval;
    timer.repeats = repeats;
    timer.timerOption = AFTimerOptionTimerTarget;
    [timer setValue:userInfo forKey:@"_userInfo"];
    return timer;
}


+ (AFTimer *)displayLinkWithFrameInterval:(NSInteger)interval target:(id)target selector:(SEL)selector userInfo:(id)userInfo forMode:(NSRunLoopMode)mode {
    
    AFTimer *timer = [AFTimer new];
    timer.target = target ?: timer;
    timer.interval = interval;
    timer.selector = selector;
    timer.runloopMode = mode;
    timer.timerOption = AFTimerOptionDisplayLink;
    [timer setValue:userInfo forKey:@"_userInfo"];
    return timer;
}


+ (AFTimer *)GCDTimerWithInterval:(NSInteger)interval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats queue:(nonnull dispatch_queue_t)queue {
    
    AFTimer *timer = [AFTimer new];
    timer.target = target ?: timer;
    timer.selector = selector;
    timer.interval = interval;
    timer.repeats = repeats;
    timer.timerOption = AFTimerOptionGCD;
    timer.queue = queue ?: dispatch_get_main_queue();
    [timer setValue:userInfo forKey:@"_userInfo"];
    return timer;
}



#pragma mark -- 定时器管理
- (void)monitorTimer {
    NSArray *timerArray = AFTimer.timerCache.allValues;
    for (int i = 0; i < timerArray.count; i++) {
        AFTimer *timer = timerArray[i];
        if (!timer.isValid && !timer.target) {
            [AFTimer.timerCache setValue:nil forKey:[NSString stringWithFormat:@"%li", (long)timer.tag]];
        }
    }
    if (!AFTimer.timerCache.count) {
        [_timerManager invalidate];
        _timerManager = nil;
    }
}



#pragma mark -- 代理执行方法
- (void)timerAction {
    
    switch (self.timerOption) {
        case AFTimerOptionTimerTarget: {
            if (self.target) {
                [self.target performSelector:self.selector withObject:self];
            } else {
                [self releaseTimer];
            }
        }
            break;
            
        case AFTimerOptionDisplayLink: {
            if (self.target) {
                [self.target performSelector:self.selector withObject:self];
            } else {
                [self releaseTimer];
            }
        }
            break;
            
        case AFTimerOptionGCD: {
            if (self.target) {
                [self.target performSelector:self.selector withObject:self];
            } else {
                [self releaseTimer];
            }
        }
            break;
            
        default:
            break;
    }
}



#pragma mark -- 启动
- (void)fire {
    
    switch (self.timerOption) {
        case AFTimerOptionTimerTarget: {
            if (self.timer) {
                [self.timer invalidate];
                self.timer = nil;
            }
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(timerAction) userInfo:self.userInfo repeats:self.repeats];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:self.runloopMode];
        }
            break;
            
        case AFTimerOptionDisplayLink: {
            if (self.displayLink) {
                [self.displayLink invalidate];
                self.displayLink = nil;
            }
            
            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerAction)];
            self.displayLink.frameInterval = self.interval;
            [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:self.runloopMode];
        }
            break;
            
        case AFTimerOptionGCD: {
            if (self.gcd_timer) {
                dispatch_cancel(self.gcd_timer);
                self.gcd_timer = nil;
            }
            self.gcd_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
            dispatch_source_set_timer(self.gcd_timer, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0*NSEC_PER_SEC)), (uint64_t)(self.interval*NSEC_PER_SEC), 0);
            dispatch_source_set_event_handler(self.gcd_timer, ^{
                [self timerAction];
                if (!self.repeats) {
                    [self invalidate];
                }
            });
            dispatch_resume(self.gcd_timer);
        }
            break;
            
        default:
            break;
    }
}



#pragma mark -- 停止
- (void)invalidate {
    
    switch (self.timerOption) {
        case AFTimerOptionTimerTarget: {
            [self.timer invalidate];
            self.timer = nil;
        }
            break;
            
        case AFTimerOptionDisplayLink: {
            [self.displayLink invalidate];
            self.displayLink = nil;
        }
            break;
            
        case AFTimerOptionGCD: {
            dispatch_cancel(self.gcd_timer);
            self.gcd_timer = nil;
        }
            break;
            
        default:
            break;
    }
}



#pragma mark -- 销毁
- (void)releaseTimer {
    [self invalidate];
    if ([AFTimer.timerCache.allValues containsObject:self]) {
        [AFTimer.timerCache removeObjectForKey:[NSString stringWithFormat:@"%li", (long)self.tag]];
    }
}



#pragma mark -- 状态
- (BOOL)isValid {
    switch (self.timerOption) {
        case AFTimerOptionTimerTarget:
            return (BOOL)self.timer;
        case AFTimerOptionDisplayLink:
            return (BOOL)self.displayLink;
        case AFTimerOptionGCD:
            return (BOOL)self.gcd_timer;
        default:
            return NO;
    }
}



#pragma mark -- Tag
+ (void)setTimerCache:(NSMutableDictionary *)timerCache {
    _timerCache = timerCache;
}
+ (NSMutableDictionary *)timerCache {
    if (!_timerCache) {
        _timerCache = [NSMutableDictionary dictionary];
    }
    return _timerCache;
}

- (void)setTag:(NSInteger)tag {
    _tag = tag;
    [AFTimer.timerCache setValue:self forKey:[NSString stringWithFormat:@"%li", (long)tag]];
    if (!_timerManager) {
        _timerManager = [AFTimer GCDTimerWithInterval:1 target:nil selector:@selector(monitorTimer) userInfo:nil repeats:YES queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        [_timerManager fire];
    }
}

+ (AFTimer *)timerWithTag:(NSInteger)tag {
    return [AFTimer.timerCache valueForKey:[NSString stringWithFormat:@"%li", (long)tag]];
}

+ (BOOL)isValidWithTag:(NSInteger)tag {
    AFTimer *timer = [AFTimer timerWithTag:tag];
    if (timer) {
        return timer.isValid;
    } else {
        NSLog(@"AFTimer:获取定时器状态错误：tag=%li的定时器不存在", (long)tag);
        return NO;
    }
}

+ (void)fireWithTag:(NSInteger)tag {
    AFTimer *timer = [AFTimer timerWithTag:tag];
    if (timer) {
        [timer fire];
    } else {
        NSLog(@"AFTimer:启动定时器错误：tag=%li的定时器不存在", (long)tag);
    }
}

+ (void)invalidateWithTag:(NSInteger)tag {
    AFTimer *timer = [AFTimer timerWithTag:tag];
    if (timer) {
        [timer invalidate];
    } else {
        NSLog(@"AFTimer:停止定时器错误：tag=%li的定时器不存在", (long)tag);
    }
}

+ (void)releaseTimerWithTag:(NSInteger)tag {
    AFTimer *timer = [AFTimer timerWithTag:tag];
    if (timer) {
        [timer releaseTimer];
    } else {
        NSLog(@"AFTimer:销毁定时器错误：tag=%li的定时器不存在", (long)tag);
    }
}

@end
#pragma clang diagnostic pop
