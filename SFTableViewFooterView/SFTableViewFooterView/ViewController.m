//
//  ViewController.m
//  SFTableViewFooterView
//
//  Created by xiaoaihhh on 16/7/5.
//  Copyright © 2016年 xiaoaihhh. All rights reserved.
//

#import "ViewController.h"
#import "SFCellFooterView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[SFCellFooterView alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"登";
        cell.imageView.image = [UIImage imageNamed:@"defaultUserIcon"];
    }
    else{
        cell.textLabel.text = @"我";
        cell.imageView.image = [UIImage imageNamed:@"defaultUserIcon"];
        
    }
    
    return cell;
}

@end
