//
//  PurchaseOptionsViewController.m
//  zen180
//
//  Created by iosninjamaster on 8/8/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import "PurchaseOptionsViewController.h"

@interface PurchaseOptionsViewController ()

@end

@implementation PurchaseOptionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissPurchaseOptionsView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
