//
//  ViewController.m
//  SFLabel
//
//  Created by xiaoaihhh on 16/7/1.
//  Copyright © 2016年 xiaoaihhh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentLabel.text = @"在这样雨雪交加的日子里，如果没有什么紧要事，人们宁愿一整天足不出户。因此，县城的大街小巷倒也比平时少了许多嘈杂。街巷背阴的地方。冬天残留的积雪和冰溜子正在雨点的敲击下蚀化，石板街上到处都漫流着肮脏的污水。";
}

@end
