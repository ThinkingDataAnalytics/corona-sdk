//
//  ThinkingPluginLibrary.mm
//  TemplateApp
//
//  Copyright (c) 2012 ThinkingData. All rights reserved.
//  Created by huangdiao on 2022/9/2.
//

#import "ThinkingPluginLibrary.h"

#include <CoronaRuntime.h>
#import <UIKit/UIKit.h>

#import "ThinkingPluginProxy.h"

// ----------------------------------------------------------------------------

static NSDictionary * taJsonToDictionary(const char *json) {
    NSDictionary *propertiesDic = nil;
    NSString *jsonStr = json != nil ? [NSString stringWithUTF8String:json] : nil;
    if (jsonStr != nil) {
        propertiesDic = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    }
    return propertiesDic?:@{};
}

static NSString * taDictionaryToJson(NSDictionary * params) {
    NSString *jsonStr = nil;
    if (params != nil && [params isKindOfClass:[NSDictionary class]]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:NULL];
        jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonStr?:@"";
}

// ----------------------------------------------------------------------------

class ThinkingPluginLibrary
{
	public:
		typedef ThinkingPluginLibrary Self;

	public:
		static const char kName[];
		static const char kEvent[];

	protected:
		ThinkingPluginLibrary();

	public:
		bool Initialize( CoronaLuaRef listener );

	public:
		CoronaLuaRef GetListener() const { return fListener; }

	public:
		static int Open( lua_State *L );

	protected:
		static int Finalizer( lua_State *L );

	public:
		static Self *ToLibrary( lua_State *L );

	public:
		static int init( lua_State *L );
		static int show( lua_State *L );
        static int hello( lua_State *L );

    public:
        // Thinking Analytics SDK API
        static int thinkingBridging( lua_State *L );
        
	private:
		CoronaLuaRef fListener;
};

// ----------------------------------------------------------------------------

// This corresponds to the name of the library, e.g. [Lua] require "thinking.plugin.library"
const char ThinkingPluginLibrary::kName[] = "thinking.plugin.library";

// This corresponds to the event name, e.g. [Lua] event.name
const char ThinkingPluginLibrary::kEvent[] = "thinkingpluginlibraryevent";

ThinkingPluginLibrary::ThinkingPluginLibrary()
:	fListener( NULL )
{
}

bool
ThinkingPluginLibrary::Initialize( CoronaLuaRef listener )
{
	// Can only initialize listener once
	bool result = ( NULL == fListener );

	if ( result )
	{
		fListener = listener;
	}

	return result;
}

int
ThinkingPluginLibrary::Open( lua_State *L )
{
	// Register __gc callback
	const char kMetatableName[] = __FILE__; // Globally unique string to prevent collision
	CoronaLuaInitializeGCMetatable( L, kMetatableName, Finalizer );

	// Functions in library
	const luaL_Reg kVTable[] =
	{
		{ "init", init },
		{ "show", show },
        { "hello", hello },

        { "thinkingBridging", thinkingBridging },
        
		{ NULL, NULL }
	};

	// Set library as upvalue for each library function
	Self *library = new Self;
	CoronaLuaPushUserdata( L, library, kMetatableName );

	luaL_openlib( L, kName, kVTable, 1 ); // leave "library" on top of stack

	return 1;
}

int
ThinkingPluginLibrary::Finalizer( lua_State *L )
{
	Self *library = (Self *)CoronaLuaToUserdata( L, 1 );

	CoronaLuaDeleteRef( L, library->GetListener() );

	delete library;

	return 0;
}

ThinkingPluginLibrary *
ThinkingPluginLibrary::ToLibrary( lua_State *L )
{
	// library is pushed as part of the closure
	Self *library = (Self *)CoronaLuaToUserdata( L, lua_upvalueindex( 1 ) );
	return library;
}

// [Lua] library.init( listener )
int
ThinkingPluginLibrary::init( lua_State *L )
{
	int listenerIndex = 1;

	if ( CoronaLuaIsListener( L, listenerIndex, kEvent ) )
	{
		Self *library = ToLibrary( L );

		CoronaLuaRef listener = CoronaLuaNewRef( L, listenerIndex );
		library->Initialize( listener );
	}

	return 0;
}

// [Lua] library.show( word )
int
ThinkingPluginLibrary::show( lua_State *L )
{
	NSString *message = @"Error: Could not display UIReferenceLibraryViewController. This feature requires iOS 5 or later.";
	
	if ( [UIReferenceLibraryViewController class] )
	{
		id<CoronaRuntime> runtime = (id<CoronaRuntime>)CoronaLuaGetContext( L );

		const char kDefaultWord[] = "corona";
		const char *word = lua_tostring( L, 1 );
		if ( ! word )
		{
			word = kDefaultWord;
		}

		UIReferenceLibraryViewController *controller = [[[UIReferenceLibraryViewController alloc] initWithTerm:[NSString stringWithUTF8String:word]] autorelease];

		// Present the controller modally.
		[runtime.appViewController presentViewController:controller animated:YES completion:nil];

		message = @"Success. Displaying UIReferenceLibraryViewController for 'corona'.";
	}

	Self *library = ToLibrary( L );

	// Create event and add message to it
	CoronaLuaNewEvent( L, kEvent );
	lua_pushstring( L, [message UTF8String] );
	lua_setfield( L, -2, "message" );

	// Dispatch event to library's listener
	CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

	return 0;
}

// [Lua] library.hello( word )
int
ThinkingPluginLibrary::hello( lua_State *L )
{
    NSString *message = @"obj-c callback msg";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

//thinkingBridging
// [Lua] library.thinkingBridging( word )
int
ThinkingPluginLibrary::thinkingBridging( lua_State *L )
{
    const char *word = lua_tostring( L, 1 );
    NSDictionary *params = taJsonToDictionary(word);
    NSString *method = params[@"method"];
        
    if (method != nil && method.length > 0) {
        NSDictionary *ret = [ThinkingPluginProxy performSelector:NSSelectorFromString([method stringByAppendingString:@":"]) withObject:params];
        
        if (ret != nil && [ret isKindOfClass:[NSDictionary class]] && [ret.allKeys containsObject:@"message"]) {
            
            NSString *message = taDictionaryToJson([ret objectForKey:@"message"]);
            NSString *type = [ret objectForKey:@"type"];
            Self *library = ToLibrary( L );
            // Create event and add message to it
            CoronaLuaNewEvent( L, kEvent );
            lua_pushstring( L, [message UTF8String] );
            lua_setfield( L, -2, "message" );
            lua_pushstring( L, [type UTF8String] );
            lua_setfield( L, -2, "type" );

            // Dispatch event to library's listener
            CoronaLuaDispatchEvent( L, library->GetListener(), 0 );
        }
    } else {
        NSLog(@"[Error] ThinkingPluginLibrary，the method is not existed : %s", word);
    }
        
    return 0;
}

// ----------------------------------------------------------------------------

CORONA_EXPORT int luaopen_thinking_plugin_library( lua_State *L )
{
	return ThinkingPluginLibrary::Open( L );
}
