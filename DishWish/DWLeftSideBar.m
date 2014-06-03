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
    
    NSMutableArray *places = [NSMutableArray arrayWithArray:[Session sessionVariables][@"yesPlaces"]];
    
    NSUInteger i = 0;
    for(Place *place in places)
    {
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (i * 40) + 10, wd, 40)];
        nameLabel.text = [NSString stringWithFormat:@"%@", place.name];
        [self addSubview:nameLabel];
        
        i++;        
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
