//
//  ViewController.m
//  DishWish
//
//  Created by Will on 5/9/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "ViewController.h"
#import "DWView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView {
    
    self.view = [[DWView alloc] init];
    
    //UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    //navbar.topItem.title = @"DW";
    
    //[self.view addSubview:navbar];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
