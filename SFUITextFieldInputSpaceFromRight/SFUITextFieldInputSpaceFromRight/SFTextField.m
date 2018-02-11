//
//  SFTextField.m
//  SFUITextFieldInputSpaceFromRight
//
//  Created by xiaoaihhh on 16/7/9.
//  Copyright © 2016年 xiaoaihhh. All rights reserved.
//

#import "SFTextField.h"

@implementation SFTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addTarget:self action:@selector(replaceNormalSpaceUsingNonbreakingSpace) forControlEvents:UIControlEventEditingChanged];
        }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(replaceNormalSpaceUsingNonbreakingSpace) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)replaceNormalSpaceUsingNonbreakingSpace
{
    UITextRange *textRange = self.selectedTextRange;
    self.text = [self.text stringByReplacingOccurrencesOfString:@" " withString:@"\u00a0"];
    [self setSelectedTextRange:textRange];
}

@end











