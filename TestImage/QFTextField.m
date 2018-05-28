//
//  QFTextField.m
//  TestImage
//
//  Created by dqf on 2017/10/15.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "QFTextField.h"

@interface QFTextField () <UITextFieldDelegate>

@end


@implementation QFTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UITextField *textField = [[UITextField alloc] init];
    [textField setFrame:CGRectMake(10, 100, 150, 44)];
    [textField setBackgroundColor:[UIColor redColor]];
    [textField setDelegate:self];
    [self addSubview:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"%@",textField.text);
    return YES;
}

@end
