//
//  TDSensitiveMudule.m
//  TDSensitive
//
//  Created by huangdiao on 2023/11/16.
//

#import "TDSensitiveMudule.h"

#if __has_include(<ThinkingDataCore/ThinkingDataCore.h>)
#import <ThinkingDataCore/ThinkingDataCore.h>
#else
#import "ThinkingDataCore.h"
#endif

#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <WebKit/WebKit.h>

@interface TDSensitiveMudule ()

@end

static NSString * _idfa = nil;
static NSString * _ua = nil;

@implementation TDSensitiveMudule

+ (void)load {
    [TDSensitiveMudule getIdfa];
    [TDSensitiveMudule getWebViewUserAgent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analyticsInitSuccessNotification:) name:kAnalyticsNotificationNameInit object:nil];
}

+ (NSString *)idfa {
    return _idfa;
}

+ (NSString *)ua {
    return _ua;
}

+ (void)getIdfa {
    if (@available(iOS 14, *)) {
        if ([ATTrackingManager trackingAuthorizationStatus] == ATTrackingManagerAuthorizationStatusAuthorized) {
            NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            _idfa = idfa;
        }
    }
    else {
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            _idfa = idfa;
        }
    }
}

+ (void)getWebViewUserAgent {
    void (^setUserAgent)(NSString *userAgent) = ^void (NSString *userAgent) {
        _ua = userAgent;
    };
    [self wkWebViewGetUserAgent:^(NSString *userAgent) {
        setUserAgent(userAgent);
    }];
}

// MARK: private

static WKWebView *_blankWebView = nil;
+ (void)wkWebViewGetUserAgent:(void(^)(NSString *))completion {
    if (!_blankWebView) {
        _blankWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
    }
    [_blankWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id __nullable userAgent, NSError * __nullable error) {
        completion(userAgent);
    }];
}

// MARK: - notification action

+ (void)analyticsInitSuccessNotification:(NSNotification *)notification {
    // TDAnalytics 初始化之后，如果 idfa 为空，再尝试获取一次
    if (_idfa == nil) {
        [TDSensitiveMudule getIdfa];
    }
}


@end
