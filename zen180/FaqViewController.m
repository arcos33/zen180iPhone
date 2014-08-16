//
//  FaqViewController.m
//  zen180
//
//  Created by iosninjamaster on 7/19/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import "FaqViewController.h"

@interface FaqViewController ()

@end

@implementation FaqViewController

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
    faqScrollView.contentSize = CGSizeMake(295, 2360);
    [faqScrollView addSubview:faqView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)toPreviousScreen:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendEmailToSupport:(id)sender
{
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.mailComposeDelegate = self;
    [mailVC setMessageBody:@"To Zen180 Support Staff: \n" isHTML:NO];
    NSArray *tempArray = @[@"support@zen180.com"];
    [mailVC setToRecipients:tempArray];
    
    [self presentViewController:mailVC animated:YES completion:nil];
}

-  (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];

}
@end



