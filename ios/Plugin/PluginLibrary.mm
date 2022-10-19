//
//  PluginLibrary.mm
//  TemplateApp
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PluginLibrary.h"

#include <CoronaRuntime.h>
#import <UIKit/UIKit.h>

//#if __has_include(<ThinkingSDK/TDEventModel.h>)
//#import <ThinkingSDK/ThinkingAnalyticsSDK.h>
//#else
//#import "ThinkingAnalyticsSDK.h"
//#endif

// ----------------------------------------------------------------------------

static NSDictionary * taConvertToDictionary(const char *json) {
    NSDictionary *propertiesDic = nil;
    NSString *jsonStr = json != nil ? [NSString stringWithUTF8String:json] : nil;
    if (jsonStr) {
        propertiesDic = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    }
    return propertiesDic?:@{};
}

// ----------------------------------------------------------------------------

class PluginLibrary
{
	public:
		typedef PluginLibrary Self;

	public:
		static const char kName[];
		static const char kEvent[];

	protected:
		PluginLibrary();

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

    public: // Thinking Analytics SDK API
        static int shareInstance( lua_State *L );
        
        static int track( lua_State *L );
        static int trackFirst( lua_State *L );
        static int trackUpdate( lua_State *L );
        static int trackOverwrite( lua_State *L );

        static int timeEvent( lua_State *L );

        static int userSet( lua_State *L );
        static int userSetOnce( lua_State *L );
        static int userUnset( lua_State *L );
        static int userAdd( lua_State *L );
        static int userAppend( lua_State *L );
        static int userUniqAppend( lua_State *L );
        static int userDel( lua_State *L );
    

        static int flush( lua_State *L );

        static int login( lua_State *L );
        static int logout( lua_State *L );
        static int identify( lua_State *L );
        static int getDistinctId( lua_State *L );
        static int getDeviceId( lua_State *L );

        static int setSuperProperties( lua_State *L );
        static int unsetSuperProperties( lua_State *L );
        static int getSuperProperties( lua_State *L );
        static int clearSuperProperties( lua_State *L );
        static int getPresetProperties( lua_State *L );
    

    
	private:
		CoronaLuaRef fListener;
};

// ----------------------------------------------------------------------------

// This corresponds to the name of the library, e.g. [Lua] require "plugin.library"
const char PluginLibrary::kName[] = "plugin.library";

// This corresponds to the event name, e.g. [Lua] event.name
const char PluginLibrary::kEvent[] = "pluginlibraryevent";

PluginLibrary::PluginLibrary()
:	fListener( NULL )
{
}

bool
PluginLibrary::Initialize( CoronaLuaRef listener )
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
PluginLibrary::Open( lua_State *L )
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

        { "shareInstance", shareInstance },
        { "track", track },
        { "trackFirst", trackFirst },
        { "trackUpdate", trackUpdate },
        { "trackOverwrite", trackOverwrite },
        { "timeEvent", timeEvent },
        { "userSet", userSet },
        { "userSetOnce", userSetOnce },
        { "userUnset", userUnset },
        { "userAdd", userAdd },
        { "userAppend", userAppend },
        { "userUniqAppend", userUniqAppend },
        { "userDel", userDel },
        { "flush", flush },
        { "login", login },
        { "logout", logout },
        { "identify", identify },
        { "getDistinctId", getDistinctId },
        { "getDeviceId", getDeviceId },
        { "setSuperProperties", setSuperProperties },
        { "unsetSuperProperties", unsetSuperProperties },
        { "getSuperProperties", getSuperProperties },
        { "clearSuperProperties", clearSuperProperties },
        { "getPresetProperties", getPresetProperties },
        
		{ NULL, NULL }
	};

	// Set library as upvalue for each library function
	Self *library = new Self;
	CoronaLuaPushUserdata( L, library, kMetatableName );

	luaL_openlib( L, kName, kVTable, 1 ); // leave "library" on top of stack

	return 1;
}

int
PluginLibrary::Finalizer( lua_State *L )
{
	Self *library = (Self *)CoronaLuaToUserdata( L, 1 );

	CoronaLuaDeleteRef( L, library->GetListener() );

	delete library;

	return 0;
}

PluginLibrary *
PluginLibrary::ToLibrary( lua_State *L )
{
	// library is pushed as part of the closure
	Self *library = (Self *)CoronaLuaToUserdata( L, lua_upvalueindex( 1 ) );
	return library;
}

// [Lua] library.init( listener )
int
PluginLibrary::init( lua_State *L )
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
PluginLibrary::show( lua_State *L )
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
PluginLibrary::hello( lua_State *L )
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

// [Lua] library.shareInstance( word )
int
PluginLibrary::shareInstance( lua_State *L )
{
    
    const char *word = lua_tostring( L, 1 );
    NSLog(@"shareInstance: %@", [[NSString alloc] initWithUTF8String:word]);
    NSString *message = @"obj-c callback msg（shareInstance）";

    NSDictionary *params = taConvertToDictionary(word);
    NSString *appId = params[@"appId"];
    NSString *serverUrl = params[@"serverUrl"];
    
//    [ThinkingAnalyticsSDK startWithAppId:appId withUrl:serverUrl];
//    
//    [[ThinkingAnalyticsSDK sharedInstance] track:@"TA"];
    
    
    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.track( word )
int
PluginLibrary::track( lua_State *L )
{
    NSString *message = @"obj-c callback msg（track）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.trackFirst( word )
int
PluginLibrary::trackFirst( lua_State *L )
{
    NSString *message = @"obj-c callback msg（trackFirst）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.trackUpdate( word )
int
PluginLibrary::trackUpdate( lua_State *L )
{
    NSString *message = @"obj-c callback msg（trackUpdate）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.trackOverwrite( word )
int
PluginLibrary::trackOverwrite( lua_State *L )
{
    NSString *message = @"obj-c callback msg（trackOverwrite）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.timeEvent( word )
int
PluginLibrary::timeEvent( lua_State *L )
{
    NSString *message = @"obj-c callback msg（timeEvent）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.userSet( word )
int
PluginLibrary::userSet( lua_State *L )
{
    NSString *message = @"obj-c callback msg（userSet）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.userSetOnce( word )
int
PluginLibrary::userSetOnce( lua_State *L )
{
    NSString *message = @"obj-c callback msg（userSetOnce）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.userUnset( word )
int
PluginLibrary::userUnset( lua_State *L )
{
    NSString *message = @"obj-c callback msg（userUnset）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.userAdd( word )
int
PluginLibrary::userAdd( lua_State *L )
{
    NSString *message = @"obj-c callback msg（userAdd）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.userAppend( word )
int
PluginLibrary::userAppend( lua_State *L )
{
    NSString *message = @"obj-c callback msg（userAppend）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.userUniqAppend( word )
int
PluginLibrary::userUniqAppend( lua_State *L )
{
    NSString *message = @"obj-c callback msg（userUniqAppend）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.userDel( word )
int
PluginLibrary::userDel( lua_State *L )
{
    NSString *message = @"obj-c callback msg（userDel）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.flush( word )
int
PluginLibrary::flush( lua_State *L )
{
    NSString *message = @"obj-c callback msg（flush）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.login( word )
int
PluginLibrary::login( lua_State *L )
{
    NSString *message = @"obj-c callback msg（login）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.logout( word )
int
PluginLibrary::logout( lua_State *L )
{
    NSString *message = @"obj-c callback msg（logout）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.identify( word )
int
PluginLibrary::identify( lua_State *L )
{
    NSString *message = @"obj-c callback msg（identify）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.getDistinctId( word )
int
PluginLibrary::getDistinctId( lua_State *L )
{
    NSString *message = @"obj-c callback msg（getDistinctId）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.getDeviceId( word )
int
PluginLibrary::getDeviceId( lua_State *L )
{
    NSString *message = @"obj-c callback msg（getDeviceId）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.setSuperProperties( word )
int
PluginLibrary::setSuperProperties( lua_State *L )
{
    NSString *message = @"obj-c callback msg（setSuperProperties）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.unsetSuperProperties( word )
int
PluginLibrary::unsetSuperProperties( lua_State *L )
{
    NSString *message = @"obj-c callback msg（unsetSuperProperties）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.getSuperProperties( word )
int
PluginLibrary::getSuperProperties( lua_State *L )
{
    NSString *message = @"obj-c callback msg（getSuperProperties）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.clearSuperProperties( word )
int
PluginLibrary::clearSuperProperties( lua_State *L )
{
    NSString *message = @"obj-c callback msg（clearSuperProperties）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// [Lua] library.getPresetProperties( word )
int
PluginLibrary::getPresetProperties( lua_State *L )
{
    NSString *message = @"obj-c callback msg（getPresetProperties）";

    Self *library = ToLibrary( L );

    // Create event and add message to it
    CoronaLuaNewEvent( L, kEvent );
    lua_pushstring( L, [message UTF8String] );
    lua_setfield( L, -2, "message" );

    // Dispatch event to library's listener
    CoronaLuaDispatchEvent( L, library->GetListener(), 0 );

    return 0;
}

// ----------------------------------------------------------------------------

CORONA_EXPORT int luaopen_plugin_library( lua_State *L )
{
	return PluginLibrary::Open( L );
}
