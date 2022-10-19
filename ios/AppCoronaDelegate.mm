//
//  AppCoronaDelegate.mm
//  TemplateApp
//
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "AppCoronaDelegate.h"

#import <CoronaRuntime.h>
#import <CoronaLua.h>

#if __has_include(<ThinkingSDK/ThinkingAnalyticsSDK.h>)
#import <ThinkingSDK/ThinkingAnalyticsSDK.h>
#else
#import "ThinkingAnalyticsSDK.h"
#endif

@implementation AppCoronaDelegate

// Custom Lua Error Handling
static int MyTraceback( lua_State *L )
{
    lua_getfield(L, LUA_GLOBALSINDEX, "debug");
    if (!lua_istable(L, -1)) {
        lua_pop(L, 1);
        return 1;
    }
    lua_getfield(L, -1, "traceback");
    if (!lua_isfunction(L, -1)) {
        lua_pop(L, 2);
        return 1;
    }
    lua_pushvalue(L, 1);  // pass error message
    lua_pushinteger(L, 1);  // skip this function and traceback
    lua_call(L, 2, 1);  // call debug.traceback
 
    // Log result of calling debug.traceback()
    NSLog( @"[LUA ERROR]: %s", lua_tostring( L, -1 ) );
 
    return 1;
}

- (void)willLoadMain:(id<CoronaRuntime>)runtime
{
    // Custom Lua Error Handling
    Corona::Lua::SetErrorHandler( MyTraceback );
}

- (void)didLoadMain:(id<CoronaRuntime>)runtime
{
//    NSString *APP_ID = @"22e445595b0f42bd8c5fe35bc44b88d6";
//    NSString *SERVER_URL = @"https://receiver-ta-dev.thinkingdata.cn";
//    [ThinkingAnalyticsSDK setLogLevel:TDLoggingLevelDebug];
//    [ThinkingAnalyticsSDK startWithAppId:APP_ID withUrl:SERVER_URL];
//    [[ThinkingAnalyticsSDK sharedInstance] track:@"event_name"];
//    [[ThinkingAnalyticsSDK sharedInstance] flush];
    
    // dispatch delegate event
    // [self dispatch_delegate_event:runtime];
}

// dispatch delegate event
- (void)dispatch_delegate_event:(id<CoronaRuntime>)runtime {
    lua_State *L = runtime.L;

    // DISPATCH CUSTOM EVENT
    // Create 'delegate' event
    const char kNameKey[] = "name";
    const char kValueKey[] = "delegate";
    lua_newtable( L );
    lua_pushstring( L, kValueKey );     // All events are Lua tables
    lua_setfield( L, -2, kNameKey );    // that have a 'name' property

    Corona::Lua::DispatchRuntimeEvent( L, -1 );
}

#pragma mark UIApplicationDelegate methods

// The following are stubs for common delegate methods. Uncomment and implement
// the ones you wish to be called. Or add additional delegate methods that
// you wish to be called.

/*
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
*/

/*
- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
*/

/*
- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
*/

/*
- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
*/

/*
- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
*/

@end
