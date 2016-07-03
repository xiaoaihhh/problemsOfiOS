problemsOfiOS
==========================================

##目录
[设置UILabel的内边距](#设置UILabel的内边距)

在学习iOS中遇见的问题及解决方案

设置UILabel的内边距
----------------------------------------

###问题说明
默认Label的显示效果如下
<img src="https://raw.githubusercontent.com/SwiftlyFly/problemsOfiOS/master/images/SFLabel/QQ20160701-0%402x.png" width="50%" height="50%">

很多情况下，需要如下有内边距的效果（`注意第一行与最后一行文字与label的上下边距`）
<img src="https://raw.githubusercontent.com/SwiftlyFly/problemsOfiOS/master/images/SFLabel/QQ20160701-1%402x.png" width="50%" height="50%">

### 解决方案
为了解决这个问题，设计SFLabel如下，继承自UILabel

```
#import "SFLabel.h"
#import <UIKit/UIKit.h>

@interface SFLabel ()
// 用来决定上下左右内边距，也可以提供一个借口供外部修改，在这里就先固定写死
@property (assign, nonatomic) UIEdgeInsets edgeInsets;
@end

@implementation SFLabel


//下面三个方法用来初始化edgeInsets
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.edgeInsets = UIEdgeInsetsMake(25, 0, 25, 0);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.edgeInsets = UIEdgeInsetsMake(25, 0, 25, 0);
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.edgeInsets = UIEdgeInsetsMake(25, 0, 25, 0);
}

// 修改绘制文字的区域，edgeInsets增加bounds
-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{

    /*
    调用父类该方法
    注意传入的UIEdgeInsetsInsetRect(bounds, self.edgeInsets),bounds是真正的绘图区域
    */
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds,
     self.edgeInsets) limitedToNumberOfLines:numberOfLines];
    //根据edgeInsets，修改绘制文字的bounds
    rect.origin.x -= self.edgeInsets.left;
    rect.origin.y -= self.edgeInsets.top;
    rect.size.width += self.edgeInsets.left + self.edgeInsets.right;
    rect.size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return rect;
}

//绘制文字
- (void)drawTextInRect:(CGRect)rect
{
    //令绘制区域为原始区域，增加的内边距区域不绘制
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

@end
```

将UIlabel的类型改为SFLabel，看看现在效果是否如第二幅图😊。

### 注意事项
- 通过SFLabel中的方法修改UILabel的内边距最好只修改上下内边距，通过系统NSMutableParagraphStyle是可以修改左边内边距的；
- 通过`boundingRectWithSize:options:attributes:context:`计算SFLabel内容计算出的区域仍然是与直接使用UILabel的结果一样，因此需要小心使用，可以在`boundingRectWithSize:options:attributes:context:`基础上根据edgeInsets进行修正。

[SFLabel源码](https://github.com/SwiftlyFly/problemsOfiOS/tree/master/SFLabel)


