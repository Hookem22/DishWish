
#import "DWMessageViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface DWMessageViewController ()

@property (nonatomic, strong) NSMutableArray *arrContactsData;
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;

@property (nonatomic, assign) BOOL isNew;
@end

@implementation DWMessageViewController

@synthesize viewController = _viewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isNew = true;
    
    return;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if(self.isNew)
    {
        self.isNew = false;
        [self showAddressBook];
    }
    else
    {
        [self cancel];
    }
    
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showAddressBook {
    _addressBookController = [[ABPeoplePickerNavigationController alloc] init];
    [_addressBookController setPeoplePickerDelegate:self];
    [self presentViewController:_addressBookController animated:NO completion:nil];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    // Initialize a mutable dictionary and give it initial values.
    NSMutableDictionary *contactInfoDict = [[NSMutableDictionary alloc] initWithObjects:@[@"", @""] forKeys:@[@"name", @"phoneNumber"]];
    
    // Use a general Core Foundation object.
    CFTypeRef generalCFObject = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    // Get the first name.
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"name"];
        CFRelease(generalCFObject);
    }
    else
    {
        // Get the last name.
        generalCFObject = ABRecordCopyValue(person, kABPersonLastNameProperty);
        if (generalCFObject) {
            [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"name"];
            CFRelease(generalCFObject);
        }
    }
    // Get the phone numbers as a multi-value property.
    ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int i=0; i<ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"phoneNumber"];
        }
        else if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"phoneNumber"];
        }
        
        CFRelease(currentPhoneLabel);
        CFRelease(currentPhoneValue);
    }
    CFRelease(phonesRef);
    
    ViewController *vc = (ViewController *)self.viewController;
    [vc.mainView.rightSideBar addPerson:contactInfoDict];
    
    [self addInvite:contactInfoDict];
    
    [self cancel];
    return NO;
}


-(void)addInvite:(NSDictionary *)contact
{
    NSString *phoneNumber = [contact objectForKey:@"phoneNumber"];
    phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    
    NSString *contactName = [contact objectForKey:@"name"];

    [User getByPhoneNumber:phoneNumber completion:^(User *toUser)  {
        if(toUser == NULL) //|| [toUser.lastSignedIn isMemberOfClass:[NSNull class]])
        {
            //Send SMS
            NSLog(@"SMS");
            User *newUser = [[User alloc] init];
            newUser.phoneNumber = phoneNumber;
            newUser.name = contactName;
            [newUser add:^(User *addedUser) {
                [self createSavedList:addedUser isSms:YES];
            }];
        }
        else if([toUser.pushDeviceToken length] <= 0)
        {
            NSLog(@"SMS");
            [self createSavedList:toUser isSms:YES];
        }
        else
        {
            //Send push message
            NSLog(@"Push");
            [self createSavedList:toUser isSms:NO];
        }
        
    }];

}

-(void)createSavedList:(User *)toUser isSms:(BOOL)isSms
{
    //CreateXref
    SavedList *savedList = (SavedList *)[Session sessionVariables][@"currentSavedList"];
    [SavedList add:[NSString stringWithFormat:@"%lu", (unsigned long)savedList.xrefId] userId:toUser.userId completion:^(SavedList *savedList)
    {
        
         if(isSms)
         {
             NSString *message = [NSString stringWithFormat:@"Let's Eat! Here's a list of places: letseat://?%lu (if you don't have Let's Eat app get it here http://getletseat.com?%lu", (unsigned long)savedList.xrefId, (unsigned long)savedList.xrefId];
         
             [self sendSMS:toUser.phoneNumber message:message];
         }
         else
         {
             User *currentUser = (User *)[Session sessionVariables][@"currentUser"];
             NSString *header = [NSString stringWithFormat:@"%@ sent you a list", currentUser.name];
             NSString *message = [NSString stringWithFormat:@"%lu", (unsigned long)savedList.xrefId];
             
             [self sendPushMessage:toUser.pushDeviceToken header:header message:message];
         }
        
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invite Sent"
         message:[NSString stringWithFormat:@"%@ was invited to join your meal.", toUser.name]
         delegate:nil
         cancelButtonTitle:@"OK"
         otherButtonTitles:nil];
         
         [alert show];

    }];
}


-(void)sendSMS:(NSString *)phoneNumber message:(NSString *)message
{
    
    NSArray *recipients = [[NSArray alloc] initWithObjects:phoneNumber, nil];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipients];
    [messageController setBody:message];
}


-(void)sendPushMessage:(NSString *)pushDeviceToken header:(NSString *)header message:(NSString *)message
{
    
    [PushMessage push:pushDeviceToken header:header message:message];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    if(result == MessageComposeResultCancelled) {
        //Message cancelled
    } else if(result == MessageComposeResultSent) {
        //Message sent
    }
}




-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [_addressBookController dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
