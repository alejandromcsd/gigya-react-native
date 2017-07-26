//
//  GigyaBridge.m
//  gigyareactnative
//
//  Created by Alejandro Perez on 7/25/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "GigyaBridge.h"
#import "AppDelegate.h"
#import <GigyaSDK/Gigya.h>

@implementation GigyaBridge

RCT_EXPORT_MODULE();

// Gigya React Native custom events
- (NSArray<NSString *> *)supportedEvents
{
  return @[@"AccountDidLogin", @"AccountDidLogout"];
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

// Gigya Accounts Delegates
- (void)accountDidLogin:(GSAccount *)account{
  [self sendEventWithName:@"AccountDidLogin" body:account.JSONString];
}

- (void)accountDidLogout{
  [self sendEventWithName:@"AccountDidLogout" body:@"AccountDidLogout"];
}

// Gigya React Native Bridge methods
RCT_EXPORT_METHOD(initBridge) {
  [Gigya setAccountsDelegate:self];
}

RCT_EXPORT_METHOD(login:(NSString *)loginId password:(NSString *)password callback:(RCTResponseSenderBlock)callback) {
  NSMutableDictionary *userAction = [NSMutableDictionary dictionary];
  [userAction setObject:loginId forKey:@"loginID"];
  [userAction setObject:password forKey:@"password"];

  GSRequest *request = [GSRequest requestForMethod:@"accounts.login" parameters:userAction];
  [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
    if (error) {
      callback(@[error.localizedDescription, [NSNull null]]);
    }
  }];
}

RCT_EXPORT_METHOD(socialLogin:(NSString *)provider callback:(RCTResponseSenderBlock)callback) {
  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  [parameters setObject:@"saveProfileAndFail" forKey:@"x_conflictHandling"];

  [Gigya loginToProvider:provider
              parameters:parameters
                    over:delegate.rootViewController
       completionHandler:^(GSUser *user, NSError *error) {

         if (error) {
           callback(@[error.localizedDescription, [NSNull null]]);
         }
       }
   ];
}

RCT_EXPORT_METHOD(isSessionValid:(RCTResponseSenderBlock)callback) {
  BOOL isValid = [Gigya isSessionValid];
  callback(@[[NSNull null], @(isValid)]);
}

RCT_EXPORT_METHOD(getAccountInfo:(RCTResponseSenderBlock)callback) {
  GSRequest *request = [GSRequest requestForMethod:@"accounts.getAccountInfo"];
  [request sendWithResponseHandler:^(GSResponse *response, NSError *error) {
    if (!error) {
      callback(@[[NSNull null], response.JSONString]);
    } else {
      callback(@[error.localizedDescription, [NSNull null]]);
    }
  }];
}

RCT_EXPORT_METHOD(logout) {
  [Gigya logout];
}

@end
