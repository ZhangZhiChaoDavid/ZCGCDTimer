//
//  ViewController.m
//  ZCTimer
//
//  Created by 张智超 on 2018/8/13.
//  Copyright © 2018年 张智超. All rights reserved.
//

#import "ViewController.h"
#import "ZCGCDTimer.h"

@interface ViewController ()
{
    int _count;
    ZCGCDTimer *_timer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _count = 20;
    _timer = [ZCGCDTimer timerWithFireTime:5 interval:2 target:self selector:@selector(test) repeats:YES];
    
    
}

- (void)test {
    
    if (_count==0) {
        [_timer invalidate];
    }
    _count --;
    NSLog(@"~~~%d",_count);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
