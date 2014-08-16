//
//  InformationPageViewController.h
//  zen180
//
//  Created by iosninjamaster on 5/11/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "WebView.h"

@interface InformationPageViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    
}

@property (nonatomic, strong) WebView *webviewVC;

- (IBAction)back:(id)sender;
- (IBAction)toFAQscreen:(id)sender;
- (IBAction)sendEmailToSupport:(id)sender;
- (IBAction)sendToFacebookPage:(id)sender;
- (IBAction)sendToTwitterPage:(id)sender;




@end
