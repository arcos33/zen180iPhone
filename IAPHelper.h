//
//  IAPHelper.h
//  zen180
//
//  Created by iosninjamaster on 8/7/14.
//  Copyright (c) 2014 urbndna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "AwakenedMindViewController.h"
#import "CreativeMindViewController.h"
#import "RelaxedMindViewController.h"
#import "RomanticMindViewController.h"

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

{
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;
- (void)restoreCompletedTransactions;


@property (strong, nonatomic) AwakenedMindViewController *awakenedMindVC;
@property (strong, nonatomic) CreativeMindViewController *creativeMindVC;
@property (strong, nonatomic) RelaxedMindViewController *relaxedMindVC;
@property (strong, nonatomic) RomanticMindViewController *romanticMindVC;


@end
