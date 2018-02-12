# 问题

UITextField作为输入常用控件，但是问题却很多，本篇主要用于解决以下两个问题。

- 输入时文字位置自动下移；
- 自动布局时横屏转竖屏左侧多出大片空白；


当设置`masksToBounds = YES`时，如果文字长度超过了TextField的宽度，那么文字位置就会下移，如下图：



当设置`masksToBounds = NO`时，如果文字长度超过了TextField的宽度且输入速度过快，那么TextField左侧会有文字闪动的问题，且删除文字时文字也会下移，如下图：



当文字长度超过了TextField的宽度由竖屏变为横屏时，那么TextField左侧会有大片空白，如下图：

<img src="https://raw.githubusercontent.com/xiaoaihhh/problemsOfiOS/master/images/HHHTextField/TextField结构.png" width="50%" height="50%" title="图3">



# 原因分析

UITextField结构如下图，当编辑时会成了`UIFieldEditor`，`UIFieldEditor`是继承UIScrollView，`UIFieldEditor`有一个子视图`_UIFieldEditorContentView`, `_UIFieldEditorContentView`用于展示文字和光标（`UITextSelectionView`）。



当编辑时，`_UIFieldEditorContentView`的frame会动态改变，`UIFieldEditor`的`contentOffset`也会改变，因此就出现了文字下移的问题。



# 解决方法

因此要防止文字下移，必须设置`UIFieldEditor`的contentOffset的y值为0，如果想解决第二张图中输入较快时左侧闪动，则需设置`masksToBounds = YES`（使用者可自己设置）。

说明：即使设置了`UIFieldEditor`的contentOffset的y值为0，如果此时设置`masksToBounds = YES`，那么光标下移问题依然存在，这是由于`_UIFieldEditorContentView`的frame的高度和y值改变导致的，因此需要动态调整`UIFieldEditor`在y方向的偏移量。

为了解决前三张图中问题，首先定义`HHHTextField`继承自UITextField，在`layoutSubviews`中动态进行布局，代码如下：

```
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
```



[源码示例HHHTextField](https://github.com/xiaoaihhh/problemsOfiOS/tree/master/HHHTextField)