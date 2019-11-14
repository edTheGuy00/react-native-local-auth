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

//#pragma mark Private Methods
//
//- (void)alertMessage:(NSString *)message
//         firstButton:(NSString *)firstButton
//            resolver:(RCTPromiseResolveBlock)resolve
//            rejecter:(RCTPromiseRejectBlock)reject
//    additionalButton:(NSString *)secondButton {
//  UIAlertController *alert =
//      [UIAlertController alertControllerWithTitle:@""
//                                          message:message
//                                   preferredStyle:UIAlertControllerStyleAlert];
//
//  UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:firstButton
//                                                          style:UIAlertActionStyleDefault
//                                                        handler:^(UIAlertAction *action) {
//                                                          resolve(@NO);
//                                                        }];
//
//  [alert addAction:defaultAction];
//  if (secondButton != nil) {
//    UIAlertAction *additionalAction = [UIAlertAction
//        actionWithTitle:secondButton
//                  style:UIAlertActionStyleDefault
//                handler:^(UIAlertAction *action) {
//                  if (UIApplicationOpenSettingsURLString != NULL) {
//                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                    [[UIApplication sharedApplication] openURL:url];
//                    resolve(@NO);
//                  }
//                }];
//    [alert addAction:additionalAction];
//  }
//  [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert
//                                                                                     animated:YES
//                                                                                   completion:nil];
//}
//
//RCT_EXPORT_METHOD(authenticateWithBiometrics: (NSString *)promptMessage resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
//    LAContext *context = [[LAContext alloc] init];
//    NSError *authError = nil;
//    lastCallArgs = nil;
//    lastResult = nil;
//    context.localizedFallbackTitle = @"";
//
//    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
//                             error:&authError]) {
//      [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
//              localizedReason:arguments[@"localizedReason"]
//                        reply:^(BOOL success, NSError *error) {
//                          if (success) {
//                            resolve(@YES);
//                          } else {
//                            switch (error.code) {
//                              case LAErrorPasscodeNotSet:
//                              case LAErrorTouchIDNotAvailable:
//                              case LAErrorTouchIDNotEnrolled:
//                              case LAErrorTouchIDLockout:
//                                [self handleErrors:error
//                                     flutterArguments:arguments
//                                    withFlutterResult:result];
//                                return;
//                              case LAErrorSystemCancel:
//                                if ([arguments[@"stickyAuth"] boolValue]) {
//                                  lastCallArgs = arguments;
//                                  lastResult = result;
//                                  return;
//                                }
//                            }
//                            resolve(@NO);
//                          }
//                        }];
//    } else {
//      [self handleErrors:authError flutterArguments:arguments withFlutterResult:result];
//    }
//}
//
//- (void)handleErrors:(NSError *)authError
//     flutterArguments:(NSDictionary *)arguments
//    resolver:(RCTPromiseResolveBlock)resolve
//            rejecter:(RCTPromiseRejectBlock)reject {
//  NSString *errorCode = @"NotAvailable";
//  switch (authError.code) {
//    case LAErrorPasscodeNotSet:
//    case LAErrorTouchIDNotEnrolled:
//      if ([arguments[@"useErrorDialogs"] boolValue]) {
//        [self alertMessage:arguments[@"goToSettingDescriptionIOS"]
//                 firstButton:arguments[@"okButton"]
//               flutterResult:result
//            additionalButton:arguments[@"goToSetting"]];
//        return;
//      }
//      errorCode = authError.code == LAErrorPasscodeNotSet ? @"PasscodeNotSet" : @"NotEnrolled";
//      break;
//    case LAErrorTouchIDLockout:
//      [self alertMessage:arguments[@"lockOut"]
//               firstButton:arguments[@"okButton"]
//             flutterResult:result
//          additionalButton:nil];
//      return;
//  }
//  result([FlutterError errorWithCode:errorCode
//                             message:authError.localizedDescription
//                             details:authError.domain]);
//}


@end
