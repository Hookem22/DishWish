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

@property (nonatomic, strong) NSMutableArray *people;
@property (nonatomic, strong) UIView *topBackground;
@property (nonatomic, strong) UIView *topBorder;

@property (nonatomic, strong) UITextField *messageTextField;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIView *bottomBackground;
@property (nonatomic, strong) UIView *bottomBorder;

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) UIView *messageView;

@end

@implementation DWRightSideBar

@synthesize shareButton = _shareButton;

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
        self.messages = [[NSMutableArray alloc] init];
        
        NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
        NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
        wd = (wd * 3) / 4;
        self.peopleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, wd, 40)];
        self.peopleLabel.numberOfLines = 0;
        self.peopleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self addSubview:self.peopleLabel];
        
        [self bringSubviewToFront:self.shareButton];
        
        self.messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 200)];
        [self addSubview:self.messageView];
        
        self.bottomBackground = [[UIView alloc] initWithFrame:CGRectMake(0, ht - 140, wd, 140)];
        self.bottomBackground.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        [self addSubview:self.bottomBackground];
        
        UIView *bottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(0, ht - 100, wd, 1)];
        bottomBorder1.backgroundColor = [UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0];
        [self addSubview:bottomBorder1];
        
        self.bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, ht - 140, wd, 1)];
        self.bottomBorder.backgroundColor = [UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0];
        [self addSubview:self.bottomBorder];
        
        self.messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, ht - 135, wd - 70, 30)];
        self.messageTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.messageTextField.font = [UIFont systemFontOfSize:15];
        self.messageTextField.placeholder = @"Message";
        [self addSubview:self.messageTextField];
        
        self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
        self.sendButton.frame = CGRectMake(wd - 60, ht - 135, 50, 30);
        [self.sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sendButton];
        
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)addPerson:(NSDictionary *)person
{
    [self.people addObject:person];
    
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    wd = (wd * 3) / 4;
    
    NSString *names = self.peopleLabel.text.length == 0 ? [person valueForKey:@"name"] : [NSString stringWithFormat:@"%@, %@", self.peopleLabel.text, [person valueForKey:@"name"]];
    
    self.topBackground.frame = CGRectMake(0, 0, wd, [self heightForText:names width:wd - 20 fontSize:16] + 60);
    self.topBackground.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    
    self.topBorder.frame = CGRectMake(0, [self heightForText:names width:wd - 20 fontSize:16] + 60, wd, 1);
    self.topBorder.backgroundColor = [UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0];
    
    self.peopleLabel.text = names;
    self.peopleLabel.frame = CGRectMake(10, 60, wd - 20, [self heightForText:names width:wd - 20 fontSize:16]);
    [self.peopleLabel sizeToFit];
    
    //self.contentSize = CGSizeMake(wd, (i * 40) + 60);
    self.shareButton.frame = CGRectMake(10, 10, wd - 20, 40);
    [self.shareButton setTitle:@"Add More Friends to Eat With" forState:UIControlStateNormal];
}

- (CGFloat)heightForText:(NSString *)text width:(NSUInteger)width fontSize:(NSUInteger)fontSize
{
    //NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    //wd = (wd * 3) / 4 - 20;
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{ NSFontAttributeName: font }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    //CGSize labelSize = [text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    CGSize labelSize = rect.size;
    CGFloat height = labelSize.height + 10;
    return height;
}

-(void)sendMessage
{
    if(self.messageTextField.text.length > 0)
    {

//        [Message add:self.messageTextField.text completion:^(Message *newMessage)
//         {
//
//         }];
        
        [self populateMessages:self.messageTextField.text];
        [self.messageTextField setText:@""];
        //[self.messages addObject:message];
    }
    
    [self endEditing:YES];
}

-(void)populateMessages:(NSString *)message
{
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    wd = (wd * 3) / 4;
    
    [self.messageView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    for(Message *message in self.messages)
    {
        NSLog(message.message);
    }
    
    if(message.length > 0)
    {
        [self.messageView addSubview:[self addTextView:message from:@"" date:@"Now" isMe:YES]];
    }
    
    self.messageView.frame = CGRectMake(0, self.topBackground.frame.size.height + 10, wd, ht - 200);
}

-(UIView *)addTextView:(NSString *)message from:(NSString *)from date:(NSString *)date isMe:(BOOL)isMe
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    wd = (wd * 3) / 4;
    
    if(isMe)
    {
        UIView *view = [[UIView alloc] init];

        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(wd / 3, 0, (wd * 2) / 3 - 10, 15)];
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.text = date;
        dateLabel.textAlignment = NSTextAlignmentRight;
        [view addSubview:dateLabel];
        
        /*
         UIView *wrapView = [[UIView alloc] initWithFrame: CGRectMake(10, 140, wd - 90, 80)];
         //wrapView.layer.backgroundColor = [UIColor colorWithRed:19.0/255.0 green:128.0/255.0 blue:249.0/250.0 alpha:1.0].CGColor;
         wrapView.layer.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/250.0 alpha:0.26].CGColor;
         wrapView.layer.cornerRadius = 5.0;
         wrapView.layer.borderColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/250.0 alpha:1.0].CGColor;
         [self.view addSubview:wrapView];
         */

        UITextView *newTextbox = [[UITextView alloc] initWithFrame:CGRectMake(wd / 3, 18, (wd * 2) / 3 - 5, [self heightForText:message width:(wd * 2) / 3 - 5 fontSize:14] + 10)];
        newTextbox.textColor = [UIColor whiteColor];
        newTextbox.font = [UIFont systemFontOfSize:14];
        newTextbox.backgroundColor = [UIColor colorWithRed:19.0/255.0 green:128.0/255.0 blue:249.0/250.0 alpha:1.0];
        //newTextbox.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/250.0 alpha:0.25];
        [newTextbox.layer setBorderColor:[[[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/250.0 alpha:1.0] colorWithAlphaComponent:1.0] CGColor]];
        [newTextbox.layer setBorderWidth:1.0];
        newTextbox.layer.cornerRadius = 15;
        newTextbox.clipsToBounds = YES;
        newTextbox.text = message;
        
        [view addSubview:newTextbox];
        return view;
    }
    else
    {
        
        UIView *view = [[UIView alloc] init];
        if(from.length > 0)
        {
            UILabel *fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, wd - 5, 15)];
            fromLabel.font = [UIFont systemFontOfSize:12];
            fromLabel.text = [NSString stringWithFormat:@"%@ - %@", from, date];
            [view addSubview:fromLabel];
        }
        else
        {
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, wd - 5, 15)];
            dateLabel.font = [UIFont systemFontOfSize:12];
            dateLabel.text = date;
            [view addSubview:dateLabel];
        }
        
        UITextView *newTextbox = [[UITextView alloc] initWithFrame:CGRectMake(5, 18, (wd * 2) / 3 - 5, [self heightForText:message width:(wd * 2) / 3 - 5 fontSize:14] + 10)];
        //newTextbox.textColor = [UIColor whiteColor];
        newTextbox.font = [UIFont systemFontOfSize:14];
        //newTextbox.backgroundColor = [UIColor colorWithRed:19.0/255.0 green:128.0/255.0 blue:249.0/250.0 alpha:1.0];
        newTextbox.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/250.0 alpha:0.25];
        [newTextbox.layer setBorderColor:[[[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/250.0 alpha:1.0] colorWithAlphaComponent:1.0] CGColor]];
        [newTextbox.layer setBorderWidth:1.0];
        newTextbox.layer.cornerRadius = 15;
        newTextbox.clipsToBounds = YES;
        newTextbox.text = message;
        
        [view addSubview:newTextbox];
        return view;
    }
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

-(void)keyboardWillShow:(NSNotification *)notification
{
    // I'll try to make my text field 20 pixels above the top of the keyboard
    // To do this first we need to find out where the keyboard will be.
    
    NSValue *keyboardEndFrameValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = [keyboardEndFrameValue CGRectValue];
    
    // When we move the textField up, we want to match the animation duration and curve that
    // the keyboard displays. So we get those values out now
    
    NSNumber *animationDurationNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = [animationDurationNumber doubleValue];
    
    NSNumber *animationCurveNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = [animationCurveNumber intValue];
    
    // UIView's block-based animation methods anticipate not a UIVieAnimationCurve but a UIViewAnimationOptions.
    // We shift it according to the docs to get this curve.
    
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    
    // Now we set up our animation block.
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationOptions
                     animations:^{
                         CGRect textFieldFrame = self.messageTextField.frame;
                         textFieldFrame.origin.y = keyboardEndFrame.origin.y - 100;
                         self.messageTextField.frame = textFieldFrame;
                         
                         CGRect sendButtonFrame = self.sendButton.frame;
                         sendButtonFrame.origin.y = keyboardEndFrame.origin.y - 100;
                         self.sendButton.frame = sendButtonFrame;
                         
                         CGRect bottomBorderFrame = self.bottomBorder.frame;
                         bottomBorderFrame.origin.y = keyboardEndFrame.origin.y - 110;
                         self.bottomBorder.frame = bottomBorderFrame;
                         
                         CGRect bottomBackgroundFrame = self.bottomBackground.frame;
                         bottomBackgroundFrame.origin.y = keyboardEndFrame.origin.y - 110;
                         self.bottomBackground.frame = bottomBackgroundFrame;
                     }
                     completion:^(BOOL finished) {}];
    
}


-(void)keyboardWillHide:(NSNotification *)notification
{
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    wd = (wd * 3) / 4;
    
    NSNumber *animationDurationNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = [animationDurationNumber doubleValue];
    
    NSNumber *animationCurveNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = [animationCurveNumber intValue];
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationOptions
                     animations:^{
                         self.bottomBackground.frame = CGRectMake(0, ht - 140, wd, 140);
                         self.bottomBorder.frame = CGRectMake(0, ht - 140, wd, 1);
                         self.messageTextField.frame = CGRectMake(10, ht - 135, wd - 70, 30);
                         self.sendButton.frame = CGRectMake(wd - 60, ht - 135, 50, 30);
                     }
                     completion:^(BOOL finished) {}];
    
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
