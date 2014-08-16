//
//  Zen180_IAP_Helper.m
//  zen180
//
//  Created by iosninjamaster on 8/7/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import "Zen180_IAP_Helper.h"

@implementation Zen180_IAP_Helper

+ (Zen180_IAP_Helper *)sharedInstance
{
    static dispatch_once_t once;
    static Zen180_IAP_Helper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.urbndna.AwakenedMind_IAP",
                                      @"com.urbndna.CreativeMind_IAP",
                                      @"com.urbndna.Pack_IAP",
                                      @"com.urbndna.RelaxedMind_IAP",
                                      @"com.urbndna.RomanticMind_IAP",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
