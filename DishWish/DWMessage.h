
#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Place.h"
#import "Session.h"

@interface DWMessage : UIView <ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;


@end
