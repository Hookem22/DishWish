//
//  DWLeftSideBar.m
//  DishWish
//
//  Created by Will on 6/3/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "DWLeftSideBar.h"

@implementation DWLeftSideBar

@synthesize shareButton = _shareButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
        wd = (wd * 3) / 4;
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, wd, 40)];
        headerLabel.text = @"Places List";
        [self addSubview:headerLabel];
        
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}


-(void)updateLeftSideBar
{
    SavedList *currentSavedList = (SavedList *)[Session sessionVariables][@"currentSavedList"];
    [SavedList get:[NSString stringWithFormat:@"%lu", (unsigned long)currentSavedList.xrefId] completion:^(NSArray *savedLists){
        
        for(id subview in self.subviews)
        {
            if(subview != self.shareButton)
                [subview removeFromSuperview];
        }
        //[self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];

        NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
        wd = (wd * 3) / 4;

        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, wd, 40)];
        headerLabel.text = @"Places List";
        [self addSubview:headerLabel];


        NSArray *places = [NSArray arrayWithArray:[Session sessionVariables][@"yesPlaces"]];

        NSUInteger i = 1;
        for(Place *place in places)
        {
            bool voteYes = false;
            bool voteNo = false;
            for(SavedList *savedList in savedLists)
            {
                if ([savedList.yesPlaceIds rangeOfString:place.placeId].location != NSNotFound)
                    voteYes = true;
                if ([savedList.noPlaceIds rangeOfString:place.placeId].location != NSNotFound)
                    voteNo = true;
            }
            
            UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [nameButton addTarget:self action:@selector(placeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [nameButton setTitle:[NSString stringWithFormat:@"%@", place.name] forState:UIControlStateNormal];
            nameButton.frame = CGRectMake(0, (i * 40) + 10, wd, 40);
            nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            nameButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            nameButton.tag = i;
            if(voteYes && voteNo)
            {
                
            }
            else if(voteYes)
            {
                [nameButton setTitleColor:[UIColor colorWithRed:79.0/255.0 green:180.0/255.0 blue:114.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                nameButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
                
                UIImage *check = [UIImage imageNamed:@"greencheck"];
                UIImageView *checkView = [[UIImageView alloc] initWithImage:check];
                checkView.frame = CGRectMake(nameButton.titleLabel.frame.size.width + 14, (nameButton.frame.size.height / 2) - 13, 18, 24);
                [nameButton addSubview:checkView];
            }
            else if(voteNo)
            {
                [nameButton setTitleColor:[UIColor colorWithRed:229.0/255.0 green:76.0/255.0 blue:66.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                nameButton.titleLabel.font = [UIFont italicSystemFontOfSize:16.0f];
                
                UIView *strikethrough = [[UIView alloc] initWithFrame:CGRectMake(10, nameButton.frame.size.height / 2, nameButton.titleLabel.frame.size.width, 2.0f)];
                strikethrough.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:76.0/255.0 blue:66.0/255.0 alpha:1.0];
                [nameButton addSubview:strikethrough];
            }
            
            [self addSubview:nameButton];
            
            UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, nameButton.frame.size.height - 1.0f, nameButton.frame.size.width, 1)];
            bottomBorder.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
            [nameButton addSubview:bottomBorder];
            
            i++;
        }

        UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [mapButton addTarget:self action:@selector(mapClicked:) forControlEvents:UIControlEventTouchUpInside];
        [mapButton setTitle:@"Map All Places" forState:UIControlStateNormal];
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

        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [shareButton addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
        [shareButton setTitle:@"Share" forState:UIControlStateNormal];
        shareButton.frame = CGRectMake(0, (i * 40) + 10, wd, 40);
        [self addSubview:shareButton];
        i++;
        */

        self.shareButton.frame = CGRectMake(0, (i * 40) + 10, wd, 40);

        self.contentSize = CGSizeMake(wd, (i * 40) + 60);
    }];
}

-(void)placeClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;

    NSArray *places = [NSArray arrayWithArray:[Session sessionVariables][@"yesPlaces"]];

    Place *place = (Place *)places[button.tag - 1];
    
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

}

-(void)mapClicked:(id)sender
{
    [self close];
    
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    
    NSArray *places = [NSArray arrayWithArray:[Session sessionVariables][@"yesPlaces"]];
    if(places.count == 0)
        return;
    
    DWMap *map = [[DWMap alloc] initWithFrame:CGRectMake(0, 0, wd, ht) places:places];
    
    [self.superview addSubview:map];

}

/*
-(void)saveClicked:(id)sender
{
    
}

-(void)shareClicked:(id)sender
{
    [self close];
    
    //DWMessage *message = [[DWMessage alloc] init];
    //[self.superview addSubview:message.view];
    
    //NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    //NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    //DWMessage * message = [[DWMessage alloc] initWithFrame:CGRectMake(0, 0, wd, ht)];
    //[self.superview addSubview:message];
    
    NSArray *views = self.superview.subviews;
    for(id subview in views) {
        if([subview isMemberOfClass:[DWRightSideBar class]]) {
            DWRightSideBar *right = (DWRightSideBar *)subview;
            [right addList];
        }
    }
    
}
*/





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
