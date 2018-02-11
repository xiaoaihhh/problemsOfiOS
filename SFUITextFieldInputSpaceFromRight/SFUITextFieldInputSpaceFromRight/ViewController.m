//
//  ViewController.m
//  SFUITextFieldInputSpaceFromRight
//
//  Created by xiaoaihhh on 16/7/7.
//  Copyright © 2016年 xiaoaihhh. All rights reserved.
//

#import "ViewController.h"
#import "SFTextField.h"

@interface ViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.textField.delegate = self;
//    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
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

    /* 在输入单个字符或者粘贴内容时做如下处理，已确定光标应该停留的正确位置，没有下段从字符中间插入或者粘贴光标位置会出错 */
    // 首先使用 non-breaking space 代替默认输入的@“ ”空格
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@"\u00a0"];
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //确定输入或者粘贴字符后光标位置
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextPosition *cursorLoc = [textField positionFromPosition:beginning offset:range.location+string.length];
    // 选中文本起使位置和结束为止设置同一位置
    UITextRange *textRange = [textField textRangeFromPosition:cursorLoc toPosition:cursorLoc];
    // 选中字符范围（由于textRange范围的起始结束位置一样所以并没有选中字符）
    [textField setSelectedTextRange:textRange];
    
    return NO;
    
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    // 如果需要拿到textfield中的text使用，在使用前记得将 non-breaking space替换回来，但是最好不要在该方法中替换，因为如果末尾有空格的话，在编辑结束时会发现最后的空格还是显示不了，所以只能让textField以 non-breaking space的形式显示，在内部使用使替换回来
////    [textField.text stringByReplacingOccurrencesOfString:@"\u00a0" withString:@" "];
//}



@end
