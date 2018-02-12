//
//  HHHTextField.m
//  HHHFieldView
//
//  Created by xiaoaihhh on 2018/2/12.
//  Copyright © 2018年 com.hhh.www. All rights reserved.
//

#import "HHHTextField.h"

@interface HHHTextField()
{
    CGFloat _defaultYOffset; //标记_FieldEditorContentView初始偏y方向移量
}
@end


@implementation HHHTextField

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIScrollView *fieldEditor in self.subviews) {
        if ([fieldEditor isKindOfClass:[UIScrollView class]]) { // UIFieldEditor
            CGFloat currentYOffset = 0.0f;
            for (UIView *fieldEditorContentView in fieldEditor.subviews) { //_FieldEditorContentView
                currentYOffset = fieldEditorContentView.frame.origin.y;
                if (_defaultYOffset == 0.0f && currentYOffset != 0.0f) {
                    _defaultYOffset = currentYOffset;
                }
            }
            CGPoint offset = fieldEditor.contentOffset;
            if (currentYOffset == 0.0f && _defaultYOffset != 0.0f) {
                offset.y = -_defaultYOffset;
            } else {
                offset.y = 0.0f;
            }
            if (self.text.length == 0 && self.attributedText.length == 0) { //字体为空时重置_defaultYOffset
                offset.y = 0.0f;
                _defaultYOffset = 0.0f;
            }
            fieldEditor.contentOffset = offset;
            break;
        }
    }
}

@end
