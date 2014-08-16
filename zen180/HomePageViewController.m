//
//  HomePageViewController.m
//  zen180
//
//  Created by iosninjamaster on 5/8/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import "HomePageViewController.h"
#import "OLImage.h"
#import "OLImageView.h"
#import "AwakenedMindViewController.h"
#import "PageContentViewController.h"



@interface HomePageViewController ()

@end

@implementation HomePageViewController


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
   
    OLImageView *Aimv = [[OLImageView alloc] initWithImage:[OLImage imageNamed:@"640x1136-app-animation.gif"]];
    [Aimv setFrame:CGRectMake(-2, -15, 324, 641)];
    [Aimv setUserInteractionEnabled:YES];
    [self.view addSubview:Aimv];
    [self.view sendSubviewToBack:Aimv];

}






//[magicAnimatedVC.view addSubview:Aimv];

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)browseAudioTracksACTION:(id)sender
{
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"PageControlHomeViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
    
}



@end
