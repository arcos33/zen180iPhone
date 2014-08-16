//
//  FaqViewController.h
//  zen180
//
//  Created by iosninjamaster on 7/19/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface FaqViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    IBOutlet UIView *faqView;
    IBOutlet UIScrollView *faqScrollView;
    
}

- (IBAction)toPreviousScreen:(id)sender;
- (IBAction)sendEmailToSupport:(id)sender;


@end
