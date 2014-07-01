//
//  InstructionsView.m
//  DishWish
//
//  Created by Will on 6/30/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "InstructionsView.h"

@implementation InstructionsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75];
        
        NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
        NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
        
        UIImage *swipe = [UIImage imageNamed:@"swipeRight"];
        UIImageView *swipeView = [[UIImageView alloc] initWithImage:swipe];
        swipeView.frame = CGRectMake(wd / 3, 100, swipeView.frame.size.width, swipeView.frame.size.height);
        [self addSubview:swipeView];
        
        UILabel *swipeLabel = [[UILabel alloc] initWithFrame:CGRectMake(wd / 6, 210, (wd * 2) /3, 100)];
        swipeLabel.textColor = [UIColor whiteColor];
        swipeLabel.text = @"Swipe right to save this place, Swipe left to skip it.";
        swipeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        swipeLabel.numberOfLines = 2;
        [self addSubview:swipeLabel];
        
        UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(wd - 100, 40, 80, 40)];
        //sendButton.frame = CGRectMake(wd - 70, 188, 60, 40);
        dismissButton.backgroundColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        dismissButton.layer.cornerRadius = 5.0;
        [dismissButton setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        [dismissButton setTitle:@"Got it" forState:UIControlStateNormal];
        [dismissButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dismissButton];
        
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(animatedClose)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

-(void)animatedClose
{
    
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    [UIView animateWithDuration:0.4
         animations:^{
             self.frame = CGRectMake(wd, 0, wd, ht);
         }
         completion:^(BOOL finished){
             [self close];
         }];
}

-(void)close
{
    [self removeFromSuperview];
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
