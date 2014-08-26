//
//  DWRightSideBar.m
//  DishWish
//
//  Created by Will on 6/3/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "DWRightSideBar.h"
#import "DWView.h"

@implementation DWRightSideBar

@synthesize shareButton = _shareButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
        wd = (wd * 3) / 4;
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, wd, 40)];
        headerLabel.text = @"Eating With";
        [self addSubview:headerLabel];
        
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}



-(void)close {
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    
    [UIView animateWithDuration:0.2
             animations:^{
                 self.frame = CGRectMake(wd, 60, (wd * 3) / 4, ht - 60);
             }
             completion:^(BOOL finished) {
                 //[self setContentOffset:CGPointZero];
             }
     ];
    
}






/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
