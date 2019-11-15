#import "LocalAuth.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation LocalAuth

RCT_EXPORT_MODULE(LocalAuth);

RCT_EXPORT_METHOD(getAvailableBiometrics:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  LAContext *context = [[LAContext alloc] init];
  NSError *authError = nil;
  NSMutableArray<NSString *> *biometrics = [[NSMutableArray<NSString *> alloc] init];
  if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                           error:&authError]) {
    if (authError == nil) {
      if (@available(iOS 11.0.1, *)) {
        if (context.biometryType == LABiometryTypeFaceID) {
          [biometrics addObject:@"face"];
        } else if (context.biometryType == LABiometryTypeTouchID) {
          [biometrics addObject:@"fingerprint"];
        }
      } else {
        [biometrics addObject:@"fingerprint"];
      }
    }
  } else if (authError.code == LAErrorTouchIDNotEnrolled) {
    [biometrics addObject:@"undefined"];
  }
  resolve(biometrics);
}

RCT_EXPORT_METHOD(authenticateWithBiometrics:(NSString *) buttonCancel
                  fingerPrintHint:(NSString*) fingerPrintHint
                  title: (NSString*) title
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    LAContext *context = [[LAContext alloc] init];
    NSError *authError = nil;
    context.localizedFallbackTitle = @"";

    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                             error:&authError]) {
      [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
              localizedReason: title
                        reply:^(BOOL success, NSError *error) {
                          if (success) {
                            resolve(@YES);
                          } else {
                            NSString *errorCode = @"";
                            NSString *errorReason = @"";
                            switch (error.code) {
                              case LAErrorPasscodeNotSet:
                                errorCode = @"PasscodeNotSet";
                                errorReason = @"Phone not secured by PIN, pattern or password, or SIM is currently locked.";
                                break;
                                    
                              case LAErrorTouchIDNotAvailable:
                                errorCode = @"NotAvailable";
                                errorReason = @"Biometrics is not available on this device.";
                                break;
                                    
                              case LAErrorTouchIDNotEnrolled:
                                errorCode = @"NotEnrolled";
                                errorReason = @"No Biometrics enrolled on this device.";
                                break;
                                    
                              case LAErrorTouchIDLockout:
                                errorCode = @"LockedOut";
                                errorReason = @"The operation was canceled because the API is locked out due to too many attempts. This occurs after 5 failed attempts, and lasts for 30 seconds.";
                                break;
                                    
                              case LAErrorSystemCancel:
                                resolve(@NO);
                                return;
                                    
                              case LAErrorUserCancel:
                                resolve(@NO);
                                return;
                                    
                              case LAErrorAuthenticationFailed:
                                resolve(@NO);
                                return;
                                    
                              default:
                                resolve(@NO);
                                return;
                            }
                            reject(errorCode, errorReason, error);
                          }
                        }];
    } else {
        reject(@"error", authError.localizedDescription, authError);
    }
}



@end
