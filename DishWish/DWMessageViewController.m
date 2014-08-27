
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

-(void)sendButtonClick:(id)sender
{
    if(_arrContactsData == nil || _arrContactsData.count == 0)
    {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"No Friends Added" message:@"Add friends to send message." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    /*
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    */
    
    //[self getContacts];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
-(void)getContacts
{
    
    for(NSDictionary *contact in _arrContactsData)
    {
        NSString *phoneNumber = [[contact objectForKey:@"mobileNumber"] length] > 0 ? [contact objectForKey:@"mobileNumber"] : [contact objectForKey:@"homeNumber"];
        
        phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
        
        NSString *contactName = [contact objectForKey:@"firstName"];
        //NSString *fromUserName = self.fromTextbox.text;
        
        [User getByPhoneNumber:phoneNumber completion:^(User *toUser)  {
            if(toUser == NULL) //|| [toUser.lastSignedIn isMemberOfClass:[NSNull class]])
            {
                //Send SMS
                NSLog(@"SMS");
                User *newUser = [[User alloc] init];
                newUser.phoneNumber = phoneNumber;
                newUser.name = contactName;
                [newUser add:^(User *addedUser) {
                   [self saveList:fromUserName toUser:addedUser isSms:YES];
                }];
            }
            else if([toUser.pushDeviceToken length] <= 0)
            {
                NSLog(@"SMS");
                [self saveList:fromUserName toUser:toUser isSms:YES];
            }
            else
            {
                //Send push message
                NSLog(@"Push");
                [self saveList:fromUserName toUser:toUser isSms:NO];
            }
            
        }];
        
    }
}
*/


-(void)saveList:(NSString *)fromUserName toUser:(User *)toUser isSms:(BOOL)isSms
{
    //CreateXref
    /*
    [SavedList add:fromUserName toUser:toUser completion:^(SavedList *savedList) {
        [self addSavedListToRightSideBar:savedList];
        
        if(isSms)
        {
            NSString *message = [NSString stringWithFormat:@"Let's Eat! Here's a list of places: letseat://?%lu (if you don't have Let's Eat app get it here http://getletseat.com?%lu", (unsigned long)savedList.xrefId, (unsigned long)savedList.xrefId];
            
            [self sendSMS:toUser.phoneNumber message:message];
        }
        else
        {
            NSString *header = [NSString stringWithFormat:@"%@ sent you a list", fromUserName];
            NSString *message = [NSString stringWithFormat:@"%lu", (unsigned long)savedList.xrefId];
            
            [self sendPushMessage:toUser.pushDeviceToken header:header message:message];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Sent"
                                    message:[NSString stringWithFormat:@"Your list was sent to %@", toUser.name]
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
        
        [alert show];
        
        User *currentUser = (User *)[Session sessionVariables][@"currentUser"];
        if(currentUser.name != fromUserName)
        {
            currentUser.name = fromUserName;
            [currentUser update:^(User *updatedUser) { }];
        }
    }];
     */
}

-(void)addSavedListToRightSideBar:(SavedList *)savedList
{
    /*
    savedList.fromUserName = @"";
    savedList.createdAt = [NSDate date];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    ViewController *vc = (ViewController *)appDelegate.viewController;
    for(id subview in vc.mainView.subviews) {
        if([subview isMemberOfClass:[DWRightSideBar class]])
        {
            DWRightSideBar *right = (DWRightSideBar *)subview;
            [right addList:savedList];
        }
    }
     */
}


-(void)sendSMS:(NSString *)phoneNumber message:(NSString *)message
{

    NSArray *recipients = [[NSArray alloc] initWithObjects:phoneNumber, nil];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipients];
    [messageController setBody:message];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    if(result == MessageComposeResultCancelled) {
        //Message cancelled
    } else if(result == MessageComposeResultSent) {
        //Message sent
    }
}

-(void)sendPushMessage:(NSString *)pushDeviceToken header:(NSString *)header message:(NSString *)message
{
    
    [PushMessage push:pushDeviceToken header:header message:message];
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
    
    [self cancel];
    return NO;
}


/*
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    // Initialize a mutable dictionary and give it initial values.
    NSMutableDictionary *contactInfoDict = [[NSMutableDictionary alloc]
                                            initWithObjects:@[@"", @"", @"", @"", @"", @"", @"", @"", @""]
                                            forKeys:@[@"firstName", @"lastName", @"mobileNumber", @"homeNumber", @"homeEmail", @"workEmail", @"address", @"zipCode", @"city"]];
    
    // Use a general Core Foundation object.
    CFTypeRef generalCFObject = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    // Get the first name.
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"firstName"];
        CFRelease(generalCFObject);
    }
    
    // Get the last name.
    generalCFObject = ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"lastName"];
        CFRelease(generalCFObject);
    }
    
    // Get the phone numbers as a multi-value property.
    ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int i=0; i<ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"mobileNumber"];
        }
        
        if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"homeNumber"];
        }
        
        CFRelease(currentPhoneLabel);
        CFRelease(currentPhoneValue);
    }
    CFRelease(phonesRef);
    
    
    // Get the e-mail addresses as a multi-value property.
    ABMultiValueRef emailsRef = ABRecordCopyValue(person, kABPersonEmailProperty);
    for (int i=0; i<ABMultiValueGetCount(emailsRef); i++) {
        CFStringRef currentEmailLabel = ABMultiValueCopyLabelAtIndex(emailsRef, i);
        CFStringRef currentEmailValue = ABMultiValueCopyValueAtIndex(emailsRef, i);
        
        if (CFStringCompare(currentEmailLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentEmailValue forKey:@"homeEmail"];
        }
        
        if (CFStringCompare(currentEmailLabel, kABWorkLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentEmailValue forKey:@"workEmail"];
        }
        
        CFRelease(currentEmailLabel);
        CFRelease(currentEmailValue);
    }
    CFRelease(emailsRef);
    
    
    // Get the first street address among all addresses of the selected contact.
    ABMultiValueRef addressRef = ABRecordCopyValue(person, kABPersonAddressProperty);
    if (ABMultiValueGetCount(addressRef) > 0) {
        NSDictionary *addressDict = (__bridge NSDictionary *)ABMultiValueCopyValueAtIndex(addressRef, 0);
        
        [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressStreetKey] forKey:@"address"];
        [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressZIPKey] forKey:@"zipCode"];
        [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressCityKey] forKey:@"city"];
    }
    CFRelease(addressRef);
    
    
    // If the contact has an image then get it too.
    if (ABPersonHasImageData(person)) {
        NSData *contactImageData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
        
        [contactInfoDict setObject:contactImageData forKey:@"image"];
    }
    
    // Initialize the array if it's not yet initialized.
    if (_arrContactsData == nil) {
        _arrContactsData = [[NSMutableArray alloc] init];
    }
    // Add the dictionary to the array.
    [_arrContactsData addObject:contactInfoDict];
    
    // Reload the table view data.
    //[self.tableView reloadData];
    
    // Dismiss the address book view controller.
    [_addressBookController dismissViewControllerAnimated:NO completion:nil];
    
    NSString *peopleList = @"";
    for(NSDictionary *dict in _arrContactsData)
    {
        NSString *firstName = [dict objectForKey:@"firstName"];
        NSString *lastName = [dict objectForKey:@"lastName"];
        
        if(firstName.length > 0)
            peopleList = [NSString stringWithFormat:@"%@ %@", peopleList, firstName];
        if(lastName.length > 0)
            peopleList = [NSString stringWithFormat:@"%@ %@", peopleList, lastName];
        
        peopleList = [NSString stringWithFormat:@"%@,", peopleList];
        
    }
    
    peopleList = [peopleList substringToIndex:peopleList.length - 1];
    [self.peopleTextbox setText:peopleList];
    
    return NO;
}
*/
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
