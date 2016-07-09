problemsOfiOS
==========================================
在学习iOS中遇见的问题及解决方案


##目录
[设置UILabel的内边距](#设置UILabel的内边距)

[UITextField右对齐无法输入空格解决方案](#UITextField右对齐无法输入空格解决方案)




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
-(CGRect)textRectForBounds:(CGRect)bounds 
    limitedToNumberOfLines:(NSInteger)numberOfLines
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

[SFLabel示例源码](https://github.com/SwiftlyFly/problemsOfiOS/tree/master/SFLabel)








UITextField右对齐无法输入空格解决方案
----------------------------------------

### 问题说明
今天使用UITextfield需要右对齐输入，但是当设置右对齐第一个字符输入空格后，神奇的一幕发生了，如下图，`如果第一个字符输入的是空格，那么光标会跳到左侧；如果输入其它字符，然后输入空格，此时输入的空格不会立即显示，直到再次输入其它字符时该空格会与输入的字符同时显示出来`。

<img src="https://raw.githubusercontent.com/SwiftlyFly/problemsOfiOS/master/images/SFUITextFieldInputSpaceFromRight/1%E9%97%AE%E9%A2%98%E9%99%88%E8%BF%B0.gif" width="50%" height="30%">

### 解决思路
解决思路很简单，就是将我们输入的普通空格使用[Non-breaking space](https://en.wikipedia.org/wiki/Non-breaking_space)代替。

### 解决方案
#### 方案1：通过代理方法监听textfield的输入。

1.首先设置控制器作为textfield的代理，

```
self.textField.delegate = self;
```

2.监听文本的输入，做如下处理

```
- (BOOL)textField:(UITextField *)textField 
        shouldChangeCharactersInRange:(NSRange)range 
        replacementString:(NSString *)string
{
    /* 如果不是右对齐，直接返回YES，不做处理 */
    if (textField.textAlignment != NSTextAlignmentRight) {
        return YES;
    }
    
    /* 在右对齐的情况下*/
    // 如果string是@""，说明是删除字符（剪切删除操作），则直接返回YES，不做处理
    // 如果把这段删除，在删除字符时光标位置会出现错误
    if ([string isEqualToString:@""]) {
        return YES;
    }

    /* 在输入单个字符或者粘贴内容时做如下处理，已确定光标应该停留的正确位置，
    没有下段从字符中间插入或者粘贴光标位置会出错 */
    // 首先使用 non-breaking space 代替默认输入的@“ ”空格
    string = [string stringByReplacingOccurrencesOfString:@" " 
                     withString:@"\u00a0"];
    textField.text = [textField.text stringByReplacingCharactersInRange:range 
                                     withString:string];
    //确定输入或者粘贴字符后光标位置
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextPosition *cursorLoc = [textField positionFromPosition:beginning 
                                 offset:range.location+string.length];
    // 选中文本起使位置和结束为止设置同一位置
    UITextRange *textRange = [textField textRangeFromPosition:cursorLoc 
                                        toPosition:cursorLoc];
    // 选中字符范围（由于textRange范围的起始结束位置一样所以并没有选中字符）
    [textField setSelectedTextRange:textRange];
    
    return NO;
}
```

3.如果需要拿到textfield中的text使用，在使用前记得将 non-breaking space替换回来

```
[self.textField.text stringByReplacingOccurrencesOfString:@"\u00a0" 
                     withString:@" "]; 
```

**弊端分析：**上面代理方法`textField: shouldChangeCharactersInRange: replacementString:`对于很多输入字符返回的是NO，因此不能很好的监听`UITextFieldTextDidChangeNotification`，因此不推荐使用。

**效果演示**

<img src="https://raw.githubusercontent.com/SwiftlyFly/problemsOfiOS/master/images/SFUITextFieldInputSpaceFromRight/2%E4%BB%A3%E7%90%86%E6%95%88%E6%9E%9C%E6%BC%94%E7%A4%BA.gif" width="50%" height="50%">

#### 方案2：通过addTarget: action: forControlEvents: 给textField添加响应事件
在此，自定义了一个textField，code如下：

```
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    
    // 给textfield添加响应事件
        [self addTarget:self 
        action:@selector(replaceNormalSpaceUsingNonbreakingSpace) 
        forControlEvents:UIControlEventEditingChanged];
        }
    return self;
}

// 在响应事件中将@" "替换为non-breaking space
- (void)replaceNormalSpaceUsingNonbreakingSpace
{
    UITextRange *textRange = self.selectedTextRange;
    self.text = [self.text stringByReplacingOccurrencesOfString:@" " 
                           withString:@"\u00a0"];
    [self setSelectedTextRange:textRange];
}
```
**说明：**如果需要拿到textfield中的text使用，同样需要将 non-breaking space替换回来。

该方法可以有效的解决问题，还能监听`UITextFieldTextDidChangeNotification`，推荐使用。

**效果演示**

<img src="https://raw.githubusercontent.com/SwiftlyFly/problemsOfiOS/master/images/SFUITextFieldInputSpaceFromRight/3%E8%87%AA%E5%AE%9A%E4%B9%89%E6%95%88%E6%9E%9C%E6%BC%94%E7%A4%BA.gif" width="50%" height="50%">

### 仍存在的问题
当我们最后输入的是空格的时候，那么当textfield不是第一响应者的时候，那么最后的空格依然不可见。如下所示：

<img src="https://raw.githubusercontent.com/SwiftlyFly/problemsOfiOS/master/images/SFUITextFieldInputSpaceFromRight/4%E4%BB%8D%E5%AD%98%E5%9C%A8%E7%9A%84%E9%97%AE%E9%A2%98.gif" width="50%" height="50%">

解决思路：可以在textfield右侧放一个view，当输入结束时，计算输入内容最后面空格的宽度，然后作为view的宽度，当textfield成为第一响应者时，令view的宽度为0。

PS：谁有更好的方法@一下哦。


###参考
基本是下面解决方案的汇总，下面有的回答也存在一些其他小问题。
[clickme](http://stackoverflow.com/questions/19569688/right-aligned-uitextfield-spacebar-does-not-advance-cursor-in-ios-7/22512184#22512184)

[源码示例SFUITextFieldInputSpaceFromRight](https://github.com/SwiftlyFly/problemsOfiOS/tree/master/SFUITextFieldInputSpaceFromRight)


