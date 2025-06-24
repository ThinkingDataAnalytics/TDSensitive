//
//  Target_Sensitive.m
//  TDSensitive
//
//  Created by liulongbing on 2025/5/28.
//

#import "Target_Sensitive.h"
#import "TDSensitiveMudule.h"

@implementation Target_Sensitive

- (NSDictionary *)Action_nativeGetSensitiveProperties:(id)params{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    if ([TDSensitiveMudule idfa] != nil) {
        dict[@"#idfa"] = [TDSensitiveMudule idfa];
    }
    if ([TDSensitiveMudule ua] != nil) {
        dict[@"#ua"] = [TDSensitiveMudule ua];
    }
    return dict;
}

@end
