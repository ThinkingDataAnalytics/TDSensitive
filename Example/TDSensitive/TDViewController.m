//
//  TDViewController.m
//  TDSensitive
//
//  Created by huangdiao on 11/16/2023.
//  Copyright (c) 2023 huangdiao. All rights reserved.
//

#import "TDViewController.h"
#import <ThinkingSDK/ThinkingSDK.h>
#import <Masonry/Masonry.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@interface TDViewController ()

@end

@implementation TDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self loadBtns];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadBtns {
    NSArray *array = @[
        @"init_TDAnalytics",
        @"track",
        @"flush",
        @"idfa_request",
        @"idfa_clear"
    ];
    
    UIView *lastView = nil;
    for (int i=0; i<array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [[btn titleLabel] setAdjustsFontSizeToFitWidth:YES];
        [btn setBackgroundColor:UIColor.redColor];
        [btn addTarget:self action:NSSelectorFromString([NSString stringWithFormat:@"btnOnClick_%@:", array[i]]) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:UIColor.blackColor forState:UIControlStateHighlighted];
        [self.view addSubview:btn];
        if (i < 2) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(75);
            }];
        }
        else {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo((i%2==0)?lastView.mas_bottom:lastView.mas_top).offset((i%2==0)?10:00);
            }];
        }
        CGFloat _gap = 20.0f;
        CGFloat _w = (CGRectGetWidth(self.view.bounds)-_gap*3)/2.0f;
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((i%2)* _w + ((i%2)+1)*_gap);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(_w);
        }];
        lastView = btn;
    }
}

- (void)btnOnClick_init_TDAnalytics:(id)sender {
    NSLog(@" %s ", __func__);
    [TDAnalytics enableLog:YES];
    [TDAnalytics startAnalyticsWithAppId:@"7be5326f9f4a4e48933dbf2579367901"
                               serverUrl:@"https://receiver-ta-dev.thinkingdata.cn"];
}
- (void)btnOnClick_track:(id)sender {
    NSLog(@" %s ", __func__);
    [TDAnalytics track:@"start"];
}
- (void)btnOnClick_flush:(id)sender {
    NSLog(@" %s ", __func__);
    [TDAnalytics flush];
}
- (void)btnOnClick_idfa_request:(id)sender {
    NSLog(@" %s ", __func__);
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            NSLog(@"request idfa status: %lu", (unsigned long)status);
            NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            NSLog(@"idfa = %@", idfa);
        }];
    }
    else {
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            NSLog(@"idfa = %@", idfa);
        }
    }
}
- (void)btnOnClick_idfa_clear:(id)sender {
    NSLog(@" %s ", __func__);
//    [[ASIdentifierManager sharedManager] clearAdvertisingIdentifier];
}

@end
