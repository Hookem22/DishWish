
#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "User.h"
#import "Place.h"
#import "PushMessage.h"
#import "SavedList.h"
#import "Session.h"

@interface DWMessageViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate, MFMessageComposeViewControllerDelegate, UITextFieldDelegate>

@property(nonatomic, assign) ViewController *viewController;

@end
