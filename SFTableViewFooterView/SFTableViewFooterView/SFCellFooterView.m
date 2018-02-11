//
//  SFMeCellFooterView.m
//  百思不得姐
//
//  Created by xiaoaihhh on 16/7/2.
//  Copyright © 2016年 nowGO. All rights reserved.
//

#import "SFCellFooterView.h"
#import <AFNetworking.h>



@implementation SFCellFooterView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        parameter[@"a"] = @"square";
        parameter[@"c"] = @"topic";
        [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                                    self.frame.size.width, 1000);
            self.backgroundColor = [UIColor redColor];
            
            UITableView *tableView = (UITableView *)self.superview;
            
            tableView.tableFooterView = self;//注释掉这句看看有什么区别
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    return self;
}





@end















