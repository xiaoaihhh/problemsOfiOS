//
//  SFTextLinkView.h
//  SFTextLinkView
//
//  Created by xiaoaihhh on 2017/10/28.
//  Copyright © 2017年 LinkView. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFTextLinkView : UITextView

@property(nonatomic, strong) UIColor *hyperLinkTextColor; //超链接颜色
@property(nonatomic, strong) UIColor *hightLightHyperLinkTextColor; //点击后超链接颜色
@property(nonatomic, strong) NSDictionary *hyperLinkDictionary; //key:NSRange, value: block

@property(nonatomic, strong) NSDictionary *attributesOfText;//富文本的attribut

@end
