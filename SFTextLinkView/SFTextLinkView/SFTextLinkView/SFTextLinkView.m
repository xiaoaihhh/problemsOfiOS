//
//  SFTextLinkView.m
//  SFTextLinkView
//
//  Created by xiaoaihhh on 2017/10/28.
//  Copyright © 2017年 LinkView. All rights reserved.
//

#import "SFTextLinkView.h"

typedef void (^block)(void);

@interface SFTextLinkView()
{
    NSDictionary *_hyperLinkRespondRectsDict; //key:NSRange, value: NSArray<NSString *>, (NSStringFromCGRect)
}
@end

@implementation SFTextLinkView

- (instancetype)init
{
    if (self = [super init]) {
        self.editable = NO;
        self.selectable = NO;
        [self addGestureRecognizer:[self longPressGestureRecognizer]];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setTextLabelAttributesWithText:self.text];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setTextLabelAttributesWithText:self.text];
    [self initHyperLinkRespondRectsDict];
}

- (void)initHyperLinkRespondRectsDict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *key in _hyperLinkDictionary.allKeys) {
        dict[key] = [self respondRectsFromRange:NSRangeFromString(key)];
    }
    _hyperLinkRespondRectsDict = dict;
}

/**
 根据range计算出range所在textview的矩形区域
 
 @param range textView文字范围
 @return 文字所在父view的矩形区域
 */
- (NSArray *)respondRectsFromRange:(NSRange)range
{
    self.selectable = YES; //不设置为YES iOS9计算会出错
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *rangeStart = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *rangeEnd = [self positionFromPosition:rangeStart offset:range.length];
    UITextRange *textRange = [self textRangeFromPosition:rangeStart toPosition:rangeEnd];
    NSArray *ranges = [self selectionRectsForRange:textRange];
    NSMutableArray *respondRects = [NSMutableArray array];
    for (UITextSelectionRect *selectionRect in ranges) {
        CGRect rect = selectionRect.rect;
        if (rect.size.width > 0 && rect.size.height > 0) {
            [respondRects addObject:NSStringFromCGRect(rect)];
        }
    }
    self.selectable = NO;
    return respondRects;
}


// 创建长按手势
- (UILongPressGestureRecognizer *)longPressGestureRecognizer
{
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressGesture.minimumPressDuration = 0.01f; //模拟tap手势，利用UIGestureRecognizerStateBegan状态
    return longPressGesture;
}


// 长按事件

- (void)longPressed:(UILongPressGestureRecognizer *)LongPress
{
    CGPoint longPressPoint = [LongPress locationInView:self];
    if (LongPress.state == UIGestureRecognizerStateBegan) {
        NSString *respondKey = [self keyRespondToHyperLinkAtPoint:longPressPoint];
        if (respondKey) {
            [self setTextLabelAttributesWithText:self.text hightLightLinkKeys:@[respondKey]];
        }
    }
    else if (LongPress.state == UIGestureRecognizerStateEnded)
    {
        [self setTextLabelAttributesWithText:self.text hightLightLinkKeys:@[]];
        [self performHyperLinkActionAtPoint:longPressPoint];
    }
    else if (LongPress.state == UIGestureRecognizerStateFailed || LongPress.state == UIGestureRecognizerStateCancelled){
        [self setTextLabelAttributesWithText:self.text hightLightLinkKeys:@[]];
    }
}


/**
 执行长按事件的block
 */
- (BOOL)performHyperLinkActionAtPoint:(CGPoint)point
{
    NSString *respondKey = [self keyRespondToHyperLinkAtPoint:point];
    if ([_hyperLinkDictionary.allKeys containsObject:respondKey]) {
        block excuteBlock = _hyperLinkDictionary[respondKey];
        excuteBlock();
        return YES;
    }
    return NO;
}

//点击了哪个超链接
- (NSString *)keyRespondToHyperLinkAtPoint:(CGPoint)point
{
    __block NSString *respondKey = nil;
    [_hyperLinkRespondRectsDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSArray *respondRects = obj;
        for (NSString *rectStr in respondRects) {
            if (CGRectContainsPoint(CGRectFromString(rectStr), point)) {
                *stop = YES;
                respondKey = key;
                break;
            }
        }
    }];
    return respondKey;
}

- (void)setTextLabelAttributesWithText:(NSString *)text
{
    [self setTextLabelAttributesWithText:text hightLightLinkKeys:@[]];
}

- (void)setTextLabelAttributesWithText:(NSString *)text hightLightLinkKeys:(NSArray *)linkKeys
{
    if (self.attributesOfText && self.text) {
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text attributes:self.attributesOfText];
        for (NSString *rangeStr in _hyperLinkDictionary.allKeys) {
            if ([linkKeys containsObject:rangeStr]) {
                [attributeStr addAttribute:NSForegroundColorAttributeName value:_hightLightHyperLinkTextColor range:NSRangeFromString(rangeStr)];
            }
            else
            {
                [attributeStr addAttribute:NSForegroundColorAttributeName value:_hyperLinkTextColor range:NSRangeFromString(rangeStr)];
            }
        }
        [self setAttributedText:attributeStr];
    }
}


-(void)setHyperLinkTextColor:(UIColor *)hyperLinkTextColor
{
    _hyperLinkTextColor = hyperLinkTextColor;
    if (!_hightLightHyperLinkTextColor) {
        _hightLightHyperLinkTextColor = hyperLinkTextColor;
    }
}

@end
