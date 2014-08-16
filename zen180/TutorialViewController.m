//
//  TutorialViewController.m
//  zen180
//
//  Created by iosninjamaster on 7/28/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

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
//    self.tutorialScrollView.delegate = self;
//    self.tutorialScrollView.contentSize = CGSizeMake(960, 568);
//    [self.tutorialScrollView addSubview:self.tutorialContentView];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    tutorialPageControl.currentPage = page;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    targetContentOffset->x = scrollView.contentOffset.x + 220;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeTutorial:(id)sender
{
    //[self.tutorialScrollView removeFromSuperview];
    //NSLog(@"hello");
    
    for(UIView *subview in [self.view subviews]) {
        NSLog(@"subview = %@", subview.description);
//        if([subview isKindOfClass:[UIScrollView class]]) {
//            [subview removeFromSuperview];
//        } else {
//            // Do nothing - not a UIButton or subclass instance
//        }
    }
}
@end
