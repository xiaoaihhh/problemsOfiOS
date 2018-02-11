//
//  UIView+PointInside.m
//  hittest
//
//  Created by xaoaihhh on 2018/1/18.
//  Copyright © 2018年 xiaoaihhh. All rights reserved.
//

#import "UIView+PointInside.h"
#import <objc/runtime.h>

static char bbaPointInsideExpandEdgeInsets;
@implementation UIView (PointInside)

+(void)load{
    Method hitTestMethod = class_getInstanceMethod([UIView class], @selector(pointInside:withEvent:));
    Method hook_hitTestMethod= class_getInstanceMethod([UIView class], @selector(hook_pointInside:withEvent:));
    method_exchangeImplementations(hitTestMethod, hook_hitTestMethod);
}

- (void)setHitTestExpandRects:(NSArray *)hitTestExpandRects{
     objc_setAssociatedObject(self, &bbaPointInsideExpandEdgeInsets, hitTestExpandRects, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)hitTestExpandRects{
    return objc_getAssociatedObject(self, &bbaPointInsideExpandEdgeInsets);
}

- (BOOL)hook_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL defaultHit = [self hook_pointInside:point withEvent:event];
    if (defaultHit) {
        return YES;
    }
    
    NSArray *expandRects = self.hitTestExpandRects;
    if (!expandRects) {
        return NO;
    }
    for (NSString *rectStr in expandRects) {
        if (![rectStr isKindOfClass:[NSString class]]) {
            continue;
        }
        if (CGRectContainsPoint(CGRectFromString(rectStr), point)) {
            return YES;
        }
    }

    return NO;
}

@end
