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
                            NSString *errorReason = @"";
                            switch (error.code) {
                              case LAErrorPasscodeNotSet:
                                errorReason = @"PasscodeNotSet";
                                break;
                                    
                              case LAErrorTouchIDNotAvailable:
                                errorReason = @"TouchIDNotAvailable";
                                break;
                                    
                              case LAErrorTouchIDNotEnrolled:
                                errorReason = @"TouchIDNotEnrolled";
                                break;
                                    
                              case LAErrorTouchIDLockout:
                                errorReason = @"TouchIDLockout";
                                break;
                                    
                              case LAErrorSystemCancel:
                                errorReason = @"SystemCancel";
                                break;
                                    
                              case LAErrorUserCancel:
                                errorReason = @"UserCancel";
                                break;
                                    
                              case LAErrorAuthenticationFailed:
                                errorReason = @"AuthenticationFailed";
                                break;
                                    
                                    
                              default:
                                errorReason = [error localizedDescription];
                            }
                            reject(@"error", errorReason, error);
                          }
                        }];
    } else {
        reject(@"error", authError.localizedDescription, authError);
    }
}



@end
