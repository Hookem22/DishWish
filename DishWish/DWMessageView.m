//
//  DWMessageView.m
//  DishWish
//
//  Created by Will on 6/26/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "DWMessageView.h"

@interface DWMessageView ()

-(void)showAddressBook;

@end

@implementation DWMessageView


- (id)init{
    self = [super init];
    if (self) {

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 95, 40, 40)];
    [mapButton setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(showAddressBook) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mapButton];
    
    
    return self;
}

-(void)showAddressBook {
    ABPeoplePickerNavigationController *objPeoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    [objPeoplePicker setPeoplePickerDelegate:self];
    
    DWMessage *message = [[DWMessage alloc] init];
    [message presentModalViewController:objPeoplePicker animated:YES];
}

@end
