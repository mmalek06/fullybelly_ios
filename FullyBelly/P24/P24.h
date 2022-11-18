//
//  P24.h
//  Przelewy24
//
//  Created by Appchance on 12-05-22.
//  Copyright (c) 2012 Appchance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class P24;
@class P24Config;
@class P24Payment;
@class P24PaymentResult;
@class P24PaymentResultStatus;

@protocol P24Delegate;


// P24
// This class is used to start the payment process and get the payment result (via delegate).

@interface P24 : NSObject

@property (nonatomic, readonly, strong) P24Config *config;
@property (nonatomic, readonly, unsafe_unretained) id<P24Delegate> delegate;

// Initializer
- (id)initWithConfig:(P24Config *)config delegate:(id<P24Delegate>)delegate;

// Starts the payment process for a given payment. 
// After this method is invoked a modal view controller used to go through the process of payment will be presented in a given view controller.
- (void)startPayment:(P24Payment *)payment inViewController:(UIViewController *)viewController;

- (void)startPayment:(P24Payment *)payment inViewController:(UIViewController *)viewController withNavigationButtonTint:(UIColor*) color;

@end


// P24Delegate
// Delegate used by P24 class to inform about status of the payment process.

@protocol P24Delegate <NSObject>

@required

// Called when payment was finished and sent to P24 server
- (void)p24:(P24 *)p24 didFinishPayment:(P24Payment *)p24Payment withResult:(P24PaymentResult *)p24PaymentResult;

// Called when payment was cancelled by the user
- (void)p24:(P24 *)p24 didCancelPayment:(P24Payment *)p24Payment;

// Called when payment failed (e.g. response from P24 server could not be verified)
- (void)p24:(P24 *)p24 didFailPayment:(P24Payment *)p24Payment withError:(NSError *)error;

@end


// P24Config
// Represents a configuration of the payment process.

extern NSString * const P24_API_3_2;
extern NSString * const P24_API_2_7;
extern int const P24_CHANNEL_CARDS;
extern int const P24_CHANNEL_TRANSFERS;
extern int const P24_CHANNEL_24_7;
extern int const P24_CHANNEL_PBL;

@interface P24Config : NSObject

@property (nonatomic, assign) int merchantId;
@property (nonatomic, copy) NSString *crc;
@property (nonatomic, assign) BOOL storeLoginData; // optional, default is "false"
@property (nonatomic, assign) BOOL useMobileBankStyles; // optional, default is "true"
@property (nonatomic, assign) BOOL dontAskForSaveCredentials; // optional, default is "false"
@property (nonatomic, assign) int timeLimit;// optional, default is "150"
@property (nonatomic, assign) int p24Channel;// optional, default is "3" (P24_CHANNEL_CARDS | P24_CHANNEL_TRANSFERS)

// P24 sdk version used internally in communication with P24 server.
@property (nonatomic, copy, readonly) NSString *p24SdkVersion;

- (NSString*) p24UrlFor:(NSString*) token;
- (NSString*) p24UrlFull;
- (NSString*) p24Url;
- (void) enableTestMode: (BOOL) enable;
- (BOOL) isTestMode;

@end

// P24Payment
// Represents a payment. Contains all the information required to make a payment such as session id, price, client's (purchaser) name, address etc. 

@interface P24Payment : NSObject

@property (nonatomic, assign) int amount; // price
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *clientName;
@property (nonatomic, copy) NSString *clientAddress;
@property (nonatomic, copy) NSString *clientZipCode;
@property (nonatomic, copy) NSString *clientCity;
@property (nonatomic, copy) NSString *clientCountry;
@property (nonatomic, copy) NSString *clientEmail;
@property (nonatomic, copy) NSString *clientPhone;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *transferLabel;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *p24UrlStatus;

@end


// P24PaymentResultStatus
// Status of a payment. Full list of available statuses can be found in P24 API documentation 
// available at: http://www.przelewy24.pl/files/cms/2/przelewy24_specyfikacja.pdf

@interface P24PaymentResultStatus : NSObject

@property (nonatomic, assign, readonly) int code;
@property (nonatomic, copy, readonly) NSString *description;

// Returns P24PaymentResultStatus for a given status code.
+ (P24PaymentResultStatus *)paymentResultStatusForCode:(int)code;

// P24PaymentResultStatus representing OK status.
+ (int)P24PaymentResultStatusCodeOK;

// Returns information whether this object represents a successful payment status.
- (BOOL)isOk;

// Initilizer
- (id)initWithCode:(int)code description:(NSString *)description;

@end


// P24PaymentResult
// Represents a result of a payment. Contains a status of the payment and order id of a payment.

@interface P24PaymentResult : NSObject

// Order id of the payment (unique number given by P24 system).
@property (nonatomic, assign, readonly) int orderId;

// Status of the payment
@property (nonatomic, strong, readonly) P24PaymentResultStatus *status;

// Initializer
- (id)initWithOrderId:(int)orderId status:(P24PaymentResultStatus *)status;

// Returns information whether the payment was successful or not.
- (BOOL)isOk;

@end
