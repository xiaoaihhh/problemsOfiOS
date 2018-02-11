//
//  ViewController.m
//  SFTextLinkView
//
//  Created by xiaoaihhh on 2017/10/28.
//  Copyright © 2017年 LinkView. All rights reserved.
//

#import "ViewController.h"
#import "SFTextLinkView.h"

typedef void (^block)(void);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    block block1 = ^(){
        NSLog(@"bolck1");
    };
    block block2 = ^(){
        NSLog(@"bolck2");
    };
    
    SFTextLinkView *textView = [[SFTextLinkView alloc] init];
    textView.backgroundColor = [UIColor grayColor];
    
    textView.attributesOfText = [self attributesOfText];
    textView.hyperLinkTextColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    textView.hightLightHyperLinkTextColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.2];
    textView.text = @"一二三四五六七一二三四五六七一二三四五六七";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSStringFromRange(NSMakeRange(3, 5))] = block1;
    dic[NSStringFromRange(NSMakeRange(15, 5))] = block2;
    textView.hyperLinkDictionary = dic;
    //下面两个属性设置文字距离textView上下左右的距离，设置为0则可使用计算label大小方式计算
//    textView.textContainerInset = UIEdgeInsetsZero;
//    textView.textContainer.lineFragmentPadding = 0;
    CGSize size = [textView sizeThatFits:CGSizeMake(230, CGFLOAT_MAX)];
    textView.scrollEnabled = NO;
    textView.textAlignment = NSTextAlignmentJustified;
    textView.frame = CGRectMake(10, 100, size.width, size.height);
    [self.view addSubview:textView];
}

- (NSMutableDictionary *)attributesOfText
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:40];
    attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    return attributes;
}

@end
