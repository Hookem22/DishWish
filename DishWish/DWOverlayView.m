#import "DWOverlayView.h"

@interface DWOverlayView ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation DWOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thumbs_down"]];
    [self addSubview:self.imageView];

    return self;
}

- (void)setMode:(DWOverlayViewMode)mode
{
    if (_mode == mode) return;

    _mode = mode;
    if (mode == DWOverlayViewModeLeft) {
        self.imageView.image = [UIImage imageNamed:@"thumbs_down"];
    } else {
        self.imageView.image = [UIImage imageNamed:@"thumbs_up_300x300"];
    }
}

- (void)layoutSubviews
{
    CGFloat wd = self.frame.size.width;
    CGFloat ht = self.frame.size.height;
    
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(wd * 0.25, ht * 0.25, wd * 0.5, wd * 0.5);
}

@end