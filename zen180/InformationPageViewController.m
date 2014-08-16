//
//  InformationPageViewController.m
//  zen180
//
//  Created by iosninjamaster on 5/11/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import "InformationPageViewController.h"
#import "FaqViewController.h"
#import "WebView.h"
@interface InformationPageViewController ()

@end

@implementation InformationPageViewController
@synthesize webviewVC;

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

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)toFAQscreen:(id)sender
{
    FaqViewController *viewController = [[FaqViewController alloc] initWithNibName:@"Faq" bundle:nil];
    [self presentViewController:viewController animated:YES completion:nil];
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

- (IBAction)sendToFacebookPage:(id)sender
{
    NSString *urlString = @"https://www.facebook.com/zen180";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    WebView *theWebView = [[WebView alloc] initWithNibName:@"WebView" bundle:nil];
    [self presentViewController:theWebView animated:YES completion:nil];
    [theWebView.myWebview loadRequest:request];
}

- (IBAction)sendToTwitterPage:(id)sender
{
    NSString *urlString = @"https://twitter.com/zen180llc";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    WebView *theWebView = [[WebView alloc] initWithNibName:@"WebView" bundle:nil];
    [self presentViewController:theWebView animated:YES completion:nil];
    [theWebView.myWebview loadRequest:request];
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
