//
//  DWRightSideBar.m
//  DishWish
//
//  Created by Will on 6/3/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "DWRightSideBar.h"

@interface DWRightSideBar ()

@property (nonatomic, strong) UILabel *peopleLabel;
@end

@implementation DWRightSideBar

@synthesize shareButton = _shareButton;
@synthesize people = _people;
@synthesize topBackground = _topBackground;
@synthesize topBorder = _topBorder;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.topBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:self.topBackground];
        
        self.topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:self.topBorder];
        
        
        self.people = [[NSMutableArray alloc] init];
        
        NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
        NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
        wd = (wd * 3) / 4;
        self.peopleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, wd, 40)];
        self.peopleLabel.numberOfLines = 0;
        self.peopleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self addSubview:self.peopleLabel];
        
        [self bringSubviewToFront:self.shareButton];
        
        UIView *bottomBackground = [[UIView alloc] initWithFrame:CGRectMake(0, ht - 140, wd, 140)];
        bottomBackground.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
        [self addSubview:bottomBackground];
        
        UIView *bottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(0, ht - 100, wd, 2)];
        bottomBorder1.backgroundColor = [UIColor blackColor];
        [self addSubview:bottomBorder1];
        
        UIView *bottomBorder2 = [[UIView alloc] initWithFrame:CGRectMake(0, ht - 140, wd, 2)];
        bottomBorder2.backgroundColor = [UIColor blackColor];
        [self addSubview:bottomBorder2];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, ht - 135, wd - 70, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.font = [UIFont systemFontOfSize:15];
        textField.placeholder = @"enter text";
        [self addSubview:textField];
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [sendButton setTitle:@"Send" forState:UIControlStateNormal];
        sendButton.frame = CGRectMake(wd - 60, ht - 135, 50, 30);
        [sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendButton];
        
        UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [previousButton setTitle:@"Previous Lists" forState:UIControlStateNormal];
        previousButton.frame = CGRectMake(0, ht - 100, wd, 40);
        [previousButton addTarget:self action:@selector(previousLists) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:previousButton];
        
        
//        NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
//        wd = (wd * 3) / 4;
//        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, wd, 40)];
//        headerLabel.text = @"Eating With";
//        [self addSubview:headerLabel];
        
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

-(void)addPerson:(NSDictionary *)person
{
    [self.people addObject:person];
    
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    wd = (wd * 3) / 4;
    
    NSString *names = self.peopleLabel.text.length == 0 ? [person valueForKey:@"name"] : [NSString stringWithFormat:@"%@, %@", self.peopleLabel.text, [person valueForKey:@"name"]];
    
    self.topBackground.frame = CGRectMake(0, 0, wd, [self heightForText:names] + 60);
    self.topBackground.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    
    self.topBorder.frame = CGRectMake(0, [self heightForText:names] + 60, wd, 2);
    self.topBorder.backgroundColor = [UIColor blackColor];
    
    self.peopleLabel.text = names;
    self.peopleLabel.frame = CGRectMake(10, 60, wd - 20, [self heightForText:names]);
    [self.peopleLabel sizeToFit];
    
    //self.contentSize = CGSizeMake(wd, (i * 40) + 60);
    self.shareButton.frame = CGRectMake(10, 10, wd - 20, 40);
    [self.shareButton setTitle:@"Add More Friends to Eat With" forState:UIControlStateNormal];
    
    [self addTextingUI];
}

- (CGFloat)heightForText:(NSString *)text
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    wd = (wd * 3) / 4 - 20;
    
    UIFont *font = [UIFont systemFontOfSize:16];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{ NSFontAttributeName: font }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){wd, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    //CGSize labelSize = [text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    CGSize labelSize = rect.size;
    CGFloat height = labelSize.height + 10;
    return height;
}

-(void)addTextingUI
{
    
}

-(void)sendMessage
{
    
}

-(void)previousLists
{

    bool exists = false;
    for(id subview in self.superview.subviews) {
        if([subview isMemberOfClass:[DWPreviousSideBar class]])
        {
            exists = true;
            DWPreviousSideBar *prev = (DWPreviousSideBar *)subview;
            [self openPreviousLists:prev];
        }
    }
    if(!exists)
    {
        NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
        NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
        
        DWPreviousSideBar *prev = [[DWPreviousSideBar alloc] initWithFrame:CGRectMake(wd, 60, (wd * 3)/4, ht - 60)];
        [SavedList getByUser:^(NSArray *savedLists) {
            [prev populateLists:savedLists];
            [self.superview addSubview:prev];
            [self openPreviousLists:prev];
        }];
    }
}

-(void)openPreviousLists:(DWPreviousSideBar *)prev
{
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    
    [self.superview bringSubviewToFront:prev];
    
    [UIView animateWithDuration:0.2
         animations:^{
             prev.frame = CGRectMake(wd /4, 60, (wd * 3)/4, ht - 60);
         }
         completion:^(BOOL finished){
             
         }];
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
