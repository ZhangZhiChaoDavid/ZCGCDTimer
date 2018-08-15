//
//  ZCGCDTimer.h
//  ZCTimer
//
//  Created by 张智超 on 2018/8/13.
//  Copyright © 2018年 张智超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCGCDTimer : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;


/**
 定时器类方法创建 立即开启
 */
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval
                               target:(id)aTarget
                             selector:(SEL)aSelector
                              repeats:(BOOL)repeats;

/**
 定时器类方法创建 定时开启时间
 */
+ (instancetype)timerWithFireTime:(NSTimeInterval)start
                         interval:(NSTimeInterval)timeInterval
                           target:(id)aTarget
                         selector:(SEL)aSelector
                          repeats:(BOOL)repeats;

/**
 timer fire
 */
- (void)fire;
/**
 timer invalidate
 */
- (void)invalidate;

@property(readonly)BOOL repeats;
@property(readonly)NSTimeInterval timeInterval;
@property(readonly, getter=isValid)BOOL valid;

@end
