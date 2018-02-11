//
//  ViewController.m
//  HHHPointInsde
//
//  Created by xiaoaihhh on 2018/2/11.
//  Copyright © 2018年 com.hhh.www. All rights reserved.
//

#import "ViewController.h"
#import "UIView+PointInside.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.center = self.view.center;
    btn.bounds = CGRectMake(0, 0, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    btn.hitTestExpandRects = @[NSStringFromCGRect(CGRectMake(0, 100, 100, 100))];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(105 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.hitTestExpandRects = nil;
    });

}

- (void)click {
    NSLog(@"clicked me...");
}

@end
