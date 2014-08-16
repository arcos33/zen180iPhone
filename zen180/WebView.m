//
//  WebView.m
//  zen180
//
//  Created by iosninjamaster on 7/23/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import "WebView.h"

@implementation WebView


@synthesize myWebview;

- (IBAction)dismissBrowser:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
