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
        
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}


-(void)updateLeftSideBar
{
    [self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
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
        bottomBorder.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
        [nameButton addSubview:bottomBorder];
        
        i++;
    }
    
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mapButton addTarget:self action:@selector(mapClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mapButton setTitle:@"Map All" forState:UIControlStateNormal];
    mapButton.frame = CGRectMake(0, (i * 40) + 10, wd, 40);
    [self addSubview:mapButton];
    i++;
    /*
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveButton addTarget:self action:@selector(saveClicked:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    saveButton.frame = CGRectMake(0, (i * 40) + 10, wd, 40);
    [self addSubview:saveButton];
    i++;
    */
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareButton addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setTitle:@"Share" forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(0, (i * 40) + 10, wd, 40);
    [self addSubview:shareButton];
    i++;
    
    self.contentSize = CGSizeMake(wd, (i * 40) + 20);
    
}

-(void)placeClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;

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
         }
         completion:^(BOOL finished) {
             //[self setContentOffset:CGPointZero];
         }
     ];

}

-(void)loadCard:(Place *)place
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    DWDraggableView *drag = [[DWDraggableView alloc] initWithFrame:CGRectMake(0, 0, wd, ht-40) place:place async:NO];

    [self.superview addSubview:drag];
    [self.superview sendSubviewToBack:drag];
    [drag animateImageToFront:YES];

   
    /* Load Card already present
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
    */
}

-(void)mapClicked:(id)sender
{
    [self close];
    
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    
    NSArray *places = [NSArray arrayWithArray:[Session sessionVariables][@"yesPlaces"]];
    DWMap *map = [[DWMap alloc] initWithFrame:CGRectMake(0, 0, wd, ht) places:places];
    
    [self.superview addSubview:map];
    
    /*
     [UIView animateWithDuration:0.3
          animations:^{
              self.mapScreen.frame = self.bounds;
              
              CGRect bounds = CGRectMake(self.bounds.origin.x, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
              self.mapScreen = [[DWMap alloc] initWithFrame:bounds places:places];
              [self addSubview:self.mapScreen];
          }
          completion:^(BOOL finished){
              [self.superview bringSubviewToFront:self];
          }];
    */

}

-(void)saveClicked:(id)sender
{
    
}

-(void)shareClicked:(id)sender
{
    [self close];
    
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    DWMessage * message = [[DWMessage alloc] initWithFrame:CGRectMake(0, 0, wd, ht)];
    [self.superview addSubview:message];
    
    NSArray *views = self.superview.subviews;
    for(id subview in views) {
        if([subview isMemberOfClass:[DWRightSideBar class]]) {
            DWRightSideBar *right = (DWRightSideBar *)subview;
            [right addList];
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
