//
//  ThinkingPluginProxy.m
//  App
//
//  Copyright (c) 2012 ThinkingData. All rights reserved.
//  Created by huangdiao on 2022/9/2.
//

#import "ThinkingPluginProxy.h"

#if __has_include(<ThinkingSDK/TDEventModel.h>)
#import <ThinkingSDK/ThinkingAnalyticsSDK.h>
#else
#import "ThinkingAnalyticsSDK.h"
#endif

@implementation ThinkingPluginProxy

+ (void)shareInstance:(NSDictionary *)params {
    NSString *appId = params[@"appId"];
    NSString *serverUrl = params[@"serverUrl"];
    NSString *debugMode = params[@"debugMode"];
    BOOL enableLog = [params[@"enableLog"] boolValue];
    NSArray *autoTrack = params[@"autoTrack"];

    if (enableLog) {
        [ThinkingAnalyticsSDK setLogLevel:TDLoggingLevelDebug];
    } else {
        [ThinkingAnalyticsSDK setLogLevel:TDLoggingLevelNone];
    }
    TDConfig *config = [TDConfig defaultTDConfig];
    config.appid = appId;
    config.configureURL = serverUrl;
    if ([debugMode isEqualToString:@"debug"]) {
        config.debugMode = ThinkingAnalyticsDebugOn;
    } else if ([debugMode isEqualToString:@"debugOnly"]) {
        config.debugMode = ThinkingAnalyticsDebugOnly;
    } else {
        config.debugMode = ThinkingAnalyticsDebugOff;
    }
    ThinkingAnalyticsAutoTrackEventType autoTrackType = ThinkingAnalyticsEventTypeNone;
    if ([autoTrack containsObject:@"appInstall"]) {
        autoTrackType = autoTrackType | ThinkingAnalyticsEventTypeAppInstall;
    }
    if ([autoTrack containsObject:@"appStart"]) {
        autoTrackType = autoTrackType | ThinkingAnalyticsEventTypeAppStart;
    }
    if ([autoTrack containsObject:@"appEnd"]) {
        autoTrackType = autoTrackType | ThinkingAnalyticsEventTypeAppEnd;
    }
    config.autoTrackEventType = autoTrackType;
    
    [ThinkingAnalyticsSDK startWithConfig:config];
}

+ (void)track:(NSDictionary *)params {
    NSString *eventName = params[@"eventName"];
    NSDictionary *properties = params[@"properties"];
    [[ThinkingAnalyticsSDK sharedInstance] track:eventName
                                      properties:properties
                                            time:[NSDate new]
                                        timeZone:[NSTimeZone defaultTimeZone]];
}

+ (void)trackFirst:(NSDictionary *)params {
    NSString *eventName = params[@"eventName"];
    NSString *eventId = params[@"eventId"];
    NSDictionary *properties = params[@"properties"];
    TDFirstEventModel *eventModel = [[TDFirstEventModel alloc] initWithEventName:eventName firstCheckID:eventId];
    eventModel.properties = properties;
    [[ThinkingAnalyticsSDK sharedInstance] trackWithEventModel:eventModel];
}

+ (void)trackUpdate:(NSDictionary *)params {
    NSString *eventName = params[@"eventName"];
    NSString *eventId = params[@"eventId"];
    NSDictionary *properties = params[@"properties"];
    TDUpdateEventModel *eventModel = [[TDUpdateEventModel alloc] initWithEventName:eventName eventID:eventId];
    eventModel.properties = properties;
    [[ThinkingAnalyticsSDK sharedInstance] trackWithEventModel:eventModel];
}

+ (void)trackOverwrite:(NSDictionary *)params {
    NSString *eventName = params[@"eventName"];
    NSString *eventId = params[@"eventId"];
    NSDictionary *properties = params[@"properties"];
    TDOverwriteEventModel *eventModel = [[TDOverwriteEventModel alloc] initWithEventName:eventName eventID:eventId];
    eventModel.properties = properties;
    [[ThinkingAnalyticsSDK sharedInstance] trackWithEventModel:eventModel];
}

+ (void)timeEvent:(NSDictionary *)params {
    NSString *eventName = params[@"eventName"];
    [[ThinkingAnalyticsSDK sharedInstance] timeEvent:eventName];
}

+ (void)userSet:(NSDictionary *)params {
    NSDictionary *properties = params[@"properties"];
    [[ThinkingAnalyticsSDK sharedInstance] user_set:properties];
}

+ (void)userSetOnce:(NSDictionary *)params {
    NSDictionary *properties = params[@"properties"];
    [[ThinkingAnalyticsSDK sharedInstance] user_setOnce:properties];
}

+ (void)userUnset:(NSDictionary *)params {
    NSString *property = params[@"property"];
    [[ThinkingAnalyticsSDK sharedInstance] user_unset:property];
}

+ (void)userAdd:(NSDictionary *)params {
    NSDictionary *properties = params[@"properties"];
    [[ThinkingAnalyticsSDK sharedInstance] user_add:properties];
}

+ (void)userAppend:(NSDictionary *)params {
    NSDictionary *properties = params[@"properties"];
    [[ThinkingAnalyticsSDK sharedInstance] user_append:properties];
}

+ (void)userUniqAppend:(NSDictionary *)params {
    NSDictionary *properties = params[@"properties"];
    [[ThinkingAnalyticsSDK sharedInstance] user_uniqAppend:properties];
}

+ (void)userDel:(NSDictionary *)params {
    [[ThinkingAnalyticsSDK sharedInstance] user_delete];
}

+ (void)flush:(NSDictionary *)params {
    [[ThinkingAnalyticsSDK sharedInstance] flush];
}

+ (void)login:(NSDictionary *)params {
    NSString *accountId = params[@"accountId"];
    [[ThinkingAnalyticsSDK sharedInstance] login:accountId];
}

+ (void)logout:(NSDictionary *)params {
    [[ThinkingAnalyticsSDK sharedInstance] logout];
}

+ (void)identify:(NSDictionary *)params {
    NSString *distinctId = params[@"distinctId"];
    [[ThinkingAnalyticsSDK sharedInstance] identify:distinctId];
}

+ (NSDictionary *)getDistinctId:(NSDictionary *)params {
    NSString *distinctId = [[ThinkingAnalyticsSDK sharedInstance] getDistinctId];
    NSDictionary *ret = @{
        @"message": @{ @"distinctId": distinctId },
        @"type": @"getDistinctId"
    };
    return ret;
}

+ (NSDictionary *)getDeviceId:(NSDictionary *)params {
    NSString *deviceId = [[ThinkingAnalyticsSDK sharedInstance] getDeviceId];
    NSDictionary *ret = @{
        @"message": @{ @"deviceId": deviceId },
        @"type": @"getDeviceId"
    };
    return ret;
}

+ (void)setSuperProperties:(NSDictionary *)params {
    NSDictionary *properties = params[@"properties"];
    [[ThinkingAnalyticsSDK sharedInstance] setSuperProperties:properties];
}

+ (void)unsetSuperProperties:(NSDictionary *)params {
    NSString *property = params[@"property"];
    [[ThinkingAnalyticsSDK sharedInstance] unsetSuperProperty:property];
}

+ (NSDictionary *)getSuperProperties:(NSDictionary *)params {
    NSDictionary *properties = [[ThinkingAnalyticsSDK sharedInstance] currentSuperProperties];
    NSDictionary *ret = @{
        @"message": @{ @"properties": properties },
        @"type": @"getSuperProperties"
    };
    return ret;
}

+ (void)clearSuperProperties:(NSDictionary *)params {
    [[ThinkingAnalyticsSDK sharedInstance] clearSuperProperties];
}

+ (NSDictionary *)getPresetProperties:(NSDictionary *)params {
    NSDictionary *properties = [[[ThinkingAnalyticsSDK sharedInstance] getPresetProperties] toEventPresetProperties];
    NSDictionary *ret = @{
        @"message": @{ @"properties": properties },
        @"type": @"getPresetProperties"
    };
    return ret;
}

+ (void)setCustomerLibInfo:(NSDictionary *)params {
    NSString *libName = params[@"libName"];
    NSString *libVersion = params[@"libVersion"];
    [ThinkingAnalyticsSDK setCustomerLibInfoWithLibName:libName libVersion:libVersion];
}

@end
