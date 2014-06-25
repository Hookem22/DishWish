//
//  DWMessage.m
//  DishWish
//
//  Created by Will on 6/25/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "DWMessage.h"

@implementation DWMessage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, frame.size.width - 20, 40)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.font = [UIFont systemFontOfSize:15];
        textField.placeholder = @"Add friends";
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyDone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.delegate = self;
        [self addSubview:textField];
        
        _addressBookController = [[ABPeoplePickerNavigationController alloc] init];
        [_addressBookController setPeoplePickerDelegate:self];
        [self presentViewController:_addressBookController animated:YES completion:nil];

        
    }
    return self;
}

@end
