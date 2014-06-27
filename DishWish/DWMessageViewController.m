
#import "DWMessageViewController.h"

@interface DWMessageViewController ()

@property (nonatomic, strong) NSMutableArray *arrContactsData;
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;
@property (nonatomic, strong) UINavigationItem *navItem;

-(void)showAddressBook;
//-(void)buttonClicked:(UIButton*)sender;

@end

@implementation DWMessageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"letseat"]]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    [[self navigationItem] setLeftBarButtonItem:backButton];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddressBook)];
    [[self navigationItem] setRightBarButtonItem:addButton];
    
    
    
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showAddressBook {
    _addressBookController = [[ABPeoplePickerNavigationController alloc] init];
    [_addressBookController setPeoplePickerDelegate:self];
    [self presentViewController:_addressBookController animated:YES completion:nil];
}

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
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 - (id)initWithFrame:(CGRect)frame
 {
 self = [super initWithFrame:frame];
 if (self) {
 self.backgroundColor = [UIColor whiteColor];
 
 UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, frame.size.width - 20, 40)];
 textField.borderStyle = UITextBorderStyleRoundedRect;
 textField.font = [UIFont systemFontOfSize:15];
 textField.placeholder = @"Add friends";
 textField.autocorrectionType = UITextAutocorrectionTypeNo;
 textField.keyboardType = UIKeyboardTypeDefault;
 textField.returnKeyType = UIReturnKeyDone;
 textField.clearButtonMode = UITextFieldViewModeWhileEditing;
 textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
 textField.delegate = self;
 [self addSubview:textField];
 
 
 }
 return self;
 }
 */

@end
