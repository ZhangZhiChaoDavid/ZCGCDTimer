//
//  ZCGCDTimer.m
//  ZCTimer
//
//  Created by 张智超 on 2018/8/13.
//  Copyright © 2018年 张智超. All rights reserved.
//

#import "ZCGCDTimer.h"

#define LOCK    [_lock lock]
#define UNLOCK  [_lock unlock]

@interface ZCGCDTimer ()
{
    id _target;
    NSTimeInterval _timeInterval;
    BOOL _repeats;
    dispatch_source_t _timer;
    SEL _selector;
    BOOL _valid;
    NSLock *_lock;
}
@end

@implementation ZCGCDTimer

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)aTarget selector:(SEL)aSelector repeats:(BOOL)repeats {
    return [ZCGCDTimer timerWithFireTime:0.0f interval:timeInterval target:aTarget selector:aSelector repeats:repeats];
}

+ (instancetype)timerWithFireTime:(NSTimeInterval)start interval:(NSTimeInterval)timeInterval target:(id)aTarget selector:(SEL)aSelector repeats:(BOOL)repeats {
    return [[ZCGCDTimer alloc] initWithFireTime:start interval:timeInterval target:aTarget selector:aSelector repeats:repeats];
}


- (instancetype)initWithFireTime:(NSTimeInterval)start
                        interval:(NSTimeInterval)timeInterval
                          target:(id)target
                        selector:(SEL)selector
                         repeats:(BOOL)repeats {
    
    if (self = [super init]) {
        _target = target;
        _selector = selector;
        _repeats = repeats;
        _timeInterval = timeInterval;
        _valid = YES;
        _lock = [[NSLock alloc] init];
        
        __weak typeof(self)weakSelf = self;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, (start * NSEC_PER_SEC)), (timeInterval * NSEC_PER_SEC), 0);
        dispatch_source_set_event_handler(timer, ^{
            [weakSelf fire];
        });
        
        dispatch_resume(timer);
        _timer = timer;
    }
    
    return self;
}

- (void) fire {
    if (!_valid) return;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    LOCK;
    id target = _target;
    if (!_target) {
        [self invalidate];
    } else {
        [target performSelector:_selector withObject:self];
        if (!_repeats) {
            [self invalidate];
        }
    }
    UNLOCK;
#pragma clang diagnostic pop
}

- (void)invalidate {
    LOCK;
    if (_valid) {
        dispatch_source_cancel(_timer);
        _timer = NULL;
        _target = nil;
        _valid = NO;
    }
    UNLOCK;
}

- (NSTimeInterval)timeInterval {
    LOCK;
    NSTimeInterval t = _timeInterval;
    UNLOCK;
    return t;
}

- (BOOL)repeats {
    LOCK;
    BOOL r = _repeats;
    UNLOCK;
    return r;
}

- (BOOL)isValid {
    LOCK;
    BOOL valid = _valid;
    UNLOCK;
    return valid;
}

- (void)dealloc {
    
    [self invalidate];
    NSLog(@"timer dealloc");
}

@end

