#import "UmenganalyticsPlugin.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>

@implementation UmenganalyticsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"umenganalytics"
            binaryMessenger:[registrar messenger]];
  UmenganalyticsPlugin* instance = [[UmenganalyticsPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
  if ([@"init" isEqualToString:call.method]) {
      [self initUmengAnalytics:call];
  }else if ([@"onPageStart" isEqualToString:call.method]) {
      [self onPageStart:call];
  }else if ([@"onPageEnd" isEqualToString:call.method]) {
      [self onPageEnd:call];
  }else if ([@"onEvent" isEqualToString:call.method]) {
      [self logEventObj:call];
  }else if ([@"onError" isEqualToString:call.method]) {
      [self reportError:call];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)initUmengAnalytics:(FlutterMethodCall *)call {
    NSDictionary *arguments = [call arguments];
    if ([arguments isKindOfClass:[NSDictionary class]]) {
        NSString *appKey = arguments[@"iOSKey"];
        BOOL logEnable = [arguments[@"logEnable"] boolValue];
        BOOL encrypt = [arguments[@"encrypt"] boolValue];
        BOOL reportCrash = [arguments[@"reportCrash"] boolValue];
        [UMConfigure initWithAppkey:appKey channel:@"App Store"];
        [UMConfigure setLogEnabled:logEnable];
        [UMConfigure setEncryptEnabled:encrypt];
        [UMConfigure setEncryptEnabled:reportCrash];
    }
}

- (void)onPageStart:(FlutterMethodCall *)call {
    NSString *pageName = [call arguments];
    if (pageName.length > 0) {
        [MobClick beginLogPageView:pageName];
    }
}

- (void)onPageEnd:(FlutterMethodCall *)call {
    NSString *pageName = [call arguments];
    if (pageName.length > 0) {
        [MobClick endLogPageView:pageName];
    }
}

- (void)logEventObj:(FlutterMethodCall *)call {
    NSDictionary *arguments = [call arguments];
    if ([arguments isKindOfClass:[NSDictionary class]]) {
        NSString *event = arguments[@"event"];
        if (event.length > 0) {
            NSDictionary *data = arguments[@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                [MobClick event:event attributes:data];
            }
        }
    }
}

- (void)reportError:(FlutterMethodCall *)call {
    NSString *errorMessage = call.arguments;
    if (errorMessage.length > 0) {
        [MobClick event:@"error" label:errorMessage];
    }
}

@end
