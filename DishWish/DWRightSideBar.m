//
//  DWRightSideBar.m
//  DishWish
//
//  Created by Will on 6/3/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "DWRightSideBar.h"
#import "DWView.h"

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
@property (nonatomic, strong) UIScrollView *messageView;

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
        
        self.messageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 200)];
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

-(void)setupMessaging
{
    //[SavedList get]
}

-(void)addPerson:(User *)user
{
    [self.people addObject:user];
    
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    wd = (wd * 3) / 4;
    
    NSString *names = self.peopleLabel.text.length == 0 ? user.name : [NSString stringWithFormat:@"%@, %@", self.peopleLabel.text, user.name];
    
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
    if(self.people.count <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Add friends to message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if(self.messageTextField.text.length > 0)
    {
        NSString *message = self.messageTextField.text;
        [self populateMessages:message];
        [self.messageTextField setText:@""];
        
        [Message add:message completion:^(Message *newMessage)
         {
             User *currentUser = (User *)[Session sessionVariables][@"currentUser"];
             NSString *header = [NSString stringWithFormat:@"%@ sent you a message", currentUser.name];
             
             SavedList *savedList = (SavedList *)[Session sessionVariables][@"currentSavedList"];
             NSString *message = [NSString stringWithFormat:@"%lu", (unsigned long)savedList.xrefId];
             
             for(User *user in self.people)
             {
                 if(user.pushDeviceToken.length > 0) {
                     [PushMessage push:user.pushDeviceToken header:header message:message];
                 }
                 else
                 {
                     [User get:user.userId completion:^(User *newUser) {
                         if(user.pushDeviceToken.length > 0)
                         {
                             user.pushDeviceToken = newUser.pushDeviceToken;
                             [PushMessage push:newUser.pushDeviceToken header:header message:message];
                         }
                     }];
                 }
             }
             
         }];
        
    }
    
    [self endEditing:YES];
}

-(void)getMessagesFromDb
{
    SavedList *currentSavedList = (SavedList *)[Session sessionVariables][@"currentSavedList"];
    [SavedList get:[NSString stringWithFormat:@"%lu", (unsigned long)currentSavedList.xrefId] completion:^(NSArray *savedLists) {
        if(self.people.count <= savedLists.count)
        {
            for(SavedList *list in savedLists)
            {
                bool contains = false;
                for(User *user in self.people)
                {
                    if(user.userId == list.userId)
                    {
                        contains = true;
                        break;
                    }
                }
                if(!contains)
                {
                    User *addUser = [[User alloc] init];
                    addUser.userId = list.userId;
                    addUser.name = list.userName;
                    [self addPerson:addUser];
                    [self changeIcon:YES];
                }
            }
        }
        [Message get:currentSavedList.xrefId completion:^(NSArray *allMessages)
         {
             if(self.messages.count != allMessages.count)
             {
                 self.messages = [[NSMutableArray alloc] initWithArray:allMessages];
                 [self populateMessages:@""];
                 [self changeIcon:YES];
             }
         }];
    }];
}

-(void)changeIcon:(BOOL)newMessages
{
    NSString *imageName = newMessages ? @"newmessage" : @"message";
    for(id subview in self.superview.subviews)
    {
        if([subview isMemberOfClass:[UINavigationBar class]]) {
            UINavigationBar *nav = (UINavigationBar *)subview;
            if(nav.items.count > 0 && [nav.items[0] isMemberOfClass:[UINavigationItem class]])
            {
                UIButton *userButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
                [userButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                [userButton addTarget:self action:@selector(userButtonPressed) forControlEvents:UIControlEventTouchUpInside];
                
                UINavigationItem *item = (UINavigationItem *)nav.items[0];
                item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userButton];
            }
            
        }
    }
}

-(void)userButtonPressed
{  
    DWView *view = (DWView *)self.superview;
    [view userButtonPressed];
}

-(void)populateMessages:(NSString *)message
{
    if(self.messages.count <= 0 && message.length <= 0)
        return;
    
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    wd = (wd * 3) / 4;
    
    [self.messageView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    
    User *currentUser = (User *)[Session sessionVariables][@"currentUser"];
    if(message.length > 0)
    {
        Message *newMessage = [[Message alloc] init];
        newMessage.userId = currentUser.userId;
        newMessage.message = message;
        newMessage.date = [NSDate date];
        [self.messages addObject:newMessage];
    }
    
    NSUInteger viewY = 0;
    for(Message *message in self.messages)
    {
        bool isMe = [currentUser.userId isEqualToString:message.userId];
        NSString *userName = self.people.count > 1 ? message.userName : @"";
        UIView *view = [self addTextView:message.message from:userName date:[self dateDiff:message.date] isMe:isMe viewY:viewY];
        [self.messageView addSubview:view];
        viewY = viewY + view.frame.size.height;
    }

    self.messageView.frame = CGRectMake(0, self.topBackground.frame.size.height + 10, wd, ht - 200);
    self.messageView.contentSize = CGSizeMake(wd, viewY + 55);

    if(self.messageView.contentSize.height - self.messageView.bounds.size.height > 0)
    {
        CGPoint bottomOffset = CGPointMake(0, self.messageView.contentSize.height - self.messageView.bounds.size.height);
        [self.messageView setContentOffset:bottomOffset animated:NO];
    }
}

-(UIView *)addTextView:(NSString *)message from:(NSString *)from date:(NSString *)date isMe:(BOOL)isMe viewY:(NSUInteger)viewY
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    wd = (wd * 3) / 4;
    
    if(isMe)
    {
        CGFloat textHeight = [self heightForText:message width:(wd * 3) / 4 - 5 fontSize:14] + 10;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, wd, textHeight + 25)];

        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(wd / 4, 0, (wd * 3) / 4 - 10, 15)];
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

        UITextView *newTextbox = [[UITextView alloc] initWithFrame:CGRectMake(wd / 4, 18, (wd * 3) / 4 - 5, textHeight)];
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
        
        CGFloat textHeight = [self heightForText:message width:(wd * 3) / 4 - 5 fontSize:14] + 10;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, viewY + 5, wd, textHeight + 25)];
        
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
        
        UITextView *newTextbox = [[UITextView alloc] initWithFrame:CGRectMake(5, 18, (wd * 3) / 4 - 5, textHeight)];
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

-(NSString *)dateDiff:(NSDate *)date
{
    NSString *dateDiff = @"";
    if(![date isMemberOfClass:[NSNull class]])
    {
        NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:date];
        if(secondsBetween > 600000)
        {
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"MMM d h:mm a"];
            
            return [format stringFromDate:date];
        }
        else if(secondsBetween > 86400)
        {
            int value = (int)secondsBetween / 86400;
            if(value == 1)
                dateDiff = @"1 day ago";
            else
                dateDiff = [NSString stringWithFormat:@"%d days ago", value];
        }
        else if(secondsBetween > 3600)
        {
            int value = (int)secondsBetween / 3600;
            if(value == 1)
                dateDiff = @"1 hour ago";
            else
                dateDiff = [NSString stringWithFormat:@"%d hours ago", value];
        }
        else if(secondsBetween > 60)
        {
            int value = ((int)secondsBetween / 60);
            if(value == 1)
                dateDiff = @"1 minute ago";
            else
                dateDiff = [NSString stringWithFormat:@"%d minutes ago", value];
        }
        else
            dateDiff = @"Now";
    }
    return dateDiff;
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
