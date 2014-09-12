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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.people = [[NSMutableArray alloc] init];
        
        NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
        NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
        wd = (wd * 3) / 4;
        self.peopleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, wd, 40)];
        self.peopleLabel.numberOfLines = 0;
        self.peopleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self addSubview:self.peopleLabel];
        
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
    
    self.peopleLabel.text = names;
    self.peopleLabel.frame = CGRectMake(10, 10, wd - 20, [self heightForText:names]);
    [self.peopleLabel sizeToFit];
    
    //self.contentSize = CGSizeMake(wd, (i * 40) + 60);
    self.shareButton.frame = CGRectMake(10, self.peopleLabel.frame.size.height + 20, wd - 20, 40);
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
