//
//  ThinkingPluginLibrary.h
//  TemplateApp
//
//  Copyright (c) 2012 ThinkingData. All rights reserved.
//  Created by huangdiao on 2022/9/2.
//

#ifndef _ThinkingPluginLibrary_H__
#define _ThinkingPluginLibrary_H__

#include <CoronaLua.h>
#include <CoronaMacros.h>

// This corresponds to the name of the library, e.g. [Lua] require "plugin.library"
// where the '.' is replaced with '_'
CORONA_EXPORT int luaopen_thinking_plugin_library( lua_State *L );

#endif // _ThinkingPluginLibrary_H__
