//
//  DWAddFriendsView.m
//  DishWish
//
//  Created by Will on 9/12/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "DWAddFriendsView.h"
#import "DWView.h"

@implementation DWAddFriendsView

@synthesize shareButton = _shareButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImage *splash = [UIImage imageNamed:@"splash"];
        UIImageView *splashView = [[UIImageView alloc] initWithImage:splash];
        
        [self addSubview:splashView];
        
        NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
        NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setTitle:@"Not yet" forState:UIControlStateNormal];
        closeButton.frame = CGRectMake(100, ht / 3 + 130, wd - 200, 30);
        closeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        closeButton.titleLabel.textColor = [UIColor whiteColor];
        closeButton.layer.backgroundColor =  [UIColor colorWithRed:19.0/255.0 green:128.0/255.0 blue:249.0/250.0 alpha:1.0].CGColor;
        closeButton.layer.cornerRadius = 5.0;
        closeButton.titleLabel.textAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
    }
    return self;
}

-(void)close
{
    bool loaded = false;
    for(id subview in self.superview.subviews) {
        if([subview isMemberOfClass:[DWDraggableView class]])
            loaded = true;
    }
    
    if(!loaded)
        return;
    
    [UIView animateWithDuration:0.3
         animations:^{
            self.alpha = 0.0;
         }
         completion:^(BOOL finished){
             [(DWView *)self.superview addNavBar];
             [self removeFromSuperview];
         }];
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
