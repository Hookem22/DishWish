#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger , DWOverlayViewMode) {
    DWOverlayViewModeLeft,
    DWOverlayViewModeRight
};

@interface DWOverlayView : UIView
@property (nonatomic) DWOverlayViewMode mode;
@end