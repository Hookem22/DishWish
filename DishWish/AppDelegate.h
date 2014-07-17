//
//  AppDelegate.h
//  DishWish
//
//  Created by Will on 5/9/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSString *queryValue;

@property (strong, nonatomic) ViewController *viewController;

@end
