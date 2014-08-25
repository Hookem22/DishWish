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
        
        [self moveUpYesPlaces:(NSArray *)savedLists];
        
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
            NSMutableArray *voteYes = [[NSMutableArray alloc] init];
            NSMutableArray *voteNo = [[NSMutableArray alloc] init];
            for(SavedList *savedList in savedLists)
            {
                if ([savedList.yesPlaceIds rangeOfString:place.placeId].location != NSNotFound)
                {
                    if(savedList.userName.length > 0)
                        [voteYes addObject:[savedList.userName substringToIndex:1]];
                }
                if ([savedList.noPlaceIds rangeOfString:place.placeId].location != NSNotFound)
                {
                    if(savedList.userName.length > 0)
                        [voteNo addObject:[savedList.userName substringToIndex:1]];
                }
            }
            
            UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [nameButton addTarget:self action:@selector(placeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [nameButton setTitle:[NSString stringWithFormat:@"%@", place.name] forState:UIControlStateNormal];
            nameButton.frame = CGRectMake(0, (i * 40) + 10, wd, 40);

            nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            nameButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            nameButton.tag = i;
            if(voteYes.count > voteNo.count)
            {
                [nameButton setTitleColor:[UIColor colorWithRed:79.0/255.0 green:180.0/255.0 blue:114.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                nameButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
                
                /*
                UIImage *check = [UIImage imageNamed:@"greencheck"];
                UIImageView *checkView = [[UIImageView alloc] initWithImage:check];
                checkView.frame = CGRectMake(nameButton.titleLabel.frame.size.width + 14, (nameButton.frame.size.height / 2) - 13, 18, 24);
                [nameButton addSubview:checkView];
                 */
            }
            else if(voteNo.count > voteYes.count)
            {
                [nameButton setTitleColor:[UIColor colorWithRed:229.0/255.0 green:76.0/255.0 blue:66.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                nameButton.titleLabel.font = [UIFont italicSystemFontOfSize:16.0f];
                
                UIView *strikethrough = [[UIView alloc] initWithFrame:CGRectMake(10, nameButton.frame.size.height / 2, nameButton.titleLabel.frame.size.width, 2.0f)];
                strikethrough.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:76.0/255.0 blue:66.0/255.0 alpha:1.0];
                [nameButton addSubview:strikethrough];
            }
            
            [self buildYesNo:nameButton voteYes:voteYes voteNo:voteNo];
            
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

-(void)moveUpYesPlaces:(NSArray *)savedLists
{
    NSArray *places = [NSArray arrayWithArray:[Session sessionVariables][@"Places"]];
    NSUInteger currentId = [[[Session sessionVariables] objectForKey:@"CurrentId"] intValue];
    
    NSLog([NSString stringWithFormat:@"Places %d", places.count]);
    NSLog([NSString stringWithFormat:@"Current %d", currentId]);
    
    NSMutableArray *votedPlaces = [[NSMutableArray alloc] init];
    for(SavedList *savedList in savedLists)
    {
        NSArray *yeses = [savedList.yesPlaceIds componentsSeparatedByString:@","];
        for(NSString *yes in yeses)
        {
            if(![votedPlaces containsObject:yes])
               [votedPlaces addObject:yes];
        }
        NSArray *nos = [savedList.noPlaceIds componentsSeparatedByString:@","];
        for(NSString *no in nos)
        {
            if(![votedPlaces containsObject:no])
                [votedPlaces addObject:no];
        }
    }
    
    NSMutableArray *newPlaces = [[NSMutableArray alloc] init];
    NSUInteger i = -1;
    for(Place *place in places)
    {
        i++;
        if(i <= currentId + 1 || ![votedPlaces containsObject:place.placeId])
        {
            [newPlaces addObject:place];
        }
        else
        {
            [newPlaces insertObject:place atIndex:currentId + 1];
        }
        
    }
    
    [[Session sessionVariables] setObject:newPlaces forKey:@"Places"];
    
    
    NSLog([NSString stringWithFormat:@"Yes %d", newPlaces.count]);
}

-(void)buildYesNo:(UIButton *)button voteYes:(NSArray *)voteYes voteNo:(NSArray *)voteNo
{
    if(voteYes.count + voteNo.count == 0)
        return;
    
    UIColor *green = [UIColor colorWithRed:79.0/255.0 green:180.0/255.0 blue:114.0/255.0 alpha:1.0];
    UIColor *red = [UIColor colorWithRed:229.0/255.0 green:76.0/255.0 blue:66.0/255.0 alpha:1.0];
    
    if(voteYes.count + voteNo.count == 1)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width - 40, 0, 40, button.frame.size.height)];
        if(voteYes.count == 1)
        {
            [label setText:voteYes[0]];
            [label setBackgroundColor:green];
        }
        else
        {
            [label setText:voteNo[0]];
            [label setBackgroundColor:red];
        }
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont boldSystemFontOfSize:20.0f]];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
    }
    else if(voteYes.count + voteNo.count == 2)
    {
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width - 40, 0, 19, button.frame.size.height)];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width - 20, 0, 20, button.frame.size.height)];
        if(voteYes.count == 2)
        {
            [label1 setText:voteYes[0]];
            [label1 setBackgroundColor:green];
            
            [label2 setText:voteYes[1]];
            [label2 setBackgroundColor:green];
        }
        else if(voteNo.count == 2)
        {
            [label1 setText:voteNo[0]];
            [label1 setBackgroundColor:red];
            
            [label2 setText:voteNo[1]];
            [label2 setBackgroundColor:red];
        }
        else
        {
            [label1 setText:voteYes[0]];
            [label1 setBackgroundColor:green];
            
            [label2 setText:voteNo[0]];
            [label2 setBackgroundColor:red];
        }

        [label1 setTextColor:[UIColor whiteColor]];
        [label1 setFont:[UIFont boldSystemFontOfSize:16.0f]];
        label1.textAlignment = NSTextAlignmentCenter;
        
        [label2 setTextColor:[UIColor whiteColor]];
        [label2 setFont:[UIFont boldSystemFontOfSize:16.0f]];
        label2.textAlignment = NSTextAlignmentCenter;
        
        [button addSubview:label1];
        [button addSubview:label2];
    }
    else if(voteYes.count + voteNo.count == 3)
    {
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width - 40, 0, 19, button.frame.size.height)];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width - 20, 0, 20, (button.frame.size.height / 2) - 1)];
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width - 20, button.frame.size.height / 2, 20, button.frame.size.height / 2)];
        if(voteYes.count == 3)
        {
            [label1 setText:voteYes[0]];
            [label1 setBackgroundColor:green];
            
            [label2 setText:voteYes[1]];
            [label2 setBackgroundColor:green];
            
            [label3 setText:voteYes[2]];
            [label3 setBackgroundColor:green];
        }
        else if(voteYes.count == 2)
        {
            [label1 setText:voteYes[0]];
            [label1 setBackgroundColor:green];
            
            [label2 setText:voteYes[1]];
            [label2 setBackgroundColor:green];
            
            [label3 setText:voteNo[0]];
            [label3 setBackgroundColor:red];
        }
        else if(voteYes.count == 1)
        {
            [label1 setText:voteNo[0]];
            [label1 setBackgroundColor:red];
            
            [label2 setText:voteYes[0]];
            [label2 setBackgroundColor:green];
            
            [label3 setText:voteNo[1]];
            [label3 setBackgroundColor:red];
        }
        else if(voteYes.count == 0)
        {
            [label1 setText:voteNo[0]];
            [label1 setBackgroundColor:red];
            
            [label2 setText:voteNo[1]];
            [label2 setBackgroundColor:red];
            
            [label3 setText:voteNo[2]];
            [label3 setBackgroundColor:red];
        }
        
        
        [label1 setTextColor:[UIColor whiteColor]];
        [label1 setFont:[UIFont boldSystemFontOfSize:14.0f]];
        label1.textAlignment = NSTextAlignmentCenter;
        
        [label2 setTextColor:[UIColor whiteColor]];
        [label2 setFont:[UIFont boldSystemFontOfSize:14.0f]];
        label2.textAlignment = NSTextAlignmentCenter;
        
        [label3 setTextColor:[UIColor whiteColor]];
        [label3 setFont:[UIFont boldSystemFontOfSize:14.0f]];
        label3.textAlignment = NSTextAlignmentCenter;
        
        [button addSubview:label1];
        [button addSubview:label2];
        [button addSubview:label3];
    }
    else
    {
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width - 40, 0, 19, (button.frame.size.height / 2) - 1)];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width - 40, button.frame.size.height / 2, 19, button.frame.size.height / 2)];
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width - 20, 0, 20, (button.frame.size.height / 2) - 1)];
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width - 20, button.frame.size.height / 2, 20, button.frame.size.height / 2)];
        if(voteYes.count >= 4)
        {
            [label1 setText:voteYes[0]];
            [label1 setBackgroundColor:green];
            
            [label2 setText:voteYes[1]];
            [label2 setBackgroundColor:green];
            
            [label3 setText:voteYes[2]];
            [label3 setBackgroundColor:green];
            
            [label4 setText:voteYes[3]];
            [label4 setBackgroundColor:green];
        }
        if(voteYes.count == 3)
        {
            [label1 setText:voteYes[0]];
            [label1 setBackgroundColor:green];
            
            [label2 setText:voteYes[1]];
            [label2 setBackgroundColor:green];
            
            [label3 setText:voteYes[2]];
            [label3 setBackgroundColor:green];
            
            [label4 setText:voteNo[0]];
            [label4 setBackgroundColor:red];
        }
        else if(voteYes.count == 2)
        {
            [label1 setText:voteYes[0]];
            [label1 setBackgroundColor:green];
            
            [label2 setText:voteNo[0]];
            [label2 setBackgroundColor:red];
            
            [label3 setText:voteNo[1]];
            [label3 setBackgroundColor:red];
            
            [label4 setText:voteYes[1]];
            [label4 setBackgroundColor:green];
        }
        else if(voteYes.count == 1)
        {
            [label1 setText:voteNo[0]];
            [label1 setBackgroundColor:red];
            
            [label2 setText:voteNo[1]];
            [label2 setBackgroundColor:red];
            
            [label3 setText:voteYes[0]];
            [label3 setBackgroundColor:green];
            
            [label4 setText:voteNo[2]];
            [label4 setBackgroundColor:red];
        }
        else if(voteYes.count == 0)
        {
            [label1 setText:voteNo[0]];
            [label1 setBackgroundColor:red];
            
            [label2 setText:voteNo[1]];
            [label2 setBackgroundColor:red];
            
            [label3 setText:voteNo[2]];
            [label3 setBackgroundColor:red];
            
            [label4 setText:voteNo[3]];
            [label4 setBackgroundColor:red];
        }
        
        [label1 setTextColor:[UIColor whiteColor]];
        [label1 setFont:[UIFont boldSystemFontOfSize:14.0f]];
        label1.textAlignment = NSTextAlignmentCenter;
        
        [label2 setTextColor:[UIColor whiteColor]];
        [label2 setFont:[UIFont boldSystemFontOfSize:14.0f]];
        label2.textAlignment = NSTextAlignmentCenter;
        
        [label3 setTextColor:[UIColor whiteColor]];
        [label3 setFont:[UIFont boldSystemFontOfSize:14.0f]];
        label3.textAlignment = NSTextAlignmentCenter;
        
        [label4 setTextColor:[UIColor whiteColor]];
        [label4 setFont:[UIFont boldSystemFontOfSize:14.0f]];
        label4.textAlignment = NSTextAlignmentCenter;
        
        [button addSubview:label1];
        [button addSubview:label2];
        [button addSubview:label3];
        [button addSubview:label4];
    }
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
