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

+ (ThinkingAnalyticsSDK *)sharedInstance:(NSString *)appId {
    ThinkingAnalyticsSDK * instance = nil;
    if (appId != nil && [appId length] > 0) {
        instance = [ThinkingAnalyticsSDK sharedInstanceWithAppid:appId];
    }
    if (instance == nil) {
        instance = [ThinkingAnalyticsSDK sharedInstance];
    }
    return instance;
}

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
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] track:eventName
                                      properties:properties];
}

+ (void)trackFirst:(NSDictionary *)params {
    NSString *eventName = params[@"eventName"];
    NSString *eventId = params[@"eventId"];
    NSDictionary *properties = params[@"properties"];
    TDFirstEventModel *eventModel = [[TDFirstEventModel alloc] initWithEventName:eventName firstCheckID:eventId];
    eventModel.properties = properties;
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] trackWithEventModel:eventModel];
}

+ (void)trackUpdate:(NSDictionary *)params {
    NSString *eventName = params[@"eventName"];
    NSString *eventId = params[@"eventId"];
    NSDictionary *properties = params[@"properties"];
    TDUpdateEventModel *eventModel = [[TDUpdateEventModel alloc] initWithEventName:eventName eventID:eventId];
    eventModel.properties = properties;
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] trackWithEventModel:eventModel];
}

+ (void)trackOverwrite:(NSDictionary *)params {
    NSString *eventName = params[@"eventName"];
    NSString *eventId = params[@"eventId"];
    NSDictionary *properties = params[@"properties"];
    TDOverwriteEventModel *eventModel = [[TDOverwriteEventModel alloc] initWithEventName:eventName eventID:eventId];
    eventModel.properties = properties;
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] trackWithEventModel:eventModel];
}

+ (void)timeEvent:(NSDictionary *)params {
    NSString *eventName = params[@"eventName"];
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] timeEvent:eventName];
}

+ (void)userSet:(NSDictionary *)params {
    NSDictionary *properties = params[@"properties"];
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] user_set:properties];
}

+ (void)userSetOnce:(NSDictionary *)params {
    NSDictionary *properties = params[@"properties"];
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] user_setOnce:properties];
}

+ (void)userUnset:(NSDictionary *)params {
    NSString *property = params[@"property"];
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] user_unset:property];
}

+ (void)userAdd:(NSDictionary *)params {
    NSDictionary *properties = params[@"properties"];
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] user_add:properties];
}

+ (void)userAppend:(NSDictionary *)params {
    NSDictionary *properties = params[@"properties"];
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] user_append:properties];
}

+ (void)userUniqAppend:(NSDictionary *)params {
    NSDictionary *properties = params[@"properties"];
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] user_uniqAppend:properties];
}

+ (void)userDel:(NSDictionary *)params {
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] user_delete];
}

+ (void)flush:(NSDictionary *)params {
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] flush];
}

+ (void)login:(NSDictionary *)params {
    NSString *accountId = params[@"accountId"];
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] login:accountId];
}

+ (void)logout:(NSDictionary *)params {
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] logout];
}

+ (void)identify:(NSDictionary *)params {
    NSString *distinctId = params[@"distinctId"];
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] identify:distinctId];
}

+ (NSDictionary *)getDistinctId:(NSDictionary *)params {
    NSString *appId = params[@"appId"];
    NSString *distinctId = [[ThinkingPluginProxy sharedInstance:appId] getDistinctId];
    NSDictionary *ret = @{
        @"message": @{ @"distinctId": distinctId },
        @"type": @"getDistinctId"
    };
    return ret;
}

+ (NSDictionary *)getDeviceId:(NSDictionary *)params {
    NSString *appId = params[@"appId"];
    NSString *deviceId = [[ThinkingPluginProxy sharedInstance:appId] getDeviceId];
    NSDictionary *ret = @{
        @"message": @{ @"deviceId": deviceId },
        @"type": @"getDeviceId"
    };
    return ret;
}

+ (void)setSuperProperties:(NSDictionary *)params {
    NSDictionary *properties = params[@"properties"];
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] setSuperProperties:properties];
}

+ (void)unsetSuperProperties:(NSDictionary *)params {
    NSString *property = params[@"property"];
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] unsetSuperProperty:property];
}

+ (NSDictionary *)getSuperProperties:(NSDictionary *)params {
    NSString *appId = params[@"appId"];
    NSDictionary *properties = [[ThinkingPluginProxy sharedInstance:appId] currentSuperProperties];
    NSDictionary *ret = @{
        @"message": @{ @"properties": properties },
        @"type": @"getSuperProperties"
    };
    return ret;
}

+ (void)clearSuperProperties:(NSDictionary *)params {
    NSString *appId = params[@"appId"];
    [[ThinkingPluginProxy sharedInstance:appId] clearSuperProperties];
}

+ (NSDictionary *)getPresetProperties:(NSDictionary *)params {
    NSString *appId = params[@"appId"];
    NSDictionary *properties = [[[ThinkingPluginProxy sharedInstance:appId] getPresetProperties] toEventPresetProperties];
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

+ (void)calibrateTime:(NSDictionary *)params {
    NSTimeInterval timestamp = [params[@"timestamp"] doubleValue];
    [ThinkingAnalyticsSDK calibrateTime:timestamp];
}

+ (void)calibrateTimeWithNtp:(NSDictionary *)params {
    NSString *ntpServer = params[@"ntpServer"];
    [ThinkingAnalyticsSDK calibrateTimeWithNtp:ntpServer];
}

@end
