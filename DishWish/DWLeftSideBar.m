//
//  DWLeftSideBar.m
//  DishWish
//
//  Created by Will on 6/3/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "DWLeftSideBar.h"

@implementation DWLeftSideBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


-(void)updateLeftSideBar
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    wd = (wd * 3) / 4;
    
    NSArray *places = [NSArray arrayWithArray:[Session sessionVariables][@"yesPlaces"]];
    
    NSUInteger i = 0;
    for(Place *place in places)
    {
        /*
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (i * 40) + 10, wd, 40)];
        nameLabel.text = [NSString stringWithFormat:@"%@", place.name];
        [self addSubview:nameLabel];
        */
        /*
        UIButton *nameButton = [[UIButton alloc] initWithFrame:CGRectMake(10, (i * 40) + 10, wd, 40)];
        //[mapButton addTarget:self action:@selector(loadMap) forControlEvents:UIControlEventTouchUpInside];
        [nameButton setTitle:[NSString stringWithFormat:@"%@", place.name] forState:UIControlStateNormal];
        [self addSubview:nameButton];
        */
        
        UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [nameButton addTarget:self action:@selector(placeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [nameButton setTitle:[NSString stringWithFormat:@"%@", place.name] forState:UIControlStateNormal];
        nameButton.frame = CGRectMake(0, (i * 40) + 10, wd, 40);
        nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        nameButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        nameButton.tag = i;
        [self addSubview:nameButton];
        
        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, nameButton.frame.size.height - 1.0f, nameButton.frame.size.width, 1)];
        bottomBorder.backgroundColor = [UIColor blackColor];
        [nameButton addSubview:bottomBorder];
        
        i++;
    }
    
    
    
}

-(void)placeClicked:(id)selector
{
    UIButton *button = (UIButton *)selector;
    
    NSArray *places = [NSArray arrayWithArray:[Session sessionVariables][@"yesPlaces"]];
    
    Place *place = (Place *)places[button.tag];
    
    [self close];
    [self loadCard:place];
}

-(void)close {
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;

    [UIView animateWithDuration:0.2
         animations:^{
             self.frame = CGRectMake(0, 60, 0, ht - 60);
         }];

}

-(void)loadCard:(Place *)place
{
    
    NSArray *views = self.superview.subviews;
    for(id subview in views) {
        if([subview isMemberOfClass:[DWDraggableView class]]) {
            DWDraggableView *drag = (DWDraggableView *)subview;
            Place *p = drag.place;
            NSString *pId = p.placeId;
            
            if(pId == place.placeId)
            {
                [drag animateImageToFront:YES];
                break;
            }
        }
    }
    
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
